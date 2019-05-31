//
//  Tree.m
//  JumpMonkey
//
//  Created by 罗谨 on 2019/5/16.
//  Copyright © 2019 finger. All rights reserved.
//

#import "Tree.h"

@interface Tree ()
@property (nonatomic, strong) SKSpriteNode *hookPointIcon;
@end

@implementation Tree

- (instancetype)initWithImageNamed:(NSString *)imageName position:(CGPoint)position {
    self = [super initWithImageNamed:imageName position:position];
    if (self) {
        self.type = HookNodeTypeStable;
        int h = arc4random() % (int)TREE_SIZE_H/2 + TREE_SIZE_H /5 * 4;
        int w = h / 950.f*774.f;
        self.size = CGSizeMake(w, h);
        self.hookPoint = CGPointMake(TREE_HOOKPOINT_X, self.size.height*0.59);
        [self addChild:self.hookPointIcon];
    }
    return self;
}

+ (CGSize)size {
    return CGSizeMake(TREE_SIZE_W, TREE_SIZE_H);
}

- (SKSpriteNode *)hookPointIcon {
    if (!_hookPointIcon) {
        _hookPointIcon = [[SKSpriteNode alloc] initWithColor:[UIColor redColor] size:CGSizeMake(10, 10)];
        _hookPointIcon.position = self.hookPoint;
        _hookPointIcon.anchorPoint = CGPointMake(0.5, 0.5);
    }
    return _hookPointIcon;
}

@end
