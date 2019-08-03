//
//  GameRecord.m
//  JumpMonkey
//
//  Created by 罗谨 on 2019/7/28.
//  Copyright © 2019 finger. All rights reserved.
//

#import "GameRecord.h"
#import "UserAccountManager.h"

@implementation GameRecord

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"userId":@"id"};
}

- (instancetype)initWithScore:(ScoreInfo *)score{
    GameRecord *record = [[GameRecord alloc] init];
    record.userId = [UserAccountManager sharedManager].currentAccount.userId;
    record.name = [UserAccountManager sharedManager].currentAccount.name;
    record.score = score.score;
    record.hops = score.mMaxHops;
    record.hopScore = score.mHopsScore;
    record.trees = score.catchTreesCount;
    record.time = score.duration;
    record.timestamp = [[NSDate date] timeIntervalSince1970];
    return record;
}

@end
