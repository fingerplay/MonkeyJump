//
//  RecordAPI.h
//  JumpMonkey
//
//  Created by 罗谨 on 2019/7/28.
//  Copyright © 2019 finger. All rights reserved.
//


#import "QMRequester.h"
#import "GameRecord.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecordBaseInput : QMInput
@property (nonatomic,assign) NSInteger gameMode; //1-自由模式 2-定时模式
@end


/**********************     游戏记录    ****************************/
@interface AddRecordInput : RecordBaseInput
@property (nonatomic,strong) NSString *record; //游戏记录
@property (nonatomic,strong) NSString *sign; //签名
@end

@interface AddRecordAPI : QMRequester

@property (nonatomic,strong) GameRecord* record;

@end


@interface GetMyRecordInput : RecordBaseInput

@end

@interface GetMyRecordAPI : QMRequester

@end

NS_ASSUME_NONNULL_END
