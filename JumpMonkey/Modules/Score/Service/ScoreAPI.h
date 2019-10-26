//
//  ScoreAPI.h
//  JumpMonkey
//
//  Created by 罗谨 on 2019/7/28.
//  Copyright © 2019 finger. All rights reserved.
//

#import "QMRequester.h"


NS_ASSUME_NONNULL_BEGIN

/**********************     经验（历史积分累积）    ****************************/
@interface UpdateScoreInput : QMInput
@property (nonatomic,assign) NSInteger score; //单局得分
@property (nonatomic,strong) NSString *sign; //签名
@end


@interface UpdateScoreAPI : QMRequester

@property (nonatomic,assign) NSInteger score;

@end

@interface GetScoreInput : QMInput
//@property (nonatomic,assign) NSInteger gameMode;
@end

@interface GetScoreAPI : QMRequester
//@property (nonatomic,assign) NSInteger gameMode;
@end




NS_ASSUME_NONNULL_END
