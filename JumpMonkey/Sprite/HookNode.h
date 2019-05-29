//
//  HoodNode.h
//  JumpMonkey
//
//  Created by 罗谨 on 2019/5/10.
//  Copyright © 2019 finger. All rights reserved.
//


#import <SpriteKit/SpriteKit.h>
#import "NormalNode.h"

typedef NS_ENUM(NSUInteger){
    HookNodeTypeStable = 0,
    HookNodeTypeClimb,
    HookNodeTypeCount,
} HookNodeType;

@interface HookNode : NormalNode

@property (nonatomic, assign) CGFloat initX;

@property (nonatomic, assign) HookNodeType type;
@property (nonatomic, strong) HookNode *nextNode;
@property (nonatomic, strong) HookNode *preNode;
@property (nonatomic, assign) CGPoint hookPoint;
@property (nonatomic ,assign) NSInteger number; //第几个挂点
@property (nonatomic, assign) BOOL isHooked; //是否被挂住
@property (nonatomic, assign) BOOL isHookTarget; //是否是猴子跳跃过程中即将挂到的点

- (instancetype)initWithImageNamed:(NSString*)imageName position:(CGPoint)position;

- (CGPoint)getRealHook;

- (void)onCatchHook;

- (void)onUncatchHook;

@end


