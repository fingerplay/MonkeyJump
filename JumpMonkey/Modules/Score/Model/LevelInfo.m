//
//  LevelInfo.m
//  JumpMonkey
//
//  Created by 罗谨 on 2019/10/19.
//  Copyright © 2019 finger. All rights reserved.
//

#import "LevelInfo.h"

@implementation LevelInfo

- (instancetype)init {
    self = [super init];
    if (self) {
        self.level = 1;
        self.upgradeProgress = 0;
    }
    return self;
}

- (void)updateWithScore:(NSInteger)score {
    NSInteger level = 1;
    NSInteger nextLevelScore = 200;
    while (score > nextLevelScore) {
        level ++;
        nextLevelScore = [self scoreNeedForLevel:level+1];
    }
    self.level = level;
    NSInteger currentLevelScore = [self scoreNeedForLevel:level];
    self.upgradeProgress = (CGFloat)(score - currentLevelScore) / (CGFloat)(nextLevelScore - currentLevelScore);
}



- (NSInteger)scoreNeedForLevel:(NSInteger)level {
    if (level < 2) {
        return 0;
    }
    return (2+level) * (level-1)/2 * 100;
}


@end
