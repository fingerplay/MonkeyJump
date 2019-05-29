//
//  Tree.m
//  JumpMonkey
//
//  Created by 罗谨 on 2019/5/16.
//  Copyright © 2019 finger. All rights reserved.
//

#import "Tree.h"

@implementation Tree

- (instancetype)initWithImageNamed:(NSString *)imageName position:(CGPoint)position {
    self = [super initWithImageNamed:imageName position:position];
    if (self) {
        self.hookPoint = CGPointMake(TREE_HOOKPOINT_X, 187);
        self.type = HookNodeTypeStable;
        self.size = CGSizeMake(TREE_SIZE_W, TREE_SIZE_H);
    }
    return self;
}

+ (CGSize)size {
    return CGSizeMake(TREE_SIZE_W, TREE_SIZE_H);
}


@end
