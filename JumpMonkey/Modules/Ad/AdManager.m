//
//  AdManager.m
//  JumpMonkey
//
//  Created by 罗谨 on 2019/11/6.
//  Copyright © 2019 finger. All rights reserved.
//

#import "AdManager.h"
#import "UserAccountManager.h"

@interface AdManager ()
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
    NSString *placementId = kGDTVideoAdPlaceId;
    self.rewardVideoAd = [[GDTRewardVideoAd alloc] initWithAppId:kGDTMobSDKAppId placementId:placementId];
    self.rewardVideoAd.delegate = self;
    [self.rewardVideoAd loadAd];
    _hasClicked = NO;
}

- (BOOL)showVideoAdFromViewController:(UIViewController*)viewController clickCallback:(AdClickCallback)clickCallback watchOverCallback:(AdWatchOverCallback)watchOverCallback closeCallback:(AdCloseCallback)closeCallback {
    if (self.rewardVideoAd.expiredTimestamp <= [[NSDate date] timeIntervalSince1970] || !self.rewardVideoAd.isAdValid) {
        [self loadVideoAd];
        return false;
    }
    self.clickCallback = clickCallback;
    self.watchOverCallback = watchOverCallback;
    self.closeCallback = closeCallback;
    
    [self.rewardVideoAd showAdFromRootViewController:viewController];
    return true;
}

- (BOOL)checkLifeCountAndShowAdInViewController:(UIViewController*)viewController {
    if ([UserAccountManager sharedManager].lifeInfo.lifeCount <= 0) {
        //显示广告
        UIAlertAction *watchAd = [UIAlertAction actionWithTitle:@"观看广告" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[AdManager sharedManager] showVideoAdFromViewController:viewController clickCallback:^(NSString * placementId) {
                [[UserAccountManager sharedManager].lifeInfo gainLifeByReadAd];
            } watchOverCallback:nil closeCallback:nil];
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
@end
