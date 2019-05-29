//
//  HookNodeGenarator.h
//  JumpMonkey
//
//  Created by 罗谨 on 2019/5/16.
//  Copyright © 2019 finger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tree.h"
#import "ChainList.h"
NS_ASSUME_NONNULL_BEGIN

@interface TreesList : ChainList

- (NSArray *)generateTreesWithDistanceX:(CGFloat)distance count:(NSInteger)count;

- (Tree*)generateSingleTreeWithDistance:(CGFloat)distance;

- (Tree*)generateSingleTreeWithPosition:(CGPoint)position;

@end

NS_ASSUME_NONNULL_END
