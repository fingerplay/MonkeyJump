//
//  BackgroundNode.m
//  JumpMonkey
//
//  Created by 罗谨 on 2019/5/27.
//  Copyright © 2019 finger. All rights reserved.
//

#import "NormalNode.h"

@implementation NormalNode

- (void)moveWithSceneVelocity:(CGFloat)velocity {
    if (velocity < 0) {
        return;
    }
    CGFloat x = self.position.x - velocity;
    self.position = CGPointMake(x, self.position.y);
}

@end
