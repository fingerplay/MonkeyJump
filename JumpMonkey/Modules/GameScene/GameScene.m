//
//  GameScene.m
//  JumpMonkey
//
//  Created by 罗谨 on 2019/5/10.
//  Copyright © 2019 finger. All rights reserved.
//

#import "GameScene.h"
#import "Monkey.h"
#import "Tree.h"
#import "TreesList.h"
#import "NormalNode.h"
#import "CommonDefine.h"
#import "Spider.h"
#import "Hawk.h"
#import "SKNumberNode.h"
#import "SoundManager.h"
#import "SKProgressNode.h"
#import "UserAccountManager.h"
#import "TimeUtil.h"

@interface GameScene ()<MonkeyDelegate,ScoreInfoDelegate>
@property (nonatomic, strong) NSMutableArray *foregroundNodes;
@property (nonatomic, strong) SKLabelNode *velocityLabel;
@property (nonatomic, strong) SKSpriteNode *heartImageNode;
@property (nonatomic, strong) SKLabelNode *lifeCountLabel;
@property (nonatomic, strong) SKLabelNode *countDownLabel;
@property (nonatomic, strong) NormalNode *backgroundNodeA;
@property (nonatomic, strong) NormalNode *backgroundNodeB;
@property (nonatomic, strong) Monkey *monkey;
@property (nonatomic, strong) TreesList *treesList;
@property (nonatomic, strong) Hawk *hawk;
@property (nonatomic, strong) SKNumberNode *totalScoreNode;
@property (nonatomic, strong) SKNumberNode *hopNode;
@property (nonatomic, strong) SKProgressNode *levelProgressNode;
@property (nonatomic, strong) SKLabelNode *levelTitleNode;
@property (nonatomic, strong) GameModel *gameModel;
//@property (nonatomic, strong) UserAccount *userAccount;

@property (nonatomic, assign) CGPoint startTouchPoint;
@property (nonatomic, strong) NSDate* startTouchTime;

@property (nonatomic, assign) BOOL isRemovingOldNode;
@property (nonatomic, strong) dispatch_source_t velocityTimer;
@property (nonatomic, strong) dispatch_source_t countDownTimer;
@property (nonatomic, assign) CGFloat sceneTotalOffset;
@property (nonatomic, assign) CGFloat sceneCurrentOffset;

@end

@implementation GameScene {

}

- (instancetype)initWithMode:(GameMode)gameMode{
    self = [super init];
    if (self) {
        GameModel *gameModel = [[GameModel alloc] init];
        gameModel.mode = gameMode;
        self.gameModel = gameModel;
        [[UserAccountManager sharedManager].currentAccount.levelInfo addObserver:self forKeyPath:@"upgradeProgress" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew context:NULL];
        [[UserAccountManager sharedManager].lifeInfo addObserver:self forKeyPath:@"lifeCount" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew context:NULL];
    }
    return self;
}


- (void)dealloc {
     NSLog(@"%@ dealloc",[self class]);
    [self removeChildNodes];
    [[UserAccountManager sharedManager].currentAccount.levelInfo removeObserver:self forKeyPath:@"upgradeProgress"];
    [[UserAccountManager sharedManager].lifeInfo removeObserver:self forKeyPath:@"lifeCount"];
}

- (void)didMoveToView:(SKView *)view {
    // Setup your scene here
    self.mScore = [ScoreInfo new];
    [self setupVelocityTimer];
    [self addChildNodes];
    [self reLayoutObservableNodes];
    dispatch_resume(self.velocityTimer);
    if (self.gameModel.mode == GameModeTimeLimit) {
        [self setupCountDownTimer];
        dispatch_resume(self.countDownTimer);
    }
}

//因为有些node的内容是监听全局变量的，会在gameScene frame设置之前被调用，所以在gameScene frame设置之后还要重新给他布局
- (void)reLayoutObservableNodes {
    self.levelTitleNode.position = CGPointMake(20, self.size.height - 20);
//    self.levelTitleNode.text = [NSString stringWithFormat:@"LV%ld",(long)self.self.userAccount.levelInfo.level];
    self.levelProgressNode.position =  CGPointMake(self.levelTitleNode.frame.size.width + self.levelTitleNode.frame.origin.x + 10, self.levelTitleNode.position.y+3);
    self.lifeCountLabel.position = CGPointMake(0, -self.heartImageNode.size.height/4);
}

