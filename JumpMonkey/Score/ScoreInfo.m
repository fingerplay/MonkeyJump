//
//  ScoreInfo.m
//  JumpMonkey
//
//  Created by 罗谨 on 2019/5/29.
//  Copyright © 2019 finger. All rights reserved.
//

#import "ScoreInfo.h"

@interface ScoreInfo ()

@property (nonatomic, assign) NSInteger mHopsScore;
@property (nonatomic, assign) NSInteger mHooksScore;
@property (nonatomic, assign) NSInteger mHawkScore;

@end

@implementation ScoreInfo

- (instancetype)init {
    self = [super init];
    if (self) {
        self.mCurrentHops = 0;
        self.mMaxHops = 0;
    }
    return self;
}

- (void)updateHopsScore {
    self.mCurrentHops++;
    self.mMaxHops = self.mMaxHops > self.mCurrentHops ? self.mMaxHops : self.mCurrentHops;
    
    if(self.mCurrentHops <= 1){
        // do nothing;
        _lastAccScore = 0;
    } else {
        _lastAccScore = self.mCurrentHops - 1;
    }
    
    self.mHopsScore += self.lastAccScore;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(scoreDidUpdate:)]) {
        [self.delegate scoreDidUpdate:self.score];
    }
}

- (void)updateHooksScore:(NSInteger)hooksNumber {
    self.mHooksScore = BASE_HOOK_SCORE * hooksNumber;
    if (self.delegate && [self.delegate respondsToSelector:@selector(scoreDidUpdate:)]) {
        [self.delegate scoreDidUpdate:self.score];
    }
}

- (void)updateHawkScore:(NSInteger)hawkNumber {
    self.catchHawkCount = hawkNumber;
    _lastAccScore = BASE_HAWK_SCORE;
    self.mHawkScore = BASE_HAWK_SCORE * hawkNumber;
}

- (void)clearScore {
    _lastAccScore = 0;
    self.mHopsScore = 0;
    self.mHooksScore = 0;
    self.mHawkScore = 0;
}

- (void)clearHops {
    self.mCurrentHops = 0;
}



- (NSInteger)score {
    
    return self.mHooksScore + self.mHopsScore + self.mHawkScore;
//    return self.mHopsScore;
}
@end
