//
//  NSDictionary+safe.m
//  Juanpi
//
//  Created by huang jiming on 14-1-8.
//  Copyright (c) 2014年 Juanpi. All rights reserved.
//

#import "NSDictionary+safe.h"
#import "NSObject+swizzle.h"
#import <objc/runtime.h>
#import "QMFoundationDataForwardTarget.h"

@implementation NSDictionary (safe)

+ (void)load
{
    [objc_getClass("__NSPlaceholderDictionary") exchangeMethod:@selector(initWithObjects:forKeys:count:) withMethod:@selector(safeInitWithObjects:forKeys:count:)];
}

- (instancetype)safeInitWithObjects:(id  _Nonnull const [])objects forKeys:(id<NSCopying>  _Nonnull const [])keys count:(NSUInteger)cnt
{
    BOOL hasNilObject = NO;
    BOOL hasNilKey = NO;
    for (NSUInteger i = 0; i < cnt; i++) {
        if (objects[i] == nil) {
            hasNilObject = YES;
#if DEBUG
            NSCAssert(objects[i] != nil, @"字典value不能为nil");
#endif
        }
        
        if (keys[i] == nil) {
            hasNilKey = YES;
#if DEBUG
            NSCAssert(keys[i] != nil, @"字典key不能为nil");
#endif
        }
    }
    
    // 过滤掉key或value为nil的元素
    if (hasNilObject || hasNilKey) {
        id __unsafe_unretained newObjects[cnt];
        id __unsafe_unretained newKeys[cnt];
        NSUInteger index = 0;
        for (NSUInteger i = 0; i < cnt; ++i) {
            if (objects[i] != nil && keys[i] != nil) {
                newObjects[index] = objects[i];
                newKeys[index] = keys[i];
                index++;
            }
        }
        return [self safeInitWithObjects:newObjects forKeys:newKeys count:index];
    }
    return [self safeInitWithObjects:objects forKeys:keys count:cnt];
}

+ (id)safeDictionaryWithObject:(id)object forKey:(id <NSCopying>)key
{
    if (object==nil || key==nil) {
        return [self dictionary];
    } else {
        return [self dictionaryWithObject:object forKey:key];
    }
}

- (id)safeObjectForKey:(id)key {
    if (!key || ![self isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    id obj = [self objectForKey:key];
    return obj;
}

- (NSString *)safeStringForKey:(id)key {
    
    if (!key || ![self isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    NSString *string = [self objectForKey:key];
    if ([string isKindOfClass:[NSNumber class]]) {
        string = [NSString stringWithFormat:@"%@",string];
    }
    
    if (![string isKindOfClass:[NSString class]]) {
        string = nil;
    }
    return string;
}


- (NSArray *)safeArrayForKey:(id)key {
    if (!key || ![self isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    NSArray *array = [self objectForKey:key];
    if (![array isKindOfClass:[NSArray class]]) {
        array = nil;
    }
    return array;
}

- (NSDictionary *)safeDictionaryForKey:(id)key {
    if (!key|| ![self isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    NSDictionary *dictionary = [self objectForKey:key];
    if (![dictionary isKindOfClass:[NSDictionary class]]) {
        dictionary = nil;
    }
    return dictionary;
}

- (NSMutableDictionary *)mutableDeepCopy {
    NSMutableDictionary * returnDict = [[NSMutableDictionary alloc] initWithCapacity:self.count];
    NSArray * keys = [self allKeys];
    
    for(id key in keys) {
        id oneValue = [self objectForKey:key];
        id oneCopy = nil;
        
        if([oneValue respondsToSelector:@selector(mutableDeepCopy)]) {
            oneCopy = [oneValue mutableDeepCopy];
        } else if([oneValue conformsToProtocol:@protocol(NSMutableCopying)]) {
            oneCopy = [oneValue mutableCopy];
        } else if([oneValue conformsToProtocol:@protocol(NSCopying)]){
            oneCopy = [oneValue copy];
        } else {
            oneCopy = oneValue;
        }
        [returnDict setValue:oneCopy forKey:key];
    }
    return returnDict;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return [[QMFoundationDataForwardTarget alloc] init];
}

@end