- (void)addChildNodes {
    self.gameModel.gameStartTime = [NSDate date];
    if (self.gameModel.mode == GameModeTimeLimit) {
        self.gameModel.remainTime = MAX_TIME_LIMIT;
    }

    self.sceneTotalOffset = 0;
    if(self.gameModel.mode == GameModeTimeLimit) {
        self.countDownLabel.text = [TimeUtil getMinAndSecWithDuration:self.gameModel.remainTime];
    }
    
    self.velocityLabel.text = @"0M/s";

    [self createBackgroundNodes];
    [self addChild:self.backgroundNodeA];
    [self addChild:self.backgroundNodeB];
    
    self.treesList = [[TreesList alloc] init];
 
    HookNode *firstTree = [self.treesList generateSingleNodeWithType:HookNodeTypeStable position:CGPointMake(MONKEY_MIN_X, TREE_POSITION_Y)];
    [self addChild:firstTree];
    NSArray *nodes = [self.treesList generateNodesWithDistanceX:kDefaultTreeDistanceX count:5];
    for (NSUInteger i=0; i<nodes.count; i++) {
        HookNode *node = [nodes objectAtIndex:i];
        if ([node isKindOfClass:[Spider class]]) {
            NormalNode *line = ((Spider*)node).line;
            [self addChild:line];
        }
        [self addChild:node];
    }
    
    [self createForegroundNodes];
    
    self.monkey = [[Monkey alloc] initWithImageNamed:@"monkey_swing" hookNode:firstTree];
    self.monkey.delegate = self;

    [firstTree addChild:self.monkey];
    
    self.hawk = [[Hawk alloc] initWithImageNamed:@"hawk_list"];
    self.hawk.hidden = YES;
    self.hawk.number = 1;
    [self addChild:self.hawk];
    self.monkey.hawk = self.hawk;
    self.monkey.mScore = self.mScore;
    if (self.gameModel.mode == GameModeTimeLimit) {
        [self addChild:self.countDownLabel];
    }
    [self addChild:self.levelTitleNode];
    [self addChild:self.levelProgressNode];
    [self.levelProgressNode updateWithProgress:[UserAccountManager sharedManager].currentAccount.levelInfo.upgradeProgress];
    [self addChild:self.totalScoreNode];
    [self addChild:self.heartImageNode];
    [self.heartImageNode addChild:self.lifeCountLabel];
    [self addChild:self.velocityLabel];
    [self addChild:self.hopNode];
    [self addChild:[SoundManager sharedManger]];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.hawk.hidden = NO;
        [self.hawk startMoveWithLocation:CGPointMake(self.monkey.offsetX + SCREEN_W/5 - self.hawk.size.width/2, -self.hawk.size.height/2)];
    });

    [[SoundManager sharedManger] playCockSound];
}

- (void)resetNodes {
//    self.paused = YES;
    [[UserAccountManager sharedManager].lifeInfo subtractLifeByDrop];
    HookNode *currentHook = self.monkey.hookNode.preNode;
    currentHook.position = CGPointMake(MONKEY_MIN_X, TREE_POSITION_Y);
    HookNode *lastHook = currentHook;
    while (lastHook.nextNode) {
        HookNode *node = lastHook.nextNode;
        node.position = CGPointMake([lastHook getRealHook].x + kDefaultTreeDistanceX, TREE_POSITION_Y);
        lastHook = node;
    }
    [self.monkey removeDelayJump];
    [self.monkey resetPositionWithNode:currentHook];
//    self.paused = NO;
    [self.monkey removeFromParent];
    [currentHook addChild:self.monkey];
}

