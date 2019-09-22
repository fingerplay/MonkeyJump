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
#import "ScoreView.h"
#import "Hawk.h"
#import "Tree.h"
#import "Spider.h"
#import <UShareUI/UShareUI.h>
#import "ScoreAPI.h"
#import "RecordAPI.h"
#import "DBHelper.h"

@interface GameViewController ()<GameSceneDelegate,UMSocialShareMenuViewDelegate>
@property (nonatomic, strong) GameScene *scene;
@property (nonatomic, strong) UIImageView *snapshotView;
@property (nonatomic, strong) ScoreView *scoreView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *restartBtn;
@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) UIButton *exitBtn;
@property (nonatomic, strong) UILabel *velocityLabel;
@property (nonatomic, strong) ClockImageView *countdownView;
@property (nonatomic, strong) SKSpriteNode *darkMask;

@end

@implementation GameViewController

- (void)dealloc {
    NSLog(@"%@ dealloc",[self class]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [UMSocialUIManager setShareMenuViewDelegate:self];
    [self setupView];
    [self loadScoreFromServer];
}

- (void)setupView {
    // Load the SKScene from 'GameScene.sks'
//    GameScene *scene = [GameScene sceneWithSize:CGSizeMake(self.view.width, self.view.height)];
    GameScene *scene = [[GameScene alloc] initWithMode:self.gameMode];
    scene.size = self.view.size;

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
    
    [self.view addSubview:self.countdownView];
    [self.view addSubview:self.snapshotView];
    [self.view addSubview:self.titleLabel];
    [self.snapshotView addSubview:self.shareBtn];
    [self.snapshotView addSubview:self.restartBtn];
    [self.snapshotView addSubview:self.exitBtn];
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
    if ([node isKindOfClass:[Hawk class]]) {
        self.countdownView.image = [UIImage imageNamed:@"bubble_bird"];
        [self.countdownView startClockingWithDuration:MONKEY_RIDE_MAX_DURATION tag:node.number];
    } else {
        self.countdownView.image = [UIImage imageNamed:@"bubble_tree"];
        [self.countdownView startClockingWithDuration:MONKEY_SWING_MAX_DURATION tag:node.number];
    }
}

- (void)monkeyDidJumpFromHookNode:(HookNode *)node {
    [self.countdownView stopClockingWithTag:node.number];
    self.countdownView.image = nil;
}

-(void)gameDidEndWithTimeout:(BOOL)isTimeout {
    self.titleLabel.hidden = NO;
    SKTexture *texture = [self.scene.view textureFromNode:self.scene];
    self.snapshotView.image = [UIImage imageWithCGImage:texture.CGImage];
    self.scoreView.score = self.scene.mScore;
    [self saveScoreAndRecord];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.snapshotView.hidden = NO;
        self.titleLabel.hidden = YES;
        [self.scene addChild:self.darkMask];
    });
}

- (void)gameDidRestart {
    self.snapshotView.hidden = YES;
    [self.darkMask removeFromParent];
}

- (void)saveScoreAndRecord {
    UpdateScoreAPI *scoreAPI = [[UpdateScoreAPI alloc] init];
    scoreAPI.score = self.scene.mScore.score;
    [scoreAPI startRequestWithSuccCallback:^(QMStatus *status, QMInput *input, id output) {
        NSLog(@"积分同步成功");
    } failCallback:^(QMStatus *status, QMInput *input, NSError *error) {
        NSLog(@"积分同步失败,status:%ld",(long)status.code);
    }];
    
    AddRecordAPI *recordAPI = [[AddRecordAPI alloc] init];
    GameRecord *record = [[GameRecord alloc] initWithScore:self.scene.mScore];
    recordAPI.record = record;
    recordAPI.gameMode = self.gameMode;
    [recordAPI startRequestWithSuccCallback:^(QMStatus *status, QMInput *input, id output) {
         NSLog(@"游戏记录同步成功");
    } failCallback:^(QMStatus *status, QMInput *input, NSError *error) {
        NSLog(@"游戏记录同步失败,status:%ld",(long)status.code);
    }];
    
    //保存本地游戏记录
    NSError *err = nil;
    [[DBHelper sharedInstance] insertRecord:@[record] gameMode:GameModeFree withError:&err];
    if (err) {
        NSLog(@"游戏记录保存失败！");
    }
}

