//
//  SoundManager.m
//  JumpMonkey
//
//  Created by 罗谨 on 2019/6/3.
//  Copyright © 2019 finger. All rights reserved.
//

#import "SoundManager.h"

@implementation SoundManager
static SoundManager * _shareInstance = nil;

+ (instancetype)sharedManger {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareInstance = [[SoundManager alloc] init];
    });
    return _shareInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSError *error = nil;
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:&error];

        AVPlayer *player = [[AVPlayer alloc] init];
        self.player = player;
    }
    return self;
}

- (void)playCatchHookSound {
    SKAction *playAction = [SKAction playSoundFileNamed:@"sound_catch_hook.wav" waitForCompletion:NO];
    [self runAction:playAction];
}

- (void)playGameOverSound {
    SKAction *playAction = [SKAction playSoundFileNamed:@"sound_game_over.wav" waitForCompletion:NO];
    [self runAction:playAction];
}

- (void)playTestSound {
    NSString *soundFile = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"MP3"];
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:soundFile]];
    [self.player replaceCurrentItemWithPlayerItem:item];
    [self.player play];
}

- (void)playWolfSound {
    SKAction *playAction = [SKAction playSoundFileNamed:@"sound_wolf.wav" waitForCompletion:NO];
    [self runAction:playAction];
}

@end