- (void)removeChildNodes {
    [self.heartImageNode removeAllChildren];
    [self removeAllChildren];
    [self.treesList.nodes removeAllObjects];
    self.monkey = nil;
    self.backgroundNodeA = nil;
    self.backgroundNodeB = nil;
    [self.foregroundNodes removeAllObjects];
    self.treesList = nil;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"upgradeProgress"]) {
        UserAccount *userAccount = [UserAccountManager sharedManager].currentAccount;
        self.levelTitleNode.text = [NSString stringWithFormat:@"LV%ld",(long)userAccount.levelInfo.level];
        [self.levelProgressNode updateWithProgress:userAccount.levelInfo.upgradeProgress];
    }else if ([keyPath isEqualToString:@"lifeCount"]) {
        NSString *str = [NSString stringWithFormat:@"%ld",[UserAccountManager sharedManager].lifeInfo.lifeCount];
        self.lifeCountLabel.text = str;
    }
}

- (void)updateInitialScore:(NSInteger)score {
    self.gameModel.initialScore = score;
}

#pragma mark - Action

- (void)touchDownAtPoint:(CGPoint)pos {
    self.startTouchPoint = pos;
    self.startTouchTime = [NSDate date];
}

- (void)touchMovedToPoint:(CGPoint)pos {
   
}

- (void)touchUpAtPoint:(CGPoint)pos {
    if (!self.gameModel.isGameOver && (self.monkey.state == MonkeyStateSwing || self.monkey.state == MonkeyStateRide) ){
        NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:self.startTouchTime];
        CGFloat offsetX = pos.x - self.startTouchPoint.x;
        CGFloat offsetY = (pos.y - self.startTouchPoint.y);
        
        CGFloat vx = offsetX / interval;
        CGFloat vy = MIN(offsetY/ interval,5000);
        [self.monkey jumpWithVx:vx vy:vy/MONKEY_UPSWIPE_RATE];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {[self touchDownAtPoint:[t locationInNode:self]];}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch *t in touches) {[self touchMovedToPoint:[t locationInNode:self]];}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {[self touchUpAtPoint:[t locationInNode:self]];}
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {[self touchUpAtPoint:[t locationInNode:self]];}
}

#pragma mark - Draw

-(void)update:(CFTimeInterval)currentTime {
    // Called before each frame is rendered
    if (!self.gameModel.isGameOver) {
        [self moveAllNodes];
    }
}

- (void)moveAllNodes {
    [self.monkey move];
    for (HookNode *node in self.treesList.nodes) {
        [node moveWithSceneVelocity:self.monkey.sceneMoveVelocity];
    }
    
    for (NormalNode *fgNode in self.foregroundNodes) {
        [fgNode moveWithSceneVelocity:self.monkey.sceneMoveVelocity];
    }
    
    [self.hawk moveWithSceneVelocity:self.monkey.sceneMoveVelocity];

    [self.backgroundNodeA moveWithSceneVelocity:self.monkey.sceneMoveVelocity/BACKGROUND_MOVE_RATE];
    [self. backgroundNodeB moveWithSceneVelocity:self.monkey.sceneMoveVelocity/BACKGROUND_MOVE_RATE];
   
    [self switchBackgroundPosition];
    [self switchForegroundPosition];
    self.sceneTotalOffset += self.monkey.sceneMoveVelocity;
    self.sceneCurrentOffset += self.monkey.sceneMoveVelocity;
}

