//
//  NSNumber+safe.m
//  Juanpi
//
//  Created by huang jiming on 14-1-8.
//  Copyright (c) 2014年 Juanpi. All rights reserved.
//

#import "NSNumber+safe.h"

@implementation NSNumber (safe)

- (BOOL)safeIsEqualToNumber:(NSNumber *)number
{
    if (number == nil) {
        return NO;
    } else {
        return [self isEqualToNumber:number];
    }
}

- (NSComparisonResult)safeCompare:(NSNumber *)otherNumber
{
    if (otherNumber == nil) {
        return NSOrderedDescending;
    } else {
        return [self compare:otherNumber];
    }
}
// 服务端传number，我们用NSString接收，造成unrecognized，添加备用消息接受者,防止Crash
- (id)forwardingTargetForSelector:(SEL)aSelector
{
    return [self stringValue];
}

@end
