//
//  HookNodeGenarator.m
//  JumpMonkey
//
//  Created by 罗谨 on 2019/5/16.
//  Copyright © 2019 finger. All rights reserved.
//

#import "TreesList.h"
#import "CommonDefine.h"

@interface TreesList ()

@end

@implementation TreesList


- (NSArray *)generateTreesWithDistanceX:(CGFloat)distance count:(NSInteger)count {
    NSMutableArray *newTrees = [[NSMutableArray alloc] init];
    Tree *lastTree = self.nodes.lastObject;
  
    for (NSUInteger i=0; i<count; i++) {
        
        CGPoint location = CGPointMake(lastTree.position.x + distance, TREE_POSITION_Y);
        Tree *tree = [self generateSingleTreeWithPosition:location];
        [newTrees addObject:tree];
        if (lastTree) {
            lastTree.nextNode = tree;
            tree.preNode = lastTree;
        }

        lastTree = tree;
    }

    return [newTrees copy];
}

- (Tree*)generateSingleTreeWithPosition:(CGPoint)position {
    Tree *tree = [[Tree alloc] initWithImageNamed:@"tree" position:position];
    [self addNodeToTail:tree];
    return tree;
}

- (Tree*)generateSingleTreeWithDistance:(CGFloat)distance {
    Tree *lastTree = self.nodes.lastObject;
    Tree *tree = [[Tree alloc] initWithImageNamed:@"tree" position:CGPointMake(lastTree.initX + distance, lastTree.position.y)];
    tree.position = CGPointMake(lastTree.position.x + distance, lastTree.position.y);
    [self addNodeToTail:tree];
    return tree;
}


@end