#pragma mark - MonkeyDelegate
- (void)monkeyDidMoveTo:(CGPoint)position {
    if (self.monkey.state == MonkeyStateJump && position.y< -self.monkey.size.height) {//跳出屏幕，游戏结束
        if (self.gameModel.mode == GameModeTimeLimit) {
            self.gameModel.remainTime -= DROP_TIME_SUBTRACT;
            self.monkey.mScore.dropCount += 1;
            if (self.gameModel.remainTime <= 0) {
                [self gameDidEnd];
            }else{
                [self resetNodes];
                [self showSubtractScoreLabel];
            }

        }else{
            [self gameDidEnd];
        }
        [[UserAccountManager sharedManager] saveLifeInfoAsync];
        return;
    }
    
    if (self.isRemovingOldNode) {
        return;
    }
    HookNode *oldNode = [self.treesList.nodes firstObject];
    if (oldNode.position.x < - (oldNode.size.width/2 + kDefaultTreeDistanceX) ) {
       // NSLog(@"remove old node.. %@",oldNode.name);
        self.isRemovingOldNode = YES;
        if ([oldNode isKindOfClass:[Spider class]]) {
            NormalNode *line = ((Spider*)oldNode).line;
            [line removeFromParent];
        }
        [oldNode removeFromParent];
        [self.treesList removeNode:oldNode];
    }
    
    if (self.isRemovingOldNode) {
        NSCAssert(self.treesList.nodes.firstObject != oldNode, @"node remove failed");
        HookNodeType type = arc4random_uniform(HookNodeTypeCount);
        HookNode* newNode = [self.treesList generateSingleNodeWithType:type distance:kDefaultTreeDistanceX];
        NSInteger fgIndex = [self.children indexOfObject:self.foregroundNodes.firstObject];
        NSInteger insertIndex;
        if (fgIndex > 2) {
            insertIndex = fgIndex - 1;
        }else if (self.children.count > 2){
            insertIndex = 2;
        }else {
            insertIndex = self.children.count;
        }
        [self insertChild:newNode atIndex:insertIndex];
      //  NSLog(@"add new node [%@] at index %ld",newNode.name,insertIndex);
        if ([newNode isKindOfClass:[Spider class]]) {
            NormalNode *line = ((Spider*)newNode).line;
            [self insertChild:line atIndex:insertIndex];
        }
    }
 
    self.isRemovingOldNode = NO;
}

- (void)monkeyDidJumpToHookNode:(HookNode *)node {

    [self showAddScoreLabel];
    if (self.gameDelegate && [self.gameDelegate respondsToSelector:@selector(monkeyDidJumpToHookNode:)]) {
        [self.gameDelegate monkeyDidJumpToHookNode:node];
    }
    [self.hopNode setNumber:self.monkey.mScore.mMaxHops];
}

- (void)monkeyDidJumpFromHookNode:(HookNode *)node {
    if (self.gameDelegate && [self.gameDelegate respondsToSelector:@selector(monkeyDidJumpFromHookNode:)]) {
        [self.gameDelegate monkeyDidJumpFromHookNode:node];
    }
}

- (void)scoreDidUpdate:(NSInteger)score {
    [self.totalScoreNode setNumber:self.monkey.mScore.score];
    NSInteger currentScore = self.gameModel.initialScore + score;

    [UserAccountManager sharedManager].currentAccount.scores = currentScore;

    if (self.gameDelegate && [self.gameDelegate respondsToSelector:@selector(scoreDidUpdate:)]) {
        [self.gameDelegate scoreDidUpdate:self.monkey.mScore.score];
    }

}

#pragma mark - Private
- (void)setupVelocityTimer {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.velocityTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(self.velocityTimer, dispatch_walltime(NULL,0), 1.0*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(self.velocityTimer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.velocityLabel.text = [NSString stringWithFormat:@"%1.1fM/s",self.sceneCurrentOffset/SCREEN_W * 18.f];
            self.sceneCurrentOffset = 0;
        });
    });
}

- (void)setupCountDownTimer {
    if (self.countDownTimer) {
        return;
    }
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.countDownTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(self.countDownTimer, dispatch_walltime(NULL,1.0*NSEC_PER_SEC), 1.0*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(self.countDownTimer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.gameModel.mode == GameModeTimeLimit) {
                self.gameModel.remainTime -= 1;
                self.countDownLabel.text = [TimeUtil getMinAndSecWithDuration:self.gameModel.remainTime];
                if (self.gameModel.remainTime <= 0) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self gameDidEnd];
                    });
                }
            }
        });
    });
}

- (void)showAddScoreLabel {
    if (self.monkey.mScore.lastAccScore>0) {
        SKAction *moveAction = [SKAction moveTo:CGPointMake(self.size.width, self.size.height) duration:3];
        SKAction *scaleAction = [SKAction scaleTo:0 duration:3];
        SKAction *removeAction = [SKAction removeFromParent];
        SKNumberNode *scoreNode = [[SKNumberNode alloc] initWithImageNamed:@"number_2_frame_list" charSequence:@"0123456789+-"];
        scoreNode.showPlusSign = YES;
        scoreNode.maxHeight = 30;
        [scoreNode setNumber:self.monkey.mScore.lastAccScore];
//        scoreNode.position = [self.monkey.hookNode getRealHook];
        scoreNode.position = self.totalScoreNode.position;
        SKAction *actionGroup =[SKAction group:@[moveAction, scaleAction]];
        [scoreNode runAction:[SKAction sequence:@[actionGroup, removeAction]]];

        [self addChild:scoreNode];
    }

}

