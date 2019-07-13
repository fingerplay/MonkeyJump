//
//  HoodNode.m
//  JumpMonkey
//
//  Created by 罗谨 on 2019/5/10.
//  Copyright © 2019 finger. All rights reserved.
//

#import "HookNode.h"

@implementation HookNode

- (instancetype)initWithImageNamed:(NSString*)imageName position:(CGPoint)position{
    self = [super initWithImageNamed:imageName];
    if (self) {
        self.position = position;
        self.anchorPoint = CGPointMake(0.5, 0);
        _initX = position.x;
    }
    return self;
}


- (CGPoint)getRealHook {
    return CGPointMake(self.position.x + self.hookPoint.x, self.position.y + self.hookPoint.y);
}


-(void)onCatchHook {
    self.isHooked = YES;
}

- (void)onUncatchHook {
    self.isHooked = NO;
}



@end
