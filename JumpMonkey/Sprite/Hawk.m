//
//  Hawk.m
//  JumpMonkey
//
//  Created by 罗谨 on 2019/6/3.
//  Copyright © 2019 finger. All rights reserved.
//

#import "Hawk.h"
#import "ImageSequence.h"
#import "Bezier.h"
static NSInteger kFrameCount = 30;

@interface Hawk ()
@property (nonatomic, strong) ImageSequence *imageSequence;
@property (nonatomic, strong) Bezier *bezierPath;
@property (nonatomic, assign) NSInteger step;
@property (nonatomic, assign) NSInteger totalStep;
@property (nonatomic, assign) CGFloat offsetX;
@property (nonatomic, strong) NSDate *lastCatchTime;
@end

@implementation Hawk


- (instancetype)initWithImageNamed:(NSString *)name {
    self = [super initWithImageNamed:name];
    if (self) {
        self.type = HookNodeTypeMove;
        self.imageSequence = [[ImageSequence alloc] initWithOriginImage:[UIImage imageNamed:@"hawk_list"] frameCount:kFrameCount];
        self.size = self.imageSequence.imageSize;
        self.hookPoint = CGPointMake(0, 10);
        self.anchorPoint = CGPointMake(0.5, 0.5);
        self.texture = [SKTexture textureWithImage:self.imageSequence.currentImage];
        self.position = CGPointMake(-self.size.width, -self.size.height); //初始不可见
    }
    return self;
}


#pragma mark - Public
- (void)startMoveWithLocation:(CGPoint)location {
//    UIBezierPath *path = [[UIBezierPath alloc] init];
//    [path moveToPoint:self.position];
//    [path addQuadCurveToPoint:CGPointMake(SCREEN_W + 50, SCREEN_H/3*2) controlPoint:CGPointMake(SCREEN_W / 3, SCREEN_H /3)];
//    SKAction *move = [SKAction followPath:path.CGPath duration:10];
    
//    SKAction *move = [SKAction moveTo:CGPointMake(SCREEN_W + 50, SCREEN_H/3*2) duration:10];
//    SKAction *moveDone = [SKAction removeFromParent];
//    [self runAction:[SKAction sequence:@[move,moveDone]]];
    
    CGPoint p0 = location;
    CGPoint p1 = CGPointMake(SCREEN_W + location.x, SCREEN_H);
    CGPoint p2 = CGPointMake(SCREEN_W*5 + location.x, SCREEN_H/2);
    CGFloat duration = 20;
    CGFloat speed = (p2.x - p0.x)/ (duration * FPS);
    self.speed = speed;
    self.bezierPath = [[Bezier alloc] initWithp0:p0 p1:p1 p2:p2 speed:speed];
    self.totalStep = self.bezierPath.step;
}

- (void)moveWithSceneVelocity:(CGFloat)velocity {

//    [super moveWithSceneVelocity:velocity];
    if (velocity>0) {
         self.offsetX += velocity;
    }
   
    if (self.step <= self.totalStep) {
        BezierPoint* currentPoint = [self.bezierPath getAnchorPoint:self.step];
        self.step ++;
        CGPoint location = CGPointMake(currentPoint.xx - self.offsetX, currentPoint.yy);
        self.position = location;
//        NSLog(@"step:%ld hawk position = %@",(long)self.step,NSStringFromCGPoint(self.position));
        //    if (velocity > 0) {
        //        SKAction *move = [SKAction moveByX:velocity y:0 duration:1/FPS];
        //        [self runAction:move];
        //    }
        
        
        [self.imageSequence changeImage];
        self.texture = [SKTexture textureWithImage:self.imageSequence.currentImage];
    }else{
        self.speed = 0;
    }

}

- (BOOL)canCatch {
    if (!self.lastCatchTime || [[NSDate date] timeIntervalSinceDate:self.lastCatchTime] >= 5 * 1000) {
        return YES;
    }
    return NO;
}

- (BOOL)isHookBroken {
    return NO;
}

- (void)onCatchHook {
    [super onCatchHook];
    self.lastCatchTime = [NSDate date];
}

@end
