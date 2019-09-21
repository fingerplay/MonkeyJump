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

@interface GameScene ()<MonkeyDelegate,ScoreInfoDelegate>
@property (nonatomic, strong) NSMutableArray *foregroundNodes;
@property (nonatomic, strong) SKLabelNode *velocityLabel;
@property (nonatomic, strong) NormalNode *backgroundNodeA;
@property (nonatomic, strong) NormalNode *backgroundNodeB;
@property (nonatomic, strong) Monkey *monkey;
@property (nonatomic, strong) TreesList *treesList;
@property (nonatomic, strong) Hawk *hawk;
@property (nonatomic, strong) SKNumberNode *totalScoreNode;
@property (nonatomic, strong) SKNumberNode *hopNode;

@property (nonatomic, strong) GameModel *gameModel;

@property (nonatomic, assign) CGPoint startTouchPoint;
@property (nonatomic, strong) NSDate* startTouchTime;

@property (nonatomic, assign) BOOL isRemovingOldNode;
@property (nonatomic, strong) dispatch_source_t velocityTimer;
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
    }
    return self;
}

- (void)dealloc {
     NSLog(@"%@ dealloc",[self class]);
    [self removeChildNodes];
}

- (void)didMoveToView:(SKView *)view {
    // Setup your scene here
    self.mScore = [ScoreInfo new];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.velocityTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(self.velocityTimer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(self.velocityTimer, ^{
        
        self.velocityLabel.text = [NSString stringWithFormat:@"%1.1fM/s",self.sceneCurrentOffset/SCREEN_W * 18.f];
        self.sceneCurrentOffset = 0;
    });
    
    [self addChildNodes];
}

- (void)addChildNodes {
    self.gameModel.gameStartTime = [NSDate date];
    self.sceneTotalOffset = 0;
    
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
    [self addChild:self.totalScoreNode];
    [self addChild:self.velocityLabel];
    [self addChild:self.hopNode];
    [self addChild:[SoundManager sharedManger]];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.hawk.hidden = NO;
        [self.hawk startMoveWithLocation:CGPointMake(self.monkey.offsetX + SCREEN_W/5 - self.hawk.size.width/2, -self.hawk.size.height/2)];
    });
       dispatch_resume(self.velocityTimer);

    [[SoundManager sharedManger] playCockSound];
}

- (void)resetNodes {
 
    HookNode *currentHook = self.monkey.hookNode.preNode;
    currentHook.position = CGPointMake(MONKEY_MIN_X, TREE_POSITION_Y);
    HookNode *lastHook = currentHook;
    while (lastHook.nextNode) {
        HookNode *node = lastHook.nextNode;
        node.position = CGPointMake([lastHook getRealHook].x + kDefaultTreeDistanceX, TREE_POSITION_Y);
        lastHook = node;
    }
    
    [self.monkey resetPositionWithNode:currentHook];
    [currentHook addChild:self.monkey];
}

- (void)removeChildNodes {
    dispatch_suspend(self.velocityTimer);
    [self removeAllChildren];
    [self.treesList.nodes removeAllObjects];
    self.monkey = nil;
    self.backgroundNodeA = nil;
    self.backgroundNodeB = nil;
    [self.foregroundNodes removeAllObjects];
    self.treesList = nil;
    
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
        [self gameDidEnd];
        return;
    }
    
    if (self.isRemovingOldNode) {
        return;
    }
    HookNode *oldNode = [self.treesList.nodes firstObject];
    if (oldNode.position.x < - (oldNode.size.width/2 + kDefaultTreeDistanceX) ) {
        NSLog(@"remove old node.. %@",oldNode.name);
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
        [self insertChild:newNode atIndex:fgIndex-1];
        NSLog(@"add new node!! %@",newNode.name);
        if ([newNode isKindOfClass:[Spider class]]) {
            NormalNode *line = ((Spider*)newNode).line;
            [self insertChild:line atIndex:fgIndex-1];
        }
    }
 
    self.isRemovingOldNode = NO;

//    self.velocityLabel.text = [NSString stringWithFormat:@"%1.1fM/s",self.monkey.monkeyVolecity.horizontal/SCREEN_W * 18.f * FPS];
//    self.velocityLabel.text = [NSString stringWithFormat:@"%1.1fM/s",self.mScore.distance/self.mScore.duration];
//      self.velocityLabel.text = [NSString stringWithFormat:@"%1.1fM/s",self.monkey.sceneMoveVelocity];
}

- (void)monkeyDidJumpToHookNode:(HookNode *)node {

    [self showScoreLabel];
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
    if (self.gameDelegate && [self.gameDelegate respondsToSelector:@selector(scoreDidUpdate:)]) {
        [self.gameDelegate scoreDidUpdate:self.monkey.mScore.score];
    }

}

#pragma mark - Private
- (void)showScoreLabel {
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

- (void)gameDidEnd {
    if (!self.gameModel.isGameOver) {
        [self.monkey removeDelayJump];
        [self.monkey removeFromParent];
        [[SoundManager sharedManger] playGameOverSound];
//        self.paused = YES;
        self.gameModel.isGameOver = YES;
        
        self.mScore.duration = [[NSDate date] timeIntervalSinceDate:self.gameModel.gameStartTime];
        self.mScore.distance = MAX(ceil(self.sceneTotalOffset /SCREEN_W * 18.f),0);
        
        if (self.gameDelegate && [self.gameDelegate respondsToSelector:@selector(gameDidEnd)]) {
            [self.gameDelegate gameDidEnd];
        }
    }
}

- (void)gameRestart {
    if (self.gameModel.mode == GameModeFree) {
        //删除子节点
        [self removeChildNodes];
        
        //重新添加子节点
        [self addChildNodes];
        
        [self.monkey.mScore clearScore];
        self.totalScoreNode.number = 0;
        self.hopNode.number = 0;
    }else{
        [self resetNodes];
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
        _backgroundNodeA.anchorPoint = CGPointMake(0, 0);
        _backgroundNodeA.position = CGPointMake(0, 0);
        _backgroundNodeA.size = CGSizeMake(self.size.width, self.size.height);
    }
    return _backgroundNodeA;
}


- (NormalNode *)backgroundNodeB {
    if (!_backgroundNodeB) {
        _backgroundNodeB = [[NormalNode alloc] initWithImageNamed:@"ch2"];
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
        _hopNode.position = CGPointMake(self.size.width - _hopNode.size.width - 5, self.size.height - _hopNode.size.height - 5);
        _hopNode.anchorPoint = CGPointZero;

    }
    return _hopNode;
}

- (SKLabelNode *)velocityLabel {
    if (!_velocityLabel) {
        _velocityLabel = [[SKLabelNode alloc] init];
        _velocityLabel.position = CGPointMake(40, self.size.height - 30);
        _velocityLabel.fontColor = [UIColor whiteColor];
        _velocityLabel.fontSize = 18;
    }
    return _velocityLabel;
}

@end
