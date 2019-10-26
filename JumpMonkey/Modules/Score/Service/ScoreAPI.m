//
//  ScoreAPI.m
//  JumpMonkey
//
//  Created by 罗谨 on 2019/7/28.
//  Copyright © 2019 finger. All rights reserved.
//

#import "ScoreAPI.h"
#import "SecKeyManager.h"

@implementation UpdateScoreInput

@end

@implementation UpdateScoreAPI
- (instancetype)initWithScore:(NSInteger)score {
    if (self = [super init]) {
        self.score = score;
    }
    return self;
}

- (QMInput *)buildInput {
    UpdateScoreInput *input = [[UpdateScoreInput alloc] init];
    input.score = self.score;
   
    NSString *scoreStr = [NSString stringWithFormat:@"%ld",(long)self.score];
    input.sign = [[SecKeyManager sharedInstance] encryptWithAESFromString:scoreStr];
    return input;
}

- (void)configCommand:(QMCommand *)command
{
    command.url = DomainURL(@"user/updateScores");
    command.method = QMRequestMethodPost;
}


@end


@implementation GetScoreInput

@end

@implementation GetScoreAPI

- (GetScoreInput *)buildInput {
    GetScoreInput *input = [[GetScoreInput alloc] init];
//    input.gameMode = self.gameMode;
    return input;
}

- (void)configCommand:(QMCommand *)command
{
    command.url = DomainURL(@"user/getScores");
    command.method = QMRequestMethodPost;
}

@end

