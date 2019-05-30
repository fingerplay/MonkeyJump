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
        self.type = HookNodeTypeStable;
        int h = arc4random() % (int)TREE_SIZE_H/2 + TREE_SIZE_H /5 * 4;
        int w = h / 950.f*774.f;
        self.size = CGSizeMake(w, h);
        self.hookPoint = CGPointMake(TREE_HOOKPOINT_X, self.size.height*0.59);
    }
    return self;
}

+ (CGSize)size {
    return CGSizeMake(TREE_SIZE_W, TREE_SIZE_H);
}


@end
