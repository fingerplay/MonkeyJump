//
//  Monkey.m
//  JumpMonkey
//
//  Created by 罗谨 on 2019/5/10.
//  Copyright © 2019 finger. All rights reserved.
//

#import "Monkey.h"
#import "PhysicsUtil.h"
#import "SoundManager.h"

@interface Monkey ()
@property (nonatomic, assign) CGPoint mPostion; //相对挂点的位置
@property (nonatomic, assign) CGFloat mVx; //x方向速度
@property (nonatomic, assign) CGFloat mVy; //y方向速度
@property (nonatomic, assign) CGFloat mVtx; //x方向速度（mVx乘以特定系数）
@property (nonatomic, assign) CGFloat mVty; //y方向速度（mVx乘以特定系数）
@property (nonatomic, assign) CGFloat mOmega; //摆动的角速度
@property (nonatomic, assign) CGFloat mMaxHeight; //最高点位置
@property (nonatomic, assign) BOOL isInHighestPosition; //是否在最高点
@property (nonatomic, assign) CGFloat mY; //y位置
@property (nonatomic, assign) CGFloat mX; //y位置
@property (nonatomic, assign) NSInteger mCurrentHops;//连跳次数
@property (nonatomic, assign) NSInteger mMaxHops; //历史最多连跳

@end

@implementation Monkey


- (instancetype)initWithImageNamed:(NSString *)name hookNode:(HookNode*)hookNode{
    self = [super initWithImageNamed:@"monkey_swing"];
    if (self) {
        self.hookNode = hookNode;
        self.position = hookNode.hookPoint;
        _initX = hookNode.position.x + hookNode.hookPoint.x;
        self.anchorPoint = CGPointMake(0.5, 1);
        self.size = CGSizeMake(MONKEY_SIZE_H/95.f * 50.f, MONKEY_SIZE_H);

        self.mX = [hookNode getRealHook].x;
        self.mY = [hookNode getRealHook].y;
        self.armLength = MONKEY_SIZE_H;
        self.currentAngle = -PI/2; //0表示圆最下方的点，顺时针<0，逆时针>0
        self.state = MonkeyStateSwing;
        self.mCurrentHops = 0;
        self.mMaxHops = 0;
        self.mScore = [ScoreInfo new];
    }
    return self;
}

#pragma mark - Public
- (void)setHookNode:(HookNode *)hookNode {
    _hookNode = hookNode;
//    CGFloat mX = hookNode.position.x;
//    CGFloat mY = (float) (hookNode.position.y + self.armLength + sin(PI / 4));
//    self.position = CGPointMake(mX, mY);
    self.mOmega = 0;
    self.mMaxHeight = (CGFloat) (self.armLength - self.armLength * cos(PI / 4));
    self.currentAngle = -(CGFloat) PI / 4;

}

- (void)setState:(MonkeyState)state {
    _state = state;
    switch (state) {
        case MonkeyStateSwing:{
            self.texture = [SKTexture textureWithImageNamed:@"monkey_swing"];
            self.size = CGSizeMake(50,95);
            self.anchorPoint = CGPointMake(0.5, 1);
        }   break;
        case MonkeyStateJump:{
            self.texture = [SKTexture textureWithImageNamed:@"monkey_jump"];
            self.size = CGSizeMake(220/4, 225/4);
            self.anchorPoint = CGPointMake(0.5, 0.5);
        }   break;
        default:{
            self.texture = [SKTexture textureWithImageNamed:@"monkey_swing"];
            self.size = CGSizeMake(50,95);
            self.anchorPoint = CGPointMake(0.5, 1);
        }   break;
    }
}

- (void)jumpWithVx:(CGFloat)jvx vy:(CGFloat)jvy {
    [self switch2JumpWithVx:jvx vy:jvy];
    if (self.delegate && [self.delegate respondsToSelector:@selector(monkeyDidJumpFromHookNode:)]) {
        [self.delegate monkeyDidJumpFromHookNode:self.hookNode];
    }
    self.hookNode.isHookTarget = NO;
    self.hookNode = self.hookNode.nextNode;
    self.hookNode.isHookTarget = YES;
}

