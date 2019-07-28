//
//  ScoreAPI.h
//  JumpMonkey
//
//  Created by 罗谨 on 2019/7/28.
//  Copyright © 2019 finger. All rights reserved.
//

#import "QMRequester.h"
#import "ScoreInfo.h"

NS_ASSUME_NONNULL_BEGIN
@interface UpdateScoreInput : QMInput
@property (nonatomic,assign) NSInteger score; //单局得分
@property (nonatomic,strong) NSString *sign; //签名
@end


@interface UpdateScoreAPI : QMRequester

@property (nonatomic,assign) NSInteger score;

@end


@interface AddRecordInput : QMInput
@property (nonatomic,strong) NSString *record; //游戏记录
@property (nonatomic,strong) NSString *sign; //签名
@end

@interface AddRecordAPI : QMRequester

@property (nonatomic,strong) ScoreInfo* score;

@end

NS_ASSUME_NONNULL_END
