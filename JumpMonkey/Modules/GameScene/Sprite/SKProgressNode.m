//
//  SKProgressNode.m
//  JumpMonkey
//
//  Created by 罗谨 on 2019/10/19.
//  Copyright © 2019 finger. All rights reserved.
//

#import "SKProgressNode.h"

@interface SKProgressNode ()
@property (nonatomic,strong) SKShapeNode* finishedProgressNode;
@end

@implementation SKProgressNode

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addChild:self.finishedProgressNode];
//        [self updateWithProgress:0];
    }
    return self;
}

- (void)updateWithProgress:(CGFloat)progress {
    if ( progress<0 || progress>1) {
        return;
    }
    if (CGRectEqualToRect(self.frame, CGRectZero)){
        return;
    }
    _progress = progress;
//    CGFloat minWidth = self.frame.size.height - 2;
//    CGSize finishedProgressNodeSize = CGSizeMake( fmax(self.frame.size.width * progress, minWidth), self.frame.size.height-2);
    CGSize finishedProgressNodeSize = CGSizeMake(self.frame.size.width * progress,10-2);
    if (finishedProgressNodeSize.width > 0 && finishedProgressNodeSize.height > 0) {
        CGPathRef path = CGPathCreateWithRoundedRect(CGRectMake(0, 1, finishedProgressNodeSize.width, finishedProgressNodeSize.height), finishedProgressNodeSize.height/2, finishedProgressNodeSize.height/2, &CGAffineTransformIdentity);
        self.finishedProgressNode.path = path;
    }
}

- (SKShapeNode *)finishedProgressNode {
    if (!_finishedProgressNode) {
        _finishedProgressNode = [[SKShapeNode alloc] init];
        _finishedProgressNode.fillColor = [UIColor purpleColor];
//        _finishedProgressNode.strokeColor = [UIColor whiteColor];
    }
    return _finishedProgressNode;
  
}

@end
