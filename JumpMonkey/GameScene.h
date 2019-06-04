//
//  GameScene.h
//  JumpMonkey
//
//  Created by 罗谨 on 2019/5/10.
//  Copyright © 2019 finger. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "HookNode.h"

@protocol GameSceneDelegate <NSObject>

- (void)monkeyDidJumpFromHookNode:(HookNode *)node;

- (void)monkeyDidJumpToHookNode:(HookNode *)node;

- (void)gameDidEnd;

- (void)gameDidRestart;

- (void)scoreDidUpdate:(NSInteger)score;

@end

@interface GameScene : SKScene

@property (nonatomic, weak) id<GameSceneDelegate>gameDelegate;

- (void)gameRestart;

@end
