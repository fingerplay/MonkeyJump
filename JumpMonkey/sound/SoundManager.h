//
//  SoundManager.h
//  JumpMonkey
//
//  Created by 罗谨 on 2019/6/3.
//  Copyright © 2019 finger. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface SoundManager : SKNode

@property (nonatomic, strong) AVPlayer *player;

+ (instancetype)sharedManger;

-(void)playCatchHookSound;

- (void)playGameOverSound;

- (void)playTestSound;

@end

NS_ASSUME_NONNULL_END
