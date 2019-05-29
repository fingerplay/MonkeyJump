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
    } else if (hopsNumber < 3){
        self.mHopsScore += 1;
    } else {
        self.mHopsScore += hopsNumber/3 * 2;
    }
}

- (void)updateHooksScore:(NSInteger)hooksNumber {
    self.mHooksScore = BASE_HOOK_SCORE * hooksNumber;
}

- (NSInteger)score {
//    return self.mHooksScore + self.mHopsScore;
    return self.mHopsScore;
}
@end
