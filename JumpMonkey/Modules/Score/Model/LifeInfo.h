//
//  LifeInfo.h
//  JumpMonkey
//
//  Created by 罗谨 on 2019/10/27.
//  Copyright © 2019 finger. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LifeInfo : NSObject<NSCoding>
@property (nonatomic, assign, readonly) NSInteger lifeCount; //生命值
@property (nonatomic, assign, readonly) NSTimeInterval lastGainLifeTime; //上一次领取生命值的时间

- (BOOL)gainLifeByClockIn; //每日打卡领取生命

- (void)gainLifeByReadAd; //点击或阅读广告领取生命

- (BOOL)subtractLifeByDrop; //掉落扣取生命
@end

NS_ASSUME_NONNULL_END
