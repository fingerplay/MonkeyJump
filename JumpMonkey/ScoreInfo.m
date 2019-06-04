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
@end

@implementation ScoreInfo

- (void)updateHopsScore:(NSInteger)hopsNumber {
    if(hopsNumber <= 1){
        // do nothing;
        _lastAccScore = 0;
    } else if (hopsNumber < 3){
        _lastAccScore = 1;
    } else {
        _lastAccScore = hopsNumber/3 * 2;
    }
    
    self.mHopsScore += self.lastAccScore;
}

- (void)updateHooksScore:(NSInteger)hooksNumber {
    self.mHooksScore = BASE_HOOK_SCORE * hooksNumber;
}

- (void)clearScore {
    _lastAccScore = 0;
    self.mHopsScore = 0;
    self.mHooksScore = 0;
}

- (NSInteger)score {
//    return self.mHooksScore + self.mHopsScore;
    return self.mHopsScore;
}
@end
