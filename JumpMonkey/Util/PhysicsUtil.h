//
//  PhysicsUtil.h
//  JumpMonkey
//
//  Created by 罗谨 on 2019/5/19.
//  Copyright © 2019年 finger. All rights reserved.
//


#import <SpriteKit/SpriteKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface PhysicsUtil : NSObject

+ (BOOL)isPoint:(CGPoint)point inRadiusRegion:(CGFloat)radius withCenter:(CGPoint)center velocity:(CGPoint)v;

@end

NS_ASSUME_NONNULL_END
