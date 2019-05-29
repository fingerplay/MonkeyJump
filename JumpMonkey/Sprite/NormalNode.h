//
//  BackgroundNode.h
//  JumpMonkey
//
//  Created by 罗谨 on 2019/5/27.
//  Copyright © 2019 finger. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NormalNode : SKSpriteNode

- (void)moveWithSceneVelocity:(CGFloat)velocity;

@end

NS_ASSUME_NONNULL_END
