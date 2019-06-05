//
//  ChainList.m
//  JumpMonkey
//
//  Created by 罗谨 on 2019/5/22.
//  Copyright © 2019 finger. All rights reserved.
//

#import "ChainList.h"
#import "Tree.h"
#import "Spider.h"

@implementation ChainList

- (instancetype)init {
    self = [super init];
    if (self) {
        _nodes = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSArray *)generateNodesWithDistanceX:(CGFloat)distance count:(NSInteger)count {
    NSMutableArray *newNodes = [[NSMutableArray alloc] init];
    HookNode *lastNode = self.nodes.lastObject;
    
    for (NSUInteger i=0; i<count; i++) {
        HookNodeType type = arc4random_uniform(HookNodeTypeCount);
        CGPoint location = CGPointMake([lastNode getRealHook].x + distance, TREE_POSITION_Y);
        HookNode *node = [self generateSingleNodeWithType:type position:location];
//        node.number = self.nodes.count + i;
        [newNodes addObject:node];
        if (lastNode) {
            lastNode.nextNode = node;
            node.preNode = lastNode;
        }
        
        lastNode = node;
    }
    
    return [newNodes copy];
}

- (HookNode*)generateSingleNodeWithType:(HookNodeType)type position:(CGPoint)position {
    HookNode *node;
    if (type == HookNodeTypeMove) {
        node = [[Spider alloc] initWithImageNamed:@"spider" position:position];
    }else {
        NSArray *treeNames = @[@"tree",@"tree2",@"tree3"];
        uint32_t index = arc4random_uniform((uint32_t)treeNames.count);
        NSString *treeName = treeNames[index];
        node = [[Tree alloc] initWithImageNamed:treeName position:position];
    }
    HookNode *lastNode = self.nodes.lastObject;
    node.number = lastNode.number + 1;
    node.name = [NSString stringWithFormat:@"%@_%ld", (type == HookNodeTypeMove) ? @"spider" : @"tree",(long)node.number];
    
    if (node) {
        [self addNodeToTail:node];
    }

    return node;
}

- (HookNode*)generateSingleNodeWithType:(HookNodeType)type distance:(CGFloat)distance {
    HookNode *lastNode = self.nodes.lastObject;
    HookNode *node = [self generateSingleNodeWithType:type position:CGPointMake(lastNode.initX + distance, TREE_POSITION_Y)];
    node.position = CGPointMake(lastNode.position.x + distance, TREE_POSITION_Y);
    return node;
}


- (void)removeNode:(HookNode*)node {
    HookNode *preNode = node.preNode;
    HookNode *nextNode = node.nextNode;
    preNode.nextNode = nextNode;
    nextNode.preNode = preNode;
    [self.nodes removeObject:node];
}

- (void)removeNodesFromHeadWithCount:(NSInteger)count {
    for (NSUInteger i=count-1; i>=0; i++) {
        HookNode *node = [self.nodes objectAtIndex:i];
        node.nextNode.preNode = nil;
        node.preNode.nextNode = nil;
        [self.nodes removeObject:node];
    }
}

- (void)addNodeToTail:(HookNode*)node {
    HookNode *lastNode = [self.nodes lastObject];
    node.preNode = lastNode;
    lastNode.nextNode = node;
    [self.nodes addObject:node];
}


@end
