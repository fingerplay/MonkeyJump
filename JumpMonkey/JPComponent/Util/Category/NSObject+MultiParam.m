//
//  NSObject+MultiParam.m
//  juanpi3
//
//  Created by 彭军 on 16/6/22.
//  Copyright © 2016年 彭军. All rights reserved.
//

#import "NSObject+MultiParam.h"

@implementation NSObject (MultiParam)

- (void)performSelector:(SEL)aSelector onThread:(NSThread *)thr waitUntilDone:(BOOL)wait withObjects:(id)object1, ... {
    NSMethodSignature *signature = [self methodSignatureForSelector:aSelector];
    if (!signature) {
        return;
    }
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:self];
    [invocation setSelector:aSelector];
    [invocation setArgument:&object1 atIndex:2];
    NSInteger numberOfParam = [signature numberOfArguments];
    va_list params;
    va_start(params, object1);
    for (NSInteger i = 3; i < numberOfParam; i ++) {
        id parameter = va_arg(params, id);
        [invocation setArgument:&parameter atIndex:i];
    }
    va_end(params);
    [invocation performSelector:@selector(invoke) onThread:thr withObject:nil waitUntilDone:wait];
}

- (void)performSelector:(SEL)aSelector onThread:(NSThread *)thr withObjects:(NSArray *)objects waitUntilDone:(BOOL)wait {
    NSMethodSignature *signature = [self methodSignatureForSelector:aSelector];
    if (!signature) {
        return;
    }
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:self];
    [invocation setSelector:aSelector];
    NSInteger index = 2;
    for (id __unsafe_unretained parameter in objects) {
        [invocation setArgument:&parameter atIndex:index ++];
    }
    [invocation performSelector:@selector(invoke) onThread:thr withObject:nil waitUntilDone:wait];
}

@end
