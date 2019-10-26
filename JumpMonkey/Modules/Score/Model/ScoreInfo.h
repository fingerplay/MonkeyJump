//
//  ScoreInfo.h
//  JumpMonkey
//
//  Created by 罗谨 on 2019/5/29.
//  Copyright © 2019 finger. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol ScoreInfoDelegate <NSObject>

- (void)scoreDidUpdate:(NSInteger)score;

@end

@interface ScoreInfo : NSObject
@property (nonatomic, assign) NSInteger mCurrentHops;//连跳次数
@property (nonatomic, assign) NSInteger mMaxHops; //历史最多连跳
@property (nonatomic, assign, readonly) NSInteger mHopsScore; //连跳的份
@property (nonatomic, assign) NSInteger catchHawkCount;
@property (nonatomic, assign) NSInteger catchTreesCount;
@property (nonatomic, assign, readonly) NSInteger score;
@property (nonatomic, assign) NSInteger dropCount; //定时模式下掉落次数
@property (nonatomic, assign) NSInteger distance;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign, readonly) NSInteger lastAccScore;
@property (nonatomic, weak) id<ScoreInfoDelegate> delegate;


- (void)updateHopsScore;

- (void)updateHooksScore:(NSInteger)hooksNumber;

- (void)updateHawkScore:(NSInteger)hawkNumber;

- (void)clearScore;

- (void)clearHops;

@end
