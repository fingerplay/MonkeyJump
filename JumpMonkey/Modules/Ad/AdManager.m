//
//  AdManager.m
//  JumpMonkey
//
//  Created by 罗谨 on 2019/11/6.
//  Copyright © 2019 finger. All rights reserved.
//

#import "AdManager.h"
#import "UserAccountManager.h"

#ifdef ABROAD
#import <GoogleMobileAds/GoogleMobileAds.h>
#else
#import <GDTRewardVideoAd.h>
#endif

@interface AdManager ()<
#ifdef ABROAD
//GADRewardBasedVideoAdDelegate
GADInterstitialDelegate
#else
GDTRewardedVideoAdDelegate
#endif
>
#ifndef ABROAD
@property (nonatomic, strong) GDTRewardVideoAd *rewardVideoAd;
#else

@property(nonatomic, strong) GADInterstitial *interstitial;
#endif
@property (nonatomic,copy) AdClickCallback clickCallback;
@property (nonatomic,copy) AdWatchOverCallback watchOverCallback;
@property (nonatomic,copy) AdCloseCallback closeCallback;

@property (nonatomic,assign) BOOL hasClicked;//记录某个广告是否点击过，防止重复点击导致重复加分
@end

@implementation AdManager

static AdManager *_sharedInstance = nil;
+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[AdManager alloc] init];
    });
    return _sharedInstance;
}

- (void)loadVideoAd {
 
#ifdef ABROAD
//    [GADRewardBasedVideoAd sharedInstance].delegate = self;
//    [[GADRewardBasedVideoAd sharedInstance] loadRequest:[GADRequest request]
//                                           withAdUnitID:kGADMobLiftEmptyRewardAdUnitId];
    self.interstitial = [[GADInterstitial alloc]
                         initWithAdUnitID:kGADMobLifeEmptyInterstitialAdUnitId];
    self.interstitial.delegate = self;
    GADRequest *request = [GADRequest request];
    [self.interstitial loadRequest:request];
#else
    NSString *placementId = kGDTVideoAdPlaceId;
    self.rewardVideoAd = [[GDTRewardVideoAd alloc] initWithAppId:kGDTMobSDKAppId placementId:placementId];
    self.rewardVideoAd.delegate = self;
    [self.rewardVideoAd loadAd];
#endif
    _hasClicked = NO;
}

- (BOOL)showVideoAdFromViewController:(UIViewController*)viewController clickCallback:(AdClickCallback)clickCallback watchOverCallback:(AdWatchOverCallback)watchOverCallback closeCallback:(AdCloseCallback)closeCallback {
    self.clickCallback = clickCallback;
    self.watchOverCallback = watchOverCallback;
    self.closeCallback = closeCallback;
    
#ifdef ABROAD
//    if ([[GADRewardBasedVideoAd sharedInstance] isReady]) {
//        [[GADRewardBasedVideoAd sharedInstance] presentFromRootViewController:viewController];
//        return true;
//    }else{
//        return false;
//    }
    if (self.interstitial.isReady) {
        [self.interstitial presentFromRootViewController:viewController];
        return true;
    } else {
        NSLog(@"Ad wasn't ready");
        return false;
    }
#else
    if (self.rewardVideoAd.expiredTimestamp <= [[NSDate date] timeIntervalSince1970] || !self.rewardVideoAd.isAdValid) {
        [self loadVideoAd];
        return false;
    }
    [self.rewardVideoAd showAdFromRootViewController:viewController];
    return true;
#endif
}

- (BOOL)checkLifeCountAndShowAdInViewController:(UIViewController*)viewController {
    if ([UserAccountManager sharedManager].lifeInfo.lifeCount <= 0) {
        //显示广告
        UIAlertAction *watchAd = [UIAlertAction actionWithTitle:@"观看广告" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            BOOL show = [[AdManager sharedManager] showVideoAdFromViewController:viewController clickCallback:^(NSString * placementId) {
                [[UserAccountManager sharedManager].lifeInfo gainLifeByReadAd];
            } watchOverCallback:nil closeCallback:nil];
            if (!show) {
                [[SHToastView sharedInstance] showOnView:viewController.view withMessage:@"广告加载失败，请稍后重试"];
            }
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        NSString *message = [NSString stringWithFormat:@"你可以观看广告并点击下载来获得%d点生命值",AD_LIFE_COUNT];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"你的生命值已用完" message:message preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:watchAd];
        [alert addAction:cancel];
        [viewController presentViewController:alert animated:YES completion:nil];
        //        [[SHToastView sharedInstance] showOnView:self.view withMessage:@"显示广告"];
        
        return false;
    }
    return true;
}



#pragma mark - Google Mobile Ad
#ifdef ABROAD
/// Tells the delegate an ad request succeeded.
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad {
    NSLog(@"interstitialDidReceiveAd");
}

/// Tells the delegate an ad request failed.
- (void)interstitial:(GADInterstitial *)ad
didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"interstitial:didFailToReceiveAdWithError: %@", [error localizedDescription]);
}

/// Tells the delegate that an interstitial will be presented.
- (void)interstitialWillPresentScreen:(GADInterstitial *)ad {
    NSLog(@"interstitialWillPresentScreen");
}

/// Tells the delegate the interstitial is to be animated off the screen.
- (void)interstitialWillDismissScreen:(GADInterstitial *)ad {
    NSLog(@"interstitialWillDismissScreen");
}

/// Tells the delegate the interstitial had been animated off the screen.
- (void)interstitialDidDismissScreen:(GADInterstitial *)ad {
    NSLog(@"interstitialDidDismissScreen");
    [self loadVideoAd];
}

