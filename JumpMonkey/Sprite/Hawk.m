//
//  Hawk.m
//  JumpMonkey
//
//  Created by 罗谨 on 2019/6/3.
//  Copyright © 2019 finger. All rights reserved.
//

#import "Hawk.h"
#import "UIBezierPath+AllPoints.h"
#import "ImageSequence.h"
static NSInteger kFrameCount = 30;

@interface Hawk ()
@property (nonatomic, strong) ImageSequence *imageSequence;
@end

@implementation Hawk


- (instancetype)initWithImageNamed:(NSString *)name {
    self = [super initWithImageNamed:name];
    if (self) {
        self.type = HookNodeTypeMove;
        self.position = CGPointMake(-50, -50); //初始不可见
        self.imageSequence = [[ImageSequence alloc] initWithOriginImage:[UIImage imageNamed:@"hawk_list"] frameCount:kFrameCount];
        self.size = self.imageSequence.imageSize;
        self.texture = [SKTexture textureWithImage:self.imageSequence.currentImage];
    }
    return self;
}


#pragma mark - Public
- (void)startMove {
//    UIBezierPath *path = [[UIBezierPath alloc] init];
//    [path moveToPoint:self.position];
//    [path addQuadCurveToPoint:CGPointMake(SCREEN_W + 50, SCREEN_H/3*2) controlPoint:CGPointMake(SCREEN_W / 3, SCREEN_H /3)];
    
    SKAction *move = [SKAction moveTo:CGPointMake(SCREEN_W + 50, SCREEN_H/3*2) duration:10];
//    SKAction *move = [SKAction followPath:path.CGPath duration:10];
    SKAction *moveDone = [SKAction removeFromParent];
    [self runAction:[SKAction sequence:@[move,moveDone]]];
}

- (void)moveWithSceneVelocity:(CGFloat)velocity {
//    NSLog(@"hwak position = %@",NSStringFromCGPoint(self.position));
    
    [super moveWithSceneVelocity:velocity];
//    if (velocity > 0) {
//        SKAction *move = [SKAction moveByX:velocity y:0 duration:1/FPS];
//        [self runAction:move];
//    }
 
    [self.imageSequence changeImage];
    self.texture = [SKTexture textureWithImage:self.imageSequence.currentImage];
}
@end
