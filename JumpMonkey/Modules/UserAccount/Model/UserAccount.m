//
//  UserAccount.m
//  JumpMonkey
//
//  Created by 罗谨 on 2019/7/13.
//  Copyright © 2019 finger. All rights reserved.
//

#import "UserAccount.h"

@implementation UserAccount

- (instancetype)init {
    self = [super init];
    if (self) {
        _levelInfo = [[LevelInfo alloc] init];
        _lifeInfo = [[LifeInfo alloc] init];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.userId = [aDecoder decodeIntegerForKey:@"userId"];
        self.account = [aDecoder decodeObjectForKey:@"account"];
        self.password = [aDecoder decodeObjectForKey:@"password"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.scores = [aDecoder decodeIntegerForKey:@"scores"];
        self.levelInfo = [aDecoder decodeObjectForKey:@"levelInfo"];
        self.lifeInfo = [aDecoder decodeObjectForKey:@"lifeInfo"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:self.userId forKey:@"userId"];
    [aCoder encodeObject:self.account forKey:@"account"];
    [aCoder encodeObject:self.password forKey:@"password"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeInteger:self.scores forKey:@"scores"];
    [aCoder encodeObject:self.levelInfo forKey:@"levelInfo"];
    [aCoder encodeObject:self.lifeInfo forKey:@"lifeInfo"];
}

- (void)setScores:(NSInteger)scores {
    _scores = scores;
    if (!self.levelInfo) {
        self.levelInfo = [[LevelInfo alloc] init];
    }
    [self.levelInfo updateWithScore:scores];
}


@end