- (void)showSubtractScoreLabel {
    SKAction *moveAction = [SKAction moveTo:CGPointMake(self.size.width, self.size.height) duration:3];
    SKAction *scaleAction = [SKAction scaleTo:0 duration:3];
    SKAction *removeAction = [SKAction removeFromParent];
    SKNumberNode *scoreNode = [[SKNumberNode alloc] initWithImageNamed:@"number_2_frame_list" charSequence:@"0123456789+-"];
    scoreNode.showPlusSign = NO;
    scoreNode.maxHeight = 30;
    [scoreNode setNumber: - DROP_TIME_SUBTRACT];

    scoreNode.position = self.countDownLabel.position;
    SKAction *actionGroup =[SKAction group:@[moveAction, scaleAction]];
    [scoreNode runAction:[SKAction sequence:@[actionGroup, removeAction]]];
    
    [self addChild:scoreNode];
}

- (void)gameDidEnd {
    if (!self.gameModel.isGameOver) {
        [[UserAccountManager sharedManager].lifeInfo subtractLifeByDrop];
        [self.monkey removeDelayJump];
        [self.monkey removeFromParent];
        dispatch_suspend(self.velocityTimer);
        if (self.gameModel.mode == GameModeTimeLimit) {
            dispatch_suspend(self.countDownTimer);
        }
        [self.countDownLabel removeFromParent];
        [[SoundManager sharedManger] playGameOverSound];
//        self.paused = YES;
        self.gameModel.isGameOver = YES;
        
        self.mScore.duration = [[NSDate date] timeIntervalSinceDate:self.gameModel.gameStartTime];
        self.mScore.distance = MAX(ceil(self.sceneTotalOffset /SCREEN_W * 18.f),0);
        
        if (self.gameDelegate && [self.gameDelegate respondsToSelector:@selector(gameDidEndWithTimeout:)]) {
            [self.gameDelegate gameDidEndWithTimeout:(self.gameModel.remainTime<=0)];
        }
    }
}

- (void)gameRestart {
    
    self.gameModel.initialScore = [UserAccountManager sharedManager].currentAccount.scores;
    //删除子节点
    [self removeChildNodes];
    //重新添加子节点
    [self addChildNodes];
    [self.monkey.mScore clearScore];
    self.totalScoreNode.number = 0;
    self.hopNode.number = 0;
  
    dispatch_resume(self.velocityTimer);
    if (self.gameModel.mode == GameModeTimeLimit) {
        [self setupCountDownTimer];
        dispatch_resume(self.countDownTimer);
    }
    
//    self.paused = NO;
    self.gameModel.isGameOver = NO;
 
    if (self.gameDelegate && [self.gameDelegate respondsToSelector:@selector(gameDidRestart)]) {
        [self.gameDelegate gameDidRestart];
    }
}

- (void)switchBackgroundPosition {
    if (self.backgroundNodeA.position.x <= -(self.backgroundNodeA.size.width + self.backgroundNodeB.size.width - self.size.width)) {
        NormalNode *temp = [self.backgroundNodeB copy];
        temp.position = CGPointMake(temp.position.x+ temp.size.width, temp.position.y);
        [self.backgroundNodeA removeFromParent];
        self.backgroundNodeA = self.backgroundNodeB;
        self.backgroundNodeB = temp;
        [self insertChild:self.backgroundNodeB atIndex:1];
    }
}

- (void)switchForegroundPosition {
    NormalNode *firstNode = self.foregroundNodes.firstObject;
    if (firstNode.position.x <=  -firstNode.size.width) {
        NormalNode *newNode = [self createSingleForeGroundNode];
        NSInteger index = [self.children indexOfObject:firstNode];
        [firstNode removeFromParent];
        [self.foregroundNodes removeObject:firstNode];
        [self insertChild:newNode atIndex:index];
    }
}

