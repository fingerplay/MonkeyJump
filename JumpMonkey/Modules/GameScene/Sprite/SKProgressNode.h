//
//  SKProgressNode.h
//  JumpMonkey
//
//  Created by 罗谨 on 2019/10/19.
//  Copyright © 2019 finger. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

NS_ASSUME_NONNULL_BEGIN

#define PROGRESS_WIDTH 100
#define PROGRESS_HEIGHT 10

@interface SKProgressNode : SKShapeNode

@property (nonatomic, assign, readonly) CGFloat progress;

- (void)updateWithProgress:(CGFloat)progress;

@end

NS_ASSUME_NONNULL_END