- (void)loadScoreFromServer {
    GetScoreAPI *api = [[GetScoreAPI alloc] init];
    [api startRequestWithSuccCallback:^(QMStatus *status, QMInput *input, id output) {
        NSLog(@"获取积分成功, output=%@",output);
    } failCallback:^(QMStatus *status, QMInput *input, NSError *error) {
        NSLog(@"获取积分失败");
    }];
}

#pragma mark - Action
- (void)restartBtnClick:(UIButton*)button {
    [self.scene gameRestart];
}

- (void)shareBtnClick:(UIButton*)button {
    //显示分享面板
//    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_Sina),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_WechatSession)]];
//    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
    UMShareWebpageObject *object = [[UMShareWebpageObject alloc] init];
    object.title = @"MonkeyRun";
    object.descr = @"一款猴子在丛林间跳跃的游戏，由永动力工作室设计制作，力求打造一款快节奏、强竞技的酷跑游戏";
    object.thumbImage = [UIImage imageNamed:@"monkeyicon"];
    object.webpageUrl = @"http://www.baidu.com";
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    messageObject.shareObject = object;
    
        [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatSession messageObject:messageObject currentViewController:self completion:^(id result, NSError *error) {
        
    }];
//        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:object currentViewController:self completion:^(id result, NSError *error) {
//
//        }];
//    }];
}

- (void)exitBtnClick:(UIButton*)button {
    [self.scene removeChildNodes];
    [self.countdownView stopClockingWithTag:0];
    [self.navigationController popViewControllerAnimated:YES];
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


- (UIButton *)shareBtn {
    if (!_shareBtn) {
        _shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.snapshotView.width - 300, self.snapshotView.height - 60, 80, 40)];
        [_shareBtn setTitle:@"分享" forState:UIControlStateNormal];
        _shareBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        _shareBtn.layer.cornerRadius = 2;
        _shareBtn.layer.masksToBounds = YES;
        _shareBtn.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4];
        [_shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareBtn;
}

- (UIButton *)restartBtn {
    if (!_restartBtn) {
        _restartBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.snapshotView.width - 210, self.snapshotView.height - 60, 80, 40)];
        [_restartBtn setTitle:@"继续" forState:UIControlStateNormal];
        _restartBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        _restartBtn.layer.cornerRadius = 2;
        _restartBtn.layer.masksToBounds = YES;
        _restartBtn.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4];
        [_restartBtn addTarget:self action:@selector(restartBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _restartBtn;
}

- (UIButton *)exitBtn {
    if (!_exitBtn) {
        _exitBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.snapshotView.width - 120, self.snapshotView.height - 60, 80, 40)];
        [_exitBtn setTitle:@"退出" forState:UIControlStateNormal];
        _exitBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        _exitBtn.layer.cornerRadius = 2;
        _exitBtn.layer.masksToBounds = YES;
        _exitBtn.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4];
        [_exitBtn addTarget:self action:@selector(exitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exitBtn;
}


- (ClockImageView *)countdownView {
    if (!_countdownView) {
        UIImage *image = [UIImage imageNamed:@"bubble_tree"];
        _countdownView = [[ClockImageView alloc] initWithFrame:CGRectMake(self.view.width - image.size.width-5, 40, image.size.width, image.size.height)];
//        _countdownView.image = image;
        _countdownView.layer.cornerRadius = image.size.width/2;
        _countdownView.layer.masksToBounds = YES;
    }
    return _countdownView;
}

- (UIImageView *)snapshotView {
    if (!_snapshotView) {
        _snapshotView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 30, self.view.width - 60, self.view.height - 60)];
        _snapshotView.backgroundColor = [UIColor whiteColor];
        _snapshotView.layer.borderColor = [UIColor whiteColor].CGColor;
        _snapshotView.layer.borderWidth = 2;
        _snapshotView.hidden = YES;
        _snapshotView.opaque = YES;
        _snapshotView.userInteractionEnabled = YES;
        [_snapshotView addSubview:self.scoreView];

    }
    return _snapshotView;
}

- (ScoreView *)scoreView {
    if (!_scoreView) {
        _scoreView = [[ScoreView alloc] initWithFrame:CGRectMake(0, 0, self.snapshotView.width, 200)];
    }
    return _scoreView;
   
}

- (SKSpriteNode *)darkMask {
    if (!_darkMask) {
        SKSpriteNode *darkMask = [[SKSpriteNode alloc] initWithColor:[UIColor colorWithWhite:0.2 alpha:0.8] size:self.scene.size];
        darkMask.position = CGPointMake(self.scene.size.width/2, self.scene.size.height/2);
        _darkMask = darkMask;
    }
    return _darkMask;
}
@end