/// Tells the delegate that a user click will open another app
/// (such as the App Store), backgrounding the current app.
- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad {
    NSLog(@"interstitialWillLeaveApplication");
}

//- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
//   didRewardUserWithReward:(GADAdReward *)reward {
//    NSString *rewardMessage =
//    [NSString stringWithFormat:@"Reward received with currency %@ , amount %lf",
//     reward.type,
//     [reward.amount doubleValue]];
//    NSLog(@"%@", rewardMessage);
//}
//
//- (void)rewardBasedVideoAdDidReceiveAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
//    NSLog(@"Reward based video ad is received.");
//}
//
//- (void)rewardBasedVideoAdDidOpen:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
//    NSLog(@"Opened reward based video ad.");
//}
//
//- (void)rewardBasedVideoAdDidStartPlaying:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
//    NSLog(@"Reward based video ad started playing.");
//}
//
//- (void)rewardBasedVideoAdDidCompletePlaying:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
//    NSLog(@"Reward based video ad has completed.");
//    if (self.watchOverCallback) {
//        self.watchOverCallback(rewardBasedVideoAd.userIdentifier);
//    }
//}
//
//- (void)rewardBasedVideoAdDidClose:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
//    NSLog(@"Reward based video ad is closed.");
//    if (self.closeCallback) {
//        self.closeCallback(rewardBasedVideoAd.userIdentifier);
//    }
//    [[GADRewardBasedVideoAd sharedInstance] loadRequest:[GADRequest request]
//                                           withAdUnitID:kGADMobLiftEmptyRewardAdUnitId];
//}
//
//- (void)rewardBasedVideoAdWillLeaveApplication:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
//    NSLog(@"Reward based video ad will leave application.");
//}
//
//- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
//    didFailToLoadWithError:(NSError *)error {
//    NSLog(@"Reward based video ad failed to load.error:%@",error);
//}
#else
#pragma mark - GDTRewardVideoAdDelegate
- (void)gdt_rewardVideoAdDidLoad:(GDTRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"%s",__FUNCTION__);
    //    self.statusLabel.text = [NSString stringWithFormat:@"%@ 广告数据加载成功", rewardedVideoAd.adNetworkName];
    NSLog(@"eCPM:%ld eCPMLevel:%@", [rewardedVideoAd eCPM], [rewardedVideoAd eCPMLevel]);
}


- (void)gdt_rewardVideoAdVideoDidLoad:(GDTRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"%s",__FUNCTION__);
    //    self.statusLabel.text = [NSString stringWithFormat:@"%@ 视频文件加载成功", rewardedVideoAd.adNetworkName];
}


- (void)gdt_rewardVideoAdWillVisible:(GDTRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"视频播放页即将打开");
}

- (void)gdt_rewardVideoAdDidExposed:(GDTRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"%s",__FUNCTION__);
    //    self.statusLabel.text = [NSString stringWithFormat:@"%@ 广告已曝光", rewardedVideoAd.adNetworkName];
    NSLog(@"广告已曝光");
}

- (void)gdt_rewardVideoAdDidClose:(GDTRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"%s",__FUNCTION__);
    //    self.statusLabel.text = [NSString stringWithFormat:@"%@ 广告已关闭", rewardedVideoAd.adNetworkName];
    NSLog(@"广告已关闭");
    if (self.closeCallback ) {
        self.closeCallback(rewardedVideoAd.placementId);
    }
}


- (void)gdt_rewardVideoAdDidClicked:(GDTRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"%s",__FUNCTION__);
    //    self.statusLabel.text = [NSString stringWithFormat:@"%@ 广告已点击", rewardedVideoAd.adNetworkName];
    NSLog(@"广告已点击");
    if (self.clickCallback&& !_hasClicked) {
        self.clickCallback(rewardedVideoAd.placementId);
        _hasClicked = YES;
    }
}

- (void)gdt_rewardVideoAd:(GDTRewardVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error
{
    NSLog(@"%s",__FUNCTION__);
    if (error.code == 4014) {
        NSLog(@"请拉取到广告后再调用展示接口");
        //        self.statusLabel.text = @"请拉取到广告后再调用展示接口";
    } else if (error.code == 4016) {
        NSLog(@"应用方向与广告位支持方向不一致");
        //        self.statusLabel.text = @"应用方向与广告位支持方向不一致";
    } else if (error.code == 5012) {
        NSLog(@"广告已过期");
        //        self.statusLabel.text = @"广告已过期";
    } else if (error.code == 4015) {
        NSLog(@"广告已经播放过，请重新拉取");
        //        self.statusLabel.text = @"广告已经播放过，请重新拉取";
    } else if (error.code == 5002) {
        NSLog(@"视频下载失败");
        //        self.statusLabel.text = @"视频下载失败";
    } else if (error.code == 5003) {
        NSLog(@"视频播放失败");
        //        self.statusLabel.text = @"视频播放失败";
    } else if (error.code == 5004) {
        NSLog(@"没有合适的广告");
        //        self.statusLabel.text = @"没有合适的广告";
    } else if (error.code == 5013) {
        NSLog(@"请求太频繁，请稍后再试");
        //        self.statusLabel.text = @"请求太频繁，请稍后再试";
    } else if (error.code == 3002) {
        NSLog(@"网络连接超时");
        //        self.statusLabel.text = @"网络连接超时";
    }
    NSLog(@"ERROR: %@", error);
}

- (void)gdt_rewardVideoAdDidRewardEffective:(GDTRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"播放达到激励条件");
}

- (void)gdt_rewardVideoAdDidPlayFinish:(GDTRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"视频播放结束");
    if (self.watchOverCallback) {
        self.watchOverCallback(rewardedVideoAd.placementId);
    }
}
#endif
@end
