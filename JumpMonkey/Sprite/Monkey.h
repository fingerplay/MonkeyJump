//
//  Monkey.h
//  JumpMonkey
//
//  Created by 罗谨 on 2019/5/10.
//  Copyright © 2019 finger. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "HookNode.h"
#import "ScoreInfo.h"
#import "Hawk.h"
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger){
    MonkeyStateSwing = 0, //摆动中
    MonkeyStateJump, //跳跃中
    MonkeyStateRide, //骑行中
} MonkeyState;

@protocol MonkeyDelegate <NSObject>

- (void)monkeyDidMoveTo:(CGPoint)position;

- (void)monkeyDidJumpToHookNode:(HookNode*)node;

- (void)monkeyDidJumpFromHookNode:(HookNode*)node;
@end

@interface Monkey : SKSpriteNode

@property (nonatomic, assign, readonly) CGFloat offsetX;
@property (nonatomic, assign ,readonly) CGFloat initX;
@property (nonatomic, assign, readonly) CGFloat sceneMoveVelocity;

@property (nonatomic, assign) CGFloat armLength; //臂长
@property (nonatomic, assign) CGFloat currentAngle; //当前摆动的角度
@property (nonatomic, assign) MonkeyState state; //猴子当前的状态
@property (nonatomic, strong) HookNode *hookNode;
@property (nonatomic, weak) Hawk *hawk;
@property (nonatomic, strong) HookNode *delayDropNode;
@property (nonatomic, strong) ScoreInfo *mScore;
@property (nonatomic, weak) id<MonkeyDelegate> delegate;


- (instancetype)initWithImageNamed:(NSString *)name hookNode:(HookNode*)hookNode;

- (void)jumpWithVx:(CGFloat)vx vy:(CGFloat)vy;

- (void)move;

- (HookNode*)getCurrentHookNode;

@end

NS_ASSUME_NONNULL_END
