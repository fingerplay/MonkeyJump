//
//  AdManager.h
//  JumpMonkey
//
//  Created by 罗谨 on 2019/11/6.
//  Copyright © 2019 finger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GDTRewardVideoAd.h>
NS_ASSUME_NONNULL_BEGIN

//点击广告回调
typedef void(^AdClickCallback)(NSString*);

//关闭广告回调
typedef void(^AdCloseCallback)(NSString*);

//观看完广告回调
typedef void(^AdWatchOverCallback)(NSString*);
NS_ASSUME_NONNULL_END

@interface AdManager : NSObject<GDTRewardedVideoAdDelegate>
@property (nonatomic, strong) GDTRewardVideoAd *rewardVideoAd;

+ (instancetype)sharedManager;

//每次加载新的广告会把之前的广告清除
- (void)loadVideoAd;

//显示最近一次加载的广告,如果长时间不loadVideoAd有可能会过期
- (BOOL)showVideoAdFromViewController:(UIViewController*)viewController clickCallback:(AdClickCallback)clickCallback watchOverCallback:(AdWatchOverCallback)watchOverCallback closeCallback:(AdCloseCallback)closeCallback;

- (BOOL)checkLifeCountAndShowAdInViewController:(UIViewController*)viewController;
@end


