//
//  LifeInfo.m
//  JumpMonkey
//
//  Created by 罗谨 on 2019/10/27.
//  Copyright © 2019 finger. All rights reserved.
//

#import "LifeInfo.h"

@interface LifeInfo ()
@property (nonatomic, assign, readwrite) NSInteger lifeCount; //生命值
@property (nonatomic, assign, readwrite) NSTimeInterval lastGainLifeTime; //上一次签到领取生命值的时间
@end

@implementation LifeInfo
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.lifeCount = [aDecoder decodeIntegerForKey:@"lifeCount"];
        self.lastGainLifeTime = [aDecoder decodeDoubleForKey:@"lastGainLifeTime"];
    }
    return self;
}

- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    [aCoder encodeInteger:self.lifeCount forKey:@"lifeCount"];
    [aCoder encodeDouble:self.lastGainLifeTime forKey:@"lastGainLifeTime"];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.lifeCount = INITIAL_LIFE_COUNT;
    }
    return self;
}

- (BOOL)gainLifeByClockIn {
    if (self.lifeCount >=  INITIAL_LIFE_COUNT) { //超过100不能领取
        return false;
    }
    
    NSDate *currentDay = [NSDate date];
    NSDate *lastGainDay = [NSDate dateWithTimeIntervalSince1970:_lastGainLifeTime];
    if (currentDay.dateAtStartOfDay <= lastGainDay.dateAtStartOfDay) { //当天不能重复领取
        return false;
    }
    
    self.lifeCount = MIN(self.lifeCount + CLOCK_IN_LIFE_COUNT, INITIAL_LIFE_COUNT);
    self.lastGainLifeTime = [currentDay timeIntervalSince1970];
    return true;
}

- (void)gainLifeByReadAd {
    self.lifeCount +=  AD_LIFE_COUNT;
}

- (BOOL)subtractLifeByDrop {
    if (self.lifeCount <= 0) {
        return false;
    }
    self.lifeCount = MAX(self.lifeCount - 1, 0);
    return true;
}

@end
