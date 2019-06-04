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

@interface GameScene ()<MonkeyDelegate>
@property (nonatomic, strong) NSMutableArray *foregroundNodes;
@property (nonatomic, strong) NormalNode *backgroundNodeA;
@property (nonatomic, strong) NormalNode *backgroundNodeB;
@property (nonatomic, strong) Monkey *monkey;
@property (nonatomic, strong) TreesList *treesList;
@property (nonatomic, strong) Hawk *hawk;
@property (nonatomic, strong) SKNumberNode *totalScoreNode;

@property (nonatomic, assign) CGPoint startTouchPoint;
@property (nonatomic, strong) NSDate* startTouchTime;
@property (nonatomic, assign) BOOL isGameOver;
@end

@implementation GameScene {

}



- (void)didMoveToView:(SKView *)view {
    // Setup your scene here
    [self addChildNodes];
}

- (void)addChildNodes {
    [self createBackgroundNodes];
    [self addChild:self.backgroundNodeA];
    [self addChild:self.backgroundNodeB];
    
    self.treesList = [[TreesList alloc] init];
 
    Tree *firstTree = [self.treesList generateSingleTreeWithPosition:CGPointMake(MONKEY_MIN_X, TREE_POSITION_Y)];
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
    [self addChild:self.hawk];
    
    [self addChild:self.totalScoreNode];
    [self addChild:[SoundManager sharedManger]];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.hawk.hidden = NO;
        [self.hawk startMoveWithLocation:CGPointMake(self.monkey.offsetX + SCREEN_W/3 - self.hawk.size.width/2, -self.hawk.size.height/2)];
    });
}

- (void)removeChildNodes {
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
    if (!self.isGameOver && self.monkey.state == MonkeyStateSwing){
        NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:self.startTouchTime];
        CGFloat offsetX = pos.x - self.startTouchPoint.x;
        CGFloat offsetY = (pos.y - self.startTouchPoint.y);
        
        CGFloat vx = offsetX / interval;
        CGFloat vy = offsetY/ interval;
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
    if (!self.isGameOver) {
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
}

#pragma mark - MonkeyDelegate
- (void)monkeyDidMoveTo:(CGPoint)position {
    
    if (position.y< 0) {//跳出屏幕，游戏结束
        [self gameDidEnd];
    }
}

- (void)monkeyDidJumpToHookNode:(HookNode *)node {
    
    HookNode *oldNode = [self.treesList.nodes firstObject];
    if (oldNode.position.x < - oldNode.size.width ) {
        [self.treesList removeNode:oldNode];
        [oldNode removeFromParent];
    }
    
    HookNodeType type = arc4random_uniform(HookNodeTypeCount);
    HookNode* newNode = [self.treesList generateSingleNodeWithType:type distance:kDefaultTreeDistanceX];
    NSInteger fgIndex = [self.children indexOfObject:self.foregroundNodes.firstObject];
    [self insertChild:newNode atIndex:fgIndex-1];
    if ([newNode isKindOfClass:[Spider class]]) {
        NormalNode *line = ((Spider*)newNode).line;
        [self insertChild:line atIndex:fgIndex-1];
    }
    
    [self showScoreLabel];
    [self.totalScoreNode setNumber:self.monkey.mScore.score];
    
    if (self.gameDelegate && [self.gameDelegate respondsToSelector:@selector(scoreDidUpdate:)]) {
        [self.gameDelegate scoreDidUpdate:self.monkey.mScore.score];
    }
    
    if (self.gameDelegate && [self.gameDelegate respondsToSelector:@selector(monkeyDidJumpToHookNode:)]) {
        [self.gameDelegate monkeyDidJumpToHookNode:node];
    }
    

}

- (void)monkeyDidJumpFromHookNode:(HookNode *)node {
    if (self.gameDelegate && [self.gameDelegate respondsToSelector:@selector(monkeyDidJumpFromHookNode:)]) {
        [self.gameDelegate monkeyDidJumpFromHookNode:node];
    }
}

#pragma mark - Private
- (void)showScoreLabel {
    if (self.monkey.mScore.lastAccScore>0) {
        SKAction *moveAction = [SKAction moveTo:CGPointMake(self.size.width, self.size.height) duration:3];
        SKAction *scaleAction = [SKAction scaleTo:0 duration:3];
        SKAction *removeAction = [SKAction removeFromParent];
//        SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithText:[NSString stringWithFormat:@"+%ld",(long)self.monkey.mScore.lastAccScore]];
//        scoreLabel.fontSize = 30;
//        scoreLabel.fontColor = [SKColor colorWithRed:1 green:0 blue:0 alpha:1];
        SKNumberNode *scoreNode = [[SKNumberNode alloc] initWithImageNamed:@"number_2_frame_list" charSequence:@"0123456789+-"];
        scoreNode.showPlusSign = YES;
        [scoreNode setNumber:self.monkey.mScore.lastAccScore];
        scoreNode.position = [self.monkey.hookNode getRealHook];
        SKAction *actionGroup =[SKAction group:@[moveAction, scaleAction]];
        [scoreNode runAction:[SKAction sequence:@[actionGroup, removeAction]]];

        [self addChild:scoreNode];
    }

}

- (void)gameDidEnd {
    if (!self.isGameOver) {
        [self.monkey removeFromParent];
        [self.monkey.mScore clearScore];
        [[SoundManager sharedManger] playGameOverSound];
//        self.paused = YES;
        self.isGameOver = YES;
        
        if (self.gameDelegate && [self.gameDelegate respondsToSelector:@selector(gameDidEnd)]) {
            [self.gameDelegate gameDidEnd];
        }
    }
}

- (void)gameRestart {
    //删除子节点
    [self removeChildNodes];
    
    //重新添加子节点
    [self addChildNodes];
//    self.paused = NO;
    self.isGameOver = NO;
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
    lastX += newNode.size.width;
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

@end
