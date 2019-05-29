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

@interface GameScene ()<MonkeyDelegate>
@property (nonatomic, strong) NormalNode *backgroundNodeA;
@property (nonatomic, strong) NormalNode *backgroundNodeB;
@property (nonatomic, strong) Monkey *monkey;
@property (nonatomic, strong) TreesList *treesList;
@property (nonatomic, strong) NormalNode *foregroundNodeA;
@property (nonatomic, strong) NormalNode *foregroundNodeB;

@property (nonatomic, assign) CGPoint startTouchPoint;
@property (nonatomic, strong) NSDate* startTouchTime;
@property (nonatomic, assign) BOOL isGameOver;
@end

@implementation GameScene {

}

#define kDefaultTreeDistanceX  (self.view.bounds.size.width /2.5)

- (void)didMoveToView:(SKView *)view {
    // Setup your scene here
    [self addChildNodes];
    
}

- (void)addChildNodes {
    [self addChild:self.backgroundNodeA];
    [self addChild:self.backgroundNodeB];
    
    
    self.treesList = [[TreesList alloc] init];
 
    Tree *firstTree = [self.treesList generateSingleTreeWithPosition:CGPointMake(MONKEY_MIN_X, TREE_POSITION_Y)];
    [self addChild:firstTree];
    NSArray *nodes = [self.treesList generateNodesWithDistanceX:kDefaultTreeDistanceX count:5];
    for (NSUInteger i=0; i<nodes.count; i++) {
        Tree *node = [nodes objectAtIndex:i];
        [self addChild:node];
    }
    
    self.monkey = [[Monkey alloc] initWithImageNamed:@"monkey_swing" hookNode:firstTree];
    self.monkey.delegate = self;

    [firstTree addChild:self.monkey];
    
    [self addChild:self.foregroundNodeA];
    [self addChild:self.foregroundNodeB];
    
}

- (void)removeChildNodes {
    [self removeAllChildren];
    [self.treesList.nodes removeAllObjects];
    self.monkey = nil;
    self.backgroundNodeA = nil;
    self.backgroundNodeB = nil;
    self.foregroundNodeA = nil;
    self.foregroundNodeB = nil;
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
    if (!self.isGameOver){
        NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:self.startTouchTime];
        CGFloat offsetX = pos.x - self.startTouchPoint.x;
        CGFloat offsetY = (pos.y - self.startTouchPoint.y);
        
        CGFloat vx = offsetX / interval;
        CGFloat vy = offsetY/ interval;
        [self.monkey jumpWithVx:vx vy:vy/50];
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
    if (!self.view.isPaused) {
        [self moveAllNodes];
    }
}

- (void)moveAllNodes {
    [self.monkey move];
    for (HookNode *node in self.treesList.nodes) {
        [node moveWithSceneVelocity:self.monkey.sceneMoveVelocity];
    }
    
    [self.foregroundNodeA moveWithSceneVelocity:self.monkey.sceneMoveVelocity];
    [self.foregroundNodeB moveWithSceneVelocity:self.monkey.sceneMoveVelocity];
    
    [self.backgroundNodeA moveWithSceneVelocity:self.monkey.sceneMoveVelocity/BACKGROUND_MOVE_RATE];
    [self. backgroundNodeB moveWithSceneVelocity:self.monkey.sceneMoveVelocity/BACKGROUND_MOVE_RATE];
   
}

#pragma mark - MonkeyDelegate
- (void)monkeyDidMoveTo:(CGPoint)position {
    
    if (position.y< 0) {//跳出屏幕，游戏结束
        [self gameDidEnd];
    }
    
    [self switchBackgroundPosition];
    [self switchForegroundPosition];
}

- (void)monkeyDidJumpToHookNode:(HookNode *)node {
    
    HookNode *oldNode = [self.treesList.nodes firstObject];
    if (oldNode.position.x < - oldNode.size.width ) {
        [self.treesList removeNode:oldNode];
        [oldNode removeFromParent];
    }
    
    HookNodeType type = arc4random_uniform(HookNodeTypeCount);
    HookNode* newNode = [self.treesList generateSingleNodeWithType:type distance:kDefaultTreeDistanceX];
    NSInteger fgIndex = [self.children indexOfObject:self.foregroundNodeA];
    [self insertChild:newNode atIndex:fgIndex-1];
}

#pragma mark - Logic
- (void)gameDidEnd {
    [self.monkey removeFromParent];
    self.paused = YES;
    self.isGameOver = YES;
    
    if (self.gameDelegate && [self.gameDelegate respondsToSelector:@selector(gameDidEnd)]) {
        [self.gameDelegate gameDidEnd];
    }
}

- (void)gameRestart {
    //删除子节点
    [self removeChildNodes];
    
    //重新添加子节点
    [self addChildNodes];
    self.paused = NO;
    self.isGameOver = NO;
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
    if (self.foregroundNodeA.position.x <= -(self.foregroundNodeA.size.width + self.foregroundNodeB.size.width - self.size.width)) {
        NormalNode *temp = [self.foregroundNodeB copy];
        temp.position = CGPointMake(temp.position.x+ temp.size.width, temp.position.y);
        [self.foregroundNodeA removeFromParent];
        self.foregroundNodeA = self.foregroundNodeB;
        self.foregroundNodeB = temp;
        [self addChild:self.foregroundNodeB];
    }
}

#pragma mark - Property


- (NormalNode *)backgroundNodeA {
    if (!_backgroundNodeA) {
        _backgroundNodeA = [[NormalNode alloc] initWithImageNamed:@"ch1"];
        _backgroundNodeA.anchorPoint = CGPointMake(0, 0);
        _backgroundNodeA.position = CGPointMake(0, 0);
        _backgroundNodeA.size = CGSizeMake(self.size.width, self.size.height);
    }
    return _backgroundNodeA;
}


- (NormalNode *)backgroundNodeB {
    if (!_backgroundNodeB) {
        _backgroundNodeB = [[NormalNode alloc] initWithImageNamed:@"ch1"];
        _backgroundNodeB.anchorPoint = CGPointMake(0, 0);
        _backgroundNodeB.position = CGPointMake(self.size.width, 0);
        _backgroundNodeB.size = CGSizeMake(self.size.width, self.size.height);
    }
    return _backgroundNodeB;
}

- (NormalNode *)foregroundNodeA {
    if (!_foregroundNodeA) {
        _foregroundNodeA = [[NormalNode alloc] initWithImageNamed:@"fg1"];
        _foregroundNodeA.anchorPoint = CGPointMake(0, 0);
        _foregroundNodeA.position = CGPointMake(0, 0);
        _foregroundNodeA.size = CGSizeMake(self.size.width, self.size.width/1114* 250);
    }
    return _foregroundNodeA;
}

- (NormalNode *)foregroundNodeB {
    if (!_foregroundNodeB) {
        _foregroundNodeB = [[NormalNode alloc] initWithImageNamed:@"fg1"];
        _foregroundNodeB.anchorPoint = CGPointMake(0, 0);
        _foregroundNodeB.position = CGPointMake(self.size.width, 0);
        _foregroundNodeB.size = CGSizeMake(self.size.width, self.size.width/1114* 250);
    }
    return _foregroundNodeB;
}

@end
