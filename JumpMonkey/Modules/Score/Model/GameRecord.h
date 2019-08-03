//
//  GameRecord.h
//  JumpMonkey
//
//  Created by 罗谨 on 2019/7/28.
//  Copyright © 2019 finger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScoreInfo.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    GameModeFree = 1,
    GameModeTimeLimit = 2
} GameMode;

@interface GameRecord : NSObject
@property (nonatomic, assign) NSInteger userId; //用户id
@property (nonatomic, strong) NSString *name; // 用户昵称
@property (nonatomic, assign) NSInteger score; //单局得分
@property (nonatomic, assign) NSInteger hops; //单局最大连跳数
@property (nonatomic, assign) NSInteger hopScore;  // 单局连跳得分 
@property (nonatomic, assign) NSInteger trees;  // 跳过的树的数量 
@property (nonatomic, assign) NSTimeInterval time;  // 游戏用时 
@property (nonatomic, assign) NSTimeInterval timestamp;  // 记录上传的时间戳

- (instancetype)initWithScore:(ScoreInfo*)score;

@end
NS_ASSUME_NONNULL_END
