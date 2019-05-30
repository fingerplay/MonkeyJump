//
//  PhysicsUtil.m
//  JumpMonkey
//
//  Created by 罗谨 on 2019/5/19.
//  Copyright © 2019年 finger. All rights reserved.
//

#import "PhysicsUtil.h"
#import "CommonDefine.h"

@implementation PhysicsUtil

+ (BOOL)isPoint:(CGPoint)point inRadiusRegion:(CGFloat)radius withCenter:(CGPoint)center velocity:(CGPoint)v {
    CGFloat vv = sqrtf(v.x * v.x + v.y * v.y);
    
    CGFloat distance = sqrtf(powf(point.x - center.x, 2) + powf(point.y - center.y, 2));
    if ((radius/2 - distance >= -vv/2) && (radius/2 - distance <= vv/2)
//        //&& ABS(vRate - dRate) <= 1
        ){
        return YES;
    }
    return NO;
}

@end
