//
//  Hawk.m
//  JumpMonkey
//
//  Created by 罗谨 on 2019/6/3.
//  Copyright © 2019 finger. All rights reserved.
//

#import "Hawk.h"
#import "UIBezierPath+AllPoints.h"

static NSInteger kFrameCount = 30;

@interface Hawk ()
@property (nonatomic, strong) NSArray* images;
@property (nonatomic, assign) NSInteger frameIndex;
@end

@implementation Hawk

- (instancetype)initWithImageNamed:(NSString *)name {
    self = [super initWithImageNamed:name];
    if (self) {
        self.type = HookNodeTypeMove;
        self.position = CGPointMake(-50, -50); //初始不可见
        self.frameIndex = 0;
        [self loadAndClipImages];
        
    }
    return self;
}

- (void)loadAndClipImages {
    UIImage *image = [UIImage imageNamed:@"hawk_list"];
    CGFloat widthPerFrame = image.size.width / kFrameCount;
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for (NSInteger i=0; i<kFrameCount; i++) {
        UIImage *frameImage = [image cropImageInRect:CGRectMake(i * widthPerFrame, 0, widthPerFrame, image.size.height)];
        [temp addObject:frameImage];
    }
    self.images = [temp copy];
    self.size = CGSizeMake(widthPerFrame, image.size.height);
    self.texture = [SKTexture textureWithImage:self.images[self.frameIndex]];
}

- (void)changeImage {
    self.texture = [SKTexture textureWithImage:self.images[self.frameIndex]];
    self.frameIndex =  (self.frameIndex +1 ) % kFrameCount ;
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
    NSLog(@"hwak position = %@",NSStringFromCGPoint(self.position));
    
    [super moveWithSceneVelocity:velocity];
//    if (velocity > 0) {
//        SKAction *move = [SKAction moveByX:velocity y:0 duration:1/FPS];
//        [self runAction:move];
//    }
 
    [self changeImage];
}
@end
