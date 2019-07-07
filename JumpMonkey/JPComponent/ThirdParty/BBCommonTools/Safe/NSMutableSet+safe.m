//
//  NSMutableSet+safe.m
//  JPComponentDemo
//
//  Created by 彭军 on 2017/9/6.
//  Copyright © 2017年 卷皮网. All rights reserved.
//

#import "NSMutableSet+safe.h"
#import "NSObject+swizzle.h"
@implementation NSMutableSet (safe)

+ (void)load
{
    [NSClassFromString(@"__NSSetM") exchangeMethod:@selector(addObject:) withMethod:@selector(safeAddObject:)];
}

- (void)safeAddObject:(id)object
{
    if (object == nil || [object isKindOfClass:[NSNull class]]) {
        return;
    } else {
        [self safeAddObject:object];
    }
}

@end