- (void)move {
    switch (self.state) {
        case MonkeyStateSwing:
        {
            //当摆到水平方向时，角速度为0，需要给一个速度，否则无法落下
            if (self.mOmega == 0) {
                self.isInHighestPosition = YES;
                NSCAssert(self.armLength!=0, @"armLength = 0");
                self.mOmega = -(float) (G * sinf(self.currentAngle) / self.armLength);
                [self caculateHeightAndEnergy];
                [self clearHops];
            }else{
                self.isInHighestPosition = NO;
            }
            
            self.currentAngle += self.mOmega * PENDULUM_RATIO;
            
            if (self.sceneMoveVelocity>0) {
//                NSLog(@"sceneMoveVelocity = %f",self.sceneMoveVelocity);
                self.mX = self.mX - self.sceneMoveVelocity;
            }

//            NSLog(@"tree position X:%f Y:%f",self.hookNode.position.x, self.hookNode.position.y);
            CGFloat value = (float) (2 * G * (self.mMaxHeight - self.armLength * (1 - cosf(self.currentAngle))));
            if (value < 0) {
                value = 0;
            }
            CGFloat v = (float) sqrtf(value);
            if (self.mOmega > 0) {
                self.mOmega = v / (float)self.armLength;
            } else {
                self.mOmega = -v / (float)self.armLength;
            }
            self.zRotation = self.currentAngle;
            if (self.armLength == 0) {
                return;
            }
            NSCAssert(self.mOmega!=NAN, @"omega = nan");
        }
            break;
        case MonkeyStateJump:
        {
//            NSLog(@"sceneMoveVelocity = %f ,mvtx =%f",self.sceneMoveVelocity, self.mVtx);
            self.mX = self.mX + ((self.mVtx - self.sceneMoveVelocity) >0 ?: 0) ;
            self.mY = self.mY + self.mVty - G / 2;
            self.position = CGPointMake(self.mX, self.mY);
//            NSLog(@"monkey position X:%f Y:%f",self.mX,self.mY);
            NSCAssert(self.mX!=NAN, @"mx = nan");
            self.mVy -= G;
            self.mVty = self.mVy * JUMP_COEFFCIENT;
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(monkeyDidMoveTo:)]) {
                [self.delegate monkeyDidMoveTo:CGPointMake(self.mX, self.mY)];
            }
            
            [self checkCatchHook:self.hookNode pendingState:MonkeyStateSwing];
        }
            break;
        default:
            break;
    }
}

#pragma mark - Private
- (void)switch2JumpWithVx:(CGFloat)jvx vy:(CGFloat)jvy {
    if (self.state == MonkeyStateSwing) {
        [self.hookNode onUncatchHook];
    }
    
    self.state = MonkeyStateJump;
    self.zRotation = 0;
    if (self.isInHighestPosition) {
        self.mVx = 0;
        self.mVy = jvy;
    }else{
        self.mVx = (CGFloat)(self.mOmega * self.armLength * cosf(self.currentAngle));
        self.mVy = (CGFloat)(self.mOmega * self.armLength * sinf(self.currentAngle)) + jvy;
    }

    self.mVtx = self.mVx * JUMP_COEFFCIENT;
    self.mVty = self.mVy * JUMP_COEFFCIENT;
    self.mX = self.mX + self.mVtx - self.sceneMoveVelocity;
    self.mY = [self.hookNode getRealHook].y + self.mVty;
    self.position = CGPointMake(self.mX, self.mY);
    _offsetX = self.mX - self.initX;
    
    SKNode* sceneNode = [self.hookNode parent];
    [self removeFromParent];
    [sceneNode addChild:self];
}

