//
//  NSMutableDictionary+safe.m
//  Juanpi
//
//  Created by airspuer on 13-5-8.
//  Copyright (c) 2013年 Juanpi. All rights reserved.
//

#import "NSMutableDictionary+safe.h"
#import "NSObject+swizzle.h"
#import "QMFoundationDataForwardTarget.h"

@implementation NSMutableDictionary(safe)

+ (void)load
{
    [self exchangeMethod:@selector(setObject:forKeyedSubscript:) withMethod:@selector(safeSetObject:forKeyedSubscript:)];
}

+ (instancetype)safeWithDictionary:(NSDictionary *)dic {
    if (!dic) {
        return nil;
    }
    return [self dictionaryWithDictionary:dic];
}

+ (instancetype)safeDictionaryWithDictionary:(NSDictionary *)dic {
    if ([dic isKindOfClass:[NSDictionary class]]) {
        return [NSMutableDictionary dictionaryWithDictionary:dic];
    }
    return [NSMutableDictionary dictionary];
}

- (void)safeSetObject:(id)obj forKeyedSubscript:(id<NSCopying>)key
{
    if (!key) {
        return ;
    }

    if (!obj || [obj isKindOfClass:[NSNull class]]) {
        return ;
    }

    [self safeSetObject:obj forKeyedSubscript:key];
}

- (void)safeSetObject:(id)aObj forKey:(id<NSCopying>)aKey
{
    if (aObj && ![aObj isKindOfClass:[NSNull class]] && aKey) {
        [self setObject:aObj forKey:aKey];
    } else {
        return;
    }
}

- (id)safeObjectForKey:(id<NSCopying>)aKey
{
    if (aKey != nil) {
        return [self objectForKey:aKey];
    } else {
        return nil;
    }
}

- (void)safeRemoveObjectForKey:(id<NSCopying>)aKey {
    if (aKey) {
        return [self removeObjectForKey:aKey];
    }
}

- (void)safeAddEntriesFromDictionary:(NSDictionary *)otherDictionary {
    if ([self isKindOfClass:[NSMutableDictionary class]] &&
        [otherDictionary isKindOfClass:[NSDictionary class]]) {
        [self addEntriesFromDictionary:otherDictionary];
    }
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return [[QMFoundationDataForwardTarget alloc] init];
}

@end
