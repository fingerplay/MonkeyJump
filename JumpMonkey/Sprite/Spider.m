//
//  Spider.m
//  JumpMonkey
//
//  Created by 罗谨 on 2019/5/29.
//  Copyright © 2019 finger. All rights reserved.
//

#import "Spider.h"

@implementation Spider


- (instancetype)initWithImageNamed:(NSString *)imageName position:(CGPoint)position {
    self = [super initWithImageNamed:imageName position:position];
    if (self) {
        UIImage *image = [UIImage imageNamed:imageName];
        self.size = image.size;
        self.hookPoint = CGPointMake(0, self.size.height/2);
        self.type = HookNodeTypeClimb;
        self.maxY = [UIScreen mainScreen].bounds.size.height - self.size.height;
        self.minY = SPIDER_POSITION_MIN_Y + arc4random_uniform(100);
        CGFloat positionY = self.minY + arc4random_uniform(self.maxY - self.minY);
        self.position = CGPointMake(self.position.x, positionY);
        NSArray *velocitySet = @[ @(-SPIDER_MOVE_VELOCITY) , @(SPIDER_MOVE_VELOCITY)];
        uint32_t index = arc4random_uniform(1);
        self.vy = [velocitySet[index] floatValue];
    }
    return self;
}

- (void)moveWithSceneVelocity:(CGFloat)velocity{
    [super moveWithSceneVelocity:velocity];
    CGFloat y = self.position.y;
    y += self.vy;
    if (y >= self.maxY ) {
        self.vy = - self.vy;
        y = self.maxY;
    }else if (y <= self.minY) {
        self.vy = - self.vy;
        y = self.minY;
    }
    self.position = CGPointMake(self.position.x, y);
}

@end