- (void)createBackgroundNodes {
    int imageIndex = arc4random() % 4;
    NSArray *imageNames = @[@"ch1",@"ch2",@"ch3",@"ch4"];
    UIImage *image = [UIImage imageNamed:imageNames[imageIndex]];
    SKTexture *texture = [SKTexture textureWithImage:image];
    
    self.backgroundNodeA = [[NormalNode alloc] initWithTexture:texture];
    self.backgroundNodeA.anchorPoint = CGPointMake(0, 0);
    self.backgroundNodeA.position = CGPointMake(0, 0);
    self.backgroundNodeA.size = CGSizeMake(self.size.width, self.size.height);
    
    self.backgroundNodeB = [[NormalNode alloc] initWithTexture:texture];
    self.backgroundNodeB.anchorPoint = CGPointMake(0, 0);
    self.backgroundNodeB.position = CGPointMake(self.size.width, 0);
    self.backgroundNodeB.size = CGSizeMake(self.size.width, self.size.height);
}

- (void)createForegroundNodes {
    NSArray *imageNames = @[@"fg1",@"fg2"];
    
    CGFloat lastX = 0;
    while (lastX < self.size.width*2) {
        int imageIndex = arc4random() % 2;
        UIImage *image = [UIImage imageNamed:imageNames[imageIndex]];
        SKTexture *texture = [SKTexture textureWithImage:image];
        
        NormalNode* newNode = [[NormalNode alloc] initWithTexture:texture];
        newNode.name = [NSString stringWithFormat:@"fg_%f",lastX];
        newNode.anchorPoint = CGPointMake(0, 0);
        newNode.position = CGPointMake(lastX, 0);
        newNode.size = CGSizeMake(80 / image.size.height * image.size.width, 80);
        lastX += newNode.size.width;
        [self.foregroundNodes addObject:newNode];
        [self addChild:newNode];
    }
    
}

- (NormalNode*)createSingleForeGroundNode{
    NSArray *imageNames = @[@"fg1",@"fg2"];
    NormalNode *lastNode =self.foregroundNodes.lastObject;
    CGFloat lastX = lastNode.position.x + lastNode.size.width;

    int imageIndex = arc4random() % 2;
    UIImage *image = [UIImage imageNamed:imageNames[imageIndex]];
    SKTexture *texture = [SKTexture textureWithImage:image];
        
    NormalNode* newNode = [[NormalNode alloc] initWithTexture:texture];
    newNode.anchorPoint = CGPointMake(0, 0);
    newNode.position = CGPointMake(lastX, 0);
    newNode.size = CGSizeMake(80 / image.size.height * image.size.width, 80);
//    lastX += newNode.size.width;
    [self.foregroundNodes addObject:newNode];
    return newNode;
}

#pragma mark - Property

- (NormalNode *)backgroundNodeA {
    if (!_backgroundNodeA) {
        _backgroundNodeA = [[NormalNode alloc] initWithImageNamed:@"ch2"];
        _backgroundNodeA.name = @"bgA";
        _backgroundNodeA.anchorPoint = CGPointMake(0, 0);
        _backgroundNodeA.position = CGPointMake(0, 0);
        _backgroundNodeA.size = CGSizeMake(self.size.width, self.size.height);
    }
    return _backgroundNodeA;
}


- (NormalNode *)backgroundNodeB {
    if (!_backgroundNodeB) {
        _backgroundNodeB = [[NormalNode alloc] initWithImageNamed:@"ch2"];
        _backgroundNodeB.name = @"bgB";
        _backgroundNodeB.anchorPoint = CGPointMake(0, 0);
        _backgroundNodeB.position = CGPointMake(self.size.width, 0);
        _backgroundNodeB.size = CGSizeMake(self.size.width, self.size.height);
    }
    return _backgroundNodeB;
}

- (NSMutableArray *)foregroundNodes {
    if (!_foregroundNodes) {
        _foregroundNodes = [[NSMutableArray alloc] init];
    }
    return _foregroundNodes;
}

