//
//  GameScene.h
//  JumpMonkey
//
//  Created by 罗谨 on 2019/5/10.
//  Copyright © 2019 finger. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@protocol GameSceneDelegate <NSObject>

- (void)gameDidEnd;

@end

@interface GameScene : SKScene

@property (nonatomic, weak) id<GameSceneDelegate>gameDelegate;

- (void)gameRestart;

@end
