//
//  RecordAPI.m
//  JumpMonkey
//
//  Created by 罗谨 on 2019/7/28.
//  Copyright © 2019 finger. All rights reserved.
//

#import "RecordAPI.h"
#import "SecKeyManager.h"

@implementation RecordBaseInput

@end

@implementation RecordBaseAPI


@end

/**********************     游戏记录    ****************************/
@implementation AddRecordInput

@end

@implementation AddRecordAPI

- (QMInput *)buildInput {
    AddRecordInput *input = [[AddRecordInput alloc] init];
    input.gameMode = self.gameMode;
    NSMutableDictionary* dict = [self.record mj_keyValues];
    [dict removeObjectForKey:@"rank"];
    input.record = dict;
    NSString *scoreStr = [NSString stringWithFormat:@"%ld%ld%ld%ld%ld",(long)self.record.userId,(long)self.record.hopScore,(long)self.record.score,(long)self.record.trees,(long)self.record.hops];
    input.sign = [[SecKeyManager sharedInstance] encryptWithAESFromString:scoreStr];
    return input;
}

- (void)configCommand:(QMCommand *)command
{
    command.url = DomainURL(@"records/add");
    command.method = QMRequestMethodPost;
}

@end



@implementation GetMyRecordInput

@end

@implementation GetMyRecordAPI

- (QMInput *)buildInput {
    GetMyRecordInput *input = [[GetMyRecordInput alloc] init];
    input.gameMode = self.gameMode;
    return input;
}

- (void)configCommand:(QMCommand *)command
{
    command.url = DomainURL(@"records/getMyRecord");
    command.method = QMRequestMethodPost;
}

//- (id)reformJsonData:(id)data {
//    if ([data isKindOfClass:[NSDictionary class]]) {
//        NSDictionary *dataDict = (NSDictionary *)data;
//        NSString *recordDict = [dataDict objectForKey:@"record"];
//        GameRecord *record = [GameRecord mj_objectWithKeyValues:recordDict];
//        return record;
//    }
//    
//    return nil;
//}
@end


@implementation GetTopRecordsInput

@end

@implementation GetTopRecordsAPI
- (instancetype)initWithPage:(NSInteger)page count:(NSInteger)count {
    self = [super init];
    if (self) {
        self.page = page;
        self.count = count;
    }
    return self;
}

- (QMInput *)buildInput {
    GetTopRecordsInput *input = [[GetTopRecordsInput alloc] init];
    input.page = self.page;
    input.count = self.count;
    input.gameMode = self.gameMode;
    return input;
}

- (void)configCommand:(QMCommand *)command
{
    command.url = DomainURL(@"records/top");
    command.method = QMRequestMethodPost;
}

@end