- (SKNumberNode *)totalScoreNode {
    if (!_totalScoreNode) {
        _totalScoreNode = [[SKNumberNode alloc] initWithImageNamed:@"number_1_frame_list" charSequence:@"0123456789"];
        _totalScoreNode.position = CGPointMake(self.size.width/2 , self.size.height - 30);
        _totalScoreNode.maxHeight = 30;
        _totalScoreNode.anchorPoint = CGPointMake(0.5, 0.5);
    }
    return _totalScoreNode;
}

- (SKNumberNode *)hopNode {
    if (!_hopNode) {
        _hopNode = [[SKNumberNode alloc] initWithImageNamed:@"number_2_frame_list" charSequence:@"0123456789+-"];
        _hopNode.showPlusSign = NO;
        _hopNode.maxHeight = 30;
        [_hopNode setNumber:0];
        _hopNode.position = CGPointMake(self.size.width - _hopNode.size.width - 40, self.size.height - _hopNode.size.height - 5);
        _hopNode.anchorPoint = CGPointZero;

    }
    return _hopNode;
}

- (SKLabelNode *)velocityLabel {
    if (!_velocityLabel) {
        _velocityLabel = [[SKLabelNode alloc] init];
        _velocityLabel.position = CGPointMake(self.size.width - 40, self.size.height - 50);
        _velocityLabel.fontColor = [UIColor whiteColor];
        _velocityLabel.fontSize = 16;
        _velocityLabel.fontName = @"Helvetica";
    }
    return _velocityLabel;
}

- (SKLabelNode *)countDownLabel {
    if (!_countDownLabel) {
        _countDownLabel = [[SKLabelNode alloc] init];
        _countDownLabel.position = CGPointMake(30, self.size.height - 90);
        _countDownLabel.fontColor = [UIColor whiteColor];
        _countDownLabel.fontSize = 18;
        _countDownLabel.fontName = @"Helvetica";
    }
    return _countDownLabel;
}

- (SKLabelNode *)levelTitleNode {
    if (!_levelTitleNode) {
        NSString *levelStr = [NSString stringWithFormat:@"LV%ld",(long)[UserAccountManager sharedManager]. currentAccount.levelInfo.level];
        _levelTitleNode = [SKLabelNode labelNodeWithText:levelStr];
//        _levelTitleNode.position = CGPointMake(20, self.size.height - 20);
        _levelTitleNode.fontSize = 16;
        _levelTitleNode.fontName = @"Helvetica";
    }
    return _levelTitleNode;
}

- (SKProgressNode *)levelProgressNode {
    if (!_levelProgressNode) {
        _levelProgressNode = [SKProgressNode shapeNodeWithRect:CGRectMake(0, 0, PROGRESS_WIDTH, PROGRESS_HEIGHT) cornerRadius:PROGRESS_HEIGHT/2];
        _levelProgressNode.fillColor = [UIColor blackColor];
//        _levelProgressNode.strokeColor = [UIColor whiteColor];
//        _levelProgressNode.position =  CGPointMake(self.levelTitleNode.frame.size.width + self.levelTitleNode.frame.origin.x + 10, self.levelTitleNode.position.y+3);
        
    }
    return _levelProgressNode;
}

- (SKLabelNode *)lifeCountLabel {
    if (!_lifeCountLabel) {
        NSString *str = [NSString stringWithFormat:@"%ld",[UserAccountManager sharedManager].lifeInfo.lifeCount];
        _lifeCountLabel = [SKLabelNode labelNodeWithText:str];
        _lifeCountLabel.fontSize = 12;
        _lifeCountLabel.fontName = @"Helvetica";
    }
    return _lifeCountLabel;
}

- (SKSpriteNode *)heartImageNode {
    if (!_heartImageNode) {
        SKTexture* txr = [SKTexture textureWithImage:[UIImage imageNamed:@"icn_heart"]];
        _heartImageNode = [[SKSpriteNode alloc] initWithTexture:txr];
        _heartImageNode.position = CGPointMake(self.frame.size.width - 20, self.frame.size.height - 20);
    }
    return _heartImageNode;
}
@end
