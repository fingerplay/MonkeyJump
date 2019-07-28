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



@implementation AddRecordInput

@end

@implementation AddRecordAPI

- (instancetype)initWithScore:(ScoreInfo*)score {
    if (self = [super init]) {
        self.score = score;
    }
    return self;
}

- (QMInput *)buildInput {
    AddRecordInput *input = [[AddRecordInput alloc] init];
    NSDictionary *keyvalues = [self.score mj_keyValues];
    input.record = [keyvalues mj_JSONString];
    NSString *scoreStr = [NSString stringWithFormat:@"%ld",(long)self.score];
    input.sign = [[SecKeyManager sharedInstance] encryptWithAESFromString:scoreStr];
    return input;
}

- (void)configCommand:(QMCommand *)command
{
    command.url = DomainURL(@"records/add");
    command.method = QMRequestMethodPost;
}


@end
