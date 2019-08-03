//
//  RecordAPI.h
//  JumpMonkey
//
//  Created by 罗谨 on 2019/7/28.
//  Copyright © 2019 finger. All rights reserved.
//


#import "QMRequester.h"
#import "QMListRequester.h"
#import "GameRecord.h"

NS_ASSUME_NONNULL_BEGIN


@interface RecordBaseInput : QMInput
@property (nonatomic,assign) GameMode gameMode; //1-自由模式 2-定时模式
@end

@interface RecordBaseAPI : QMRequester
@property (nonatomic,assign) GameMode gameMode; //1-自由模式 2-定时模式
@end

/**********************     游戏记录    ****************************/
@interface AddRecordInput : RecordBaseInput
@property (nonatomic,strong) NSDictionary *record; //游戏记录
@property (nonatomic,strong) NSString *sign; //签名
@end

@interface AddRecordAPI : RecordBaseAPI

@property (nonatomic,strong) GameRecord* record;

@end


@interface GetMyRecordInput : RecordBaseInput

@end

@interface GetMyRecordAPI : RecordBaseAPI

@end

@interface GetTopRecordsInput : RecordBaseInput
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger count;
@end

@interface GetTopRecordsAPI : RecordBaseAPI
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger count;

- (instancetype)initWithPage:(NSInteger)page count:(NSInteger)count;

@end

NS_ASSUME_NONNULL_END
