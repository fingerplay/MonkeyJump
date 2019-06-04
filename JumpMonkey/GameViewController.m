//
//  GameViewController.m
//  JumpMonkey
//
//  Created by 罗谨 on 2019/5/10.
//  Copyright © 2019 finger. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"
#import "ImageSequence.h"
#import "ClockImageView.h"

@interface GameViewController ()<GameSceneDelegate>
@property (nonatomic, strong) GameScene *scene;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *restartBtn;
@property (nonatomic, strong) ClockImageView *countdownView;
@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Load the SKScene from 'GameScene.sks'
    GameScene *scene = [GameScene sceneWithSize:CGSizeMake(self.view.width, self.view.height)];
    
    // Set the scale mode to scale to fit the window
    scene.scaleMode = SKSceneScaleModeAspectFill;
    scene.gameDelegate = self;
    scene.anchorPoint = CGPointMake(0, 0);
    self.scene = scene;
    
    SKView *skView = (SKView *)self.view;
    
    // Present the scene
    [skView presentScene:scene];
    
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    skView.preferredFramesPerSecond = FPS;
    
    
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.restartBtn];
    [self.view addSubview:self.countdownView];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskLandscape;
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - GameSceneDelegate

- (void)monkeyDidJumpToHookNode:(HookNode *)node {
    if (node.type == HookNodeTypeStable || node.type == HookNodeTypeMove) {
        [self.countdownView startClockingWithDuration:MONKEY_SWING_MAX_DURATION tag:node.number];
    }
}

- (void)monkeyDidJumpFromHookNode:(HookNode *)node {
    [self.countdownView stopClockingWithTag:node.number];
}

-(void)gameDidEnd {
    self.titleLabel.hidden = NO;
    self.restartBtn.hidden = NO;
}

#pragma mark - Action
- (void)restartBtnClick:(UIButton*)button {
    [self.scene gameRestart];
    self.titleLabel.hidden = YES;
    self.restartBtn.hidden = YES;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 120, 240, 50)];
        _titleLabel.centerX = self.view.width/2;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = @"Game Over";
        _titleLabel.font = [UIFont systemFontOfSize:44];
        _titleLabel.hidden = YES;
    }
    return _titleLabel;
}

- (UIButton *)restartBtn {
    if (!_restartBtn) {
        _restartBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 200, 200, 40)];
        _restartBtn.centerX = self.view.width/2;
        [_restartBtn setTitle:@"Restart" forState:UIControlStateNormal];
        _restartBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        [_restartBtn addTarget:self action:@selector(restartBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _restartBtn.hidden = YES;
    }
    return _restartBtn;
}


- (ClockImageView *)countdownView {
    if (!_countdownView) {
        UIImage *image = [UIImage imageNamed:@"bubble_tree"];
        _countdownView = [[ClockImageView alloc] initWithFrame:CGRectMake(self.view.width - image.size.width-5, 5, image.size.width, image.size.height)];
        _countdownView.image = image;
        _countdownView.layer.cornerRadius = image.size.width/2;
        _countdownView.layer.masksToBounds = YES;
    }
    return _countdownView;
}
@end
