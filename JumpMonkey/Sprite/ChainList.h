//
//  ChainList.h
//  JumpMonkey
//
//  Created by 罗谨 on 2019/5/22.
//  Copyright © 2019 finger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HookNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChainList : NSObject

@property (nonatomic, strong) NSMutableArray *nodes;

- (NSArray *)generateNodesWithDistanceX:(CGFloat)distance count:(NSInteger)count;

- (HookNode*)generateSingleNodeWithType:(HookNodeType)type distance:(CGFloat)distance;

- (HookNode*)generateSingleNodeWithType:(HookNodeType)type position:(CGPoint)position;

- (void)removeNode:(HookNode*)node;

- (void)removeNodesFromHeadWithCount:(NSInteger)count;

- (void)addNodeToTail:(HookNode*)node;

@end

NS_ASSUME_NONNULL_END
