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
    CGPoint p1 = CGPointMake(SCREEN_W*2 + location.x , SCREEN_H);
    CGPoint p2 = CGPointMake(SCREEN_W*5  + location.x, SCREEN_H/3);
    [self startMoveWithLocation:location p1:p1 p2:p2];
}

- (void)startMoveWithLocation:(CGPoint)location p1:(CGPoint)p1 p2:(CGPoint)p2{
    
    CGPoint p0 = location;
    CGFloat duration = 10;
    CGFloat speed = (p2.x - p0.x)/ (duration * FPS);
    self.speed = speed;
    self.bezierPath = [[Bezier alloc] initWithp0:p0 p1:p1 p2:p2 speed:speed];
    self.totalStep = self.bezierPath.step;
    self.offsetX = 0;
    self.step = 0;
}

- (void)moveWithSceneVelocity:(CGFloat)velocity {
    
    if (velocity > 0) {
        self.offsetX += velocity;
    }
    
//    NSLog(@"step:%ld[%ld] hawk position = %@",(long)self.step, self.totalStep,NSStringFromCGPoint(self.position));
    if (self.step <= self.totalStep) {
        BezierPoint* currentPoint = [self.bezierPath getAnchorPoint:self.step];
        self.step ++;
        CGPoint location = CGPointMake(currentPoint.xx - self.offsetX, currentPoint.yy);
        self.position = location;

        [self.imageSequence changeImage];
        self.texture = [SKTexture textureWithImage:self.imageSequence.currentImage];
    }else{
        //动画结束时还在屏幕内
        if (self.position.x <= SCREEN_W && self.position.x >= 0) {
            if (self.bezierPath.p2.y == SCREEN_H/3) {
                [self startMoveWithLocation:self.position p1:CGPointMake(self.position.x + SCREEN_W * 2, SCREEN_H/3) p2:CGPointMake(SCREEN_W*5 + self.position.x , SCREEN_H)];
            }else if (self.bezierPath.p2.y == SCREEN_H) {
                [self startMoveWithLocation:self.position];
            }
        
        }
//        self.speed = 0;
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