-(BOOL)checkCatchHook:(HookNode*)hookNode pendingState:(MonkeyState)pendingState {
//    NSLog(@"hookPoint=(%f %f)",[hookNode getRealHook].x,[hookNode getRealHook].y);
    if (hookNode != NULL) {
        if (self.position.y < [hookNode getRealHook].y &&
            // mX <= hookNode.mHook.x + mArmsLength / 4 &&
             [PhysicsUtil isPoint:self.position inRadiusRegion:ARM_RADUIS withCenter:[hookNode getRealHook] velocity:CGPointMake(self.mVx, self.mVy)]) {
            [self switch2Swing:[hookNode getRealHook] pendingState:pendingState hookNode:hookNode];
            return true;
        }
    }
    return false;
}

- (void)switch2Swing:(CGPoint)hookPoint pendingState:(MonkeyState)pendingState hookNode:(HookNode*)hookNode{
    self.state = pendingState;
    [self countHop];
    [[SoundManager sharedManger] playCatchHookSound];
    
    NSNumber* nodeNumber = @(self.hookNode.number).copy;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MONKEY_SWING_MAX_DURATION * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.state == MonkeyStateSwing && nodeNumber.integerValue == self.hookNode.number) {
            [self jumpWithVx:0 vy:0];
        }
    });

    [self.mScore updateHooksScore:self.hookNode.number];
    [self.mScore updateHopsScore:self.mCurrentHops];
    
    CGFloat dY = ABS(hookPoint.y - self.position.y);
    self.mMaxHeight = self.mVx * self.mVx / (2 * G) + (self.armLength - dY); // 能量守恒定律计算,注意，这里略去了垂直方向的动能
    self.mMaxHeight = (self.mMaxHeight < self.armLength) ? self.mMaxHeight : self.armLength;
    CGFloat value = (self.position.x - hookPoint.x) / self.armLength;
    value = (value > 1) ? 1 : value;
    value = (value < -1) ? -1 : value;
    self.currentAngle = (CGFloat) asinf(value);
    
    CGFloat height = self.armLength - dY;
    if (height > self.mMaxHeight) {
        height = self.mMaxHeight;
    }
    CGFloat v = (CGFloat) sqrt(2 * G * (self.mMaxHeight - height));
  
    NSAssert(!isnan(v), @"v is nan");
    
    self.mOmega = v / self.armLength;
//    NSLog(@"switch2Swing omega = %f, v=%f",self.mOmega,v);
    if (self.mVx < 0) {
        self.mOmega = -self.mOmega;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(monkeyDidJumpToHookNode:)]) {
        [self.delegate monkeyDidJumpToHookNode:self.hookNode];
    }

    [self removeFromParent];
    self.position = hookNode.hookPoint;
    self.mX = [hookNode getRealHook].x;
    self.mY = [hookNode getRealHook].y;
    [hookNode addChild:self];
    [hookNode onCatchHook];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(monkeyDidMoveTo:)]) {
        [self.delegate monkeyDidMoveTo:CGPointMake(self.mX, self.mY)];
    }
}

//移动微小的高度，然后计算最高位置
- (void)caculateHeightAndEnergy {
    self.mMaxHeight += self.armLength * ENERGY_COEFFCIENT;
    self.mMaxHeight = (self.mMaxHeight > self.armLength) ? self.armLength : self.mMaxHeight;//最高的高度不能超过一个臂长，即角度不能超过正负PI/2;
}

- (CGFloat)sceneMoveVelocity {
    //    NSLog(@"self.mVtx = %f",self.mVtx);
    if (self.state == MonkeyStateSwing) {
        return MIN(self.hookNode.position.x - MONKEY_MIN_X , SCENE_MOVE_VELOCITY_SWING);
    }else {
        return MIN( self.position.x - (MONKEY_MIN_X + TREE_HOOKPOINT_X) , SCENE_MOVE_VELOCITY_JUMP);
    }
}

- (void)clearHops {
    self.mCurrentHops = 0;
}

- (void)countHop{
    self.mCurrentHops++;
    self.mMaxHops = self.mMaxHops > self.mCurrentHops ? self.mMaxHops : self.mCurrentHops;
}

@end
