//
//  GameScene.h
//  JumpMonkey
//
//  Created by 罗谨 on 2019/5/10.
//  Copyright © 2019 finger. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "HookNode.h"
#import "ScoreInfo.h"
#import "GameModel.h"

@protocol GameSceneDelegate <NSObject>
@optional
- (void)monkeyDidJumpFromHookNode:(HookNode *)node;

- (void)monkeyDidJumpToHookNode:(HookNode *)node;

- (void)gameDidEnd;

- (void)gameDidRestart;

- (void)scoreDidUpdate:(NSInteger)score;

@end

@interface GameScene : SKScene
@property (nonatomic, strong) ScoreInfo *mScore;

@property (nonatomic, weak) id<GameSceneDelegate>gameDelegate;

- (instancetype)initWithMode:(GameMode)gameMode;

- (void)gameRestart;

- (void)removeChildNodes;

@end
