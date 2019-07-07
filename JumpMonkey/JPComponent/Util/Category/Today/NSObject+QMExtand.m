//
//  NSObject+QMExtand.m
//  juanpi3
//
//  Created by Jay on 15-4-30.
//  Copyright (c) 2015年 Jay. All rights reserved.
//

#import "NSObject+QMExtand.h"
#import <objc/runtime.h>
#import "BBSafeEX.h"
//#import "NSObject+Safe.h"
//#import "QMRequester.h"

@implementation NSObject (QMExtand)



+ (NSDictionary *)extGetPropertys
{
    NSMutableArray *names = [NSMutableArray array];
    NSMutableArray *types = [NSMutableArray array];
    NSDictionary *props = [NSDictionary dictionaryWithObjectsAndKeys:names, @"names", types, @"types", nil];
    [self extGetSelfPropertys:names types:types isGetSuper:NO superClass:[NSObject class]];
    return props;
}

+ (NSDictionary *)extGetPropertysWithSuper:(Class)superClass
{
    NSMutableArray *names = [NSMutableArray array];
    NSMutableArray *types = [NSMutableArray array];
    NSDictionary *props = [NSDictionary dictionaryWithObjectsAndKeys:names, @"names", types, @"types", nil];
    [self extGetSelfPropertys:names types:types isGetSuper:YES superClass:superClass];
    return props;
}


+ (void)extGetSelfPropertys:(NSMutableArray *)names types:(NSMutableArray *)types isGetSuper:(BOOL)isGetSuper superClass:(Class)superClass
{
    unsigned int outCount = 0;
    
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (int i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *name = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        NSString *type = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
        
        /** 如果有Class遵守了协议,系统就会把以下方法认为是属性,故排除 */
        if([name isEqualToString:@"hash"]||
           [name isEqualToString:@"superclass"]||
           [name isEqualToString:@"description"]||
           [name isEqualToString:@"debugDescription"]) {
            continue;
        }

        [names safeAddObject:name];
        [types safeAddObject:type];
        
    }
    free(properties);
    
    if (isGetSuper && ([self superclass] != superClass)) {
        [[self superclass] extGetSelfPropertys:names types:types isGetSuper:isGetSuper superClass:superClass];
    }
}

- (NSString *)extGetPropertyNameAndKey
{
    
    //获得所有属性名字
    NSDictionary *properties = [[self class] extGetPropertysWithSuper:[NSObject class]];
    
    //排序
    NSArray *names = [properties[@"names"] sortedArrayUsingSelector:@selector(compare:)];
    
    NSMutableArray *keyValueArr = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (NSString *key in names) {
        if (!key) {
            continue;
        }
        if ([self valueForKey:key]) {
            [keyValueArr safeAddObject:[NSString stringWithFormat:@"%@=%@",key,[self qm_safeValueForKey:key]]];
        }
    }
    
    NSString *namesAndKeys = [keyValueArr componentsJoinedByString:@"&"];
    
    return namesAndKeys;
}

- (BOOL)isEqualStringPropertyToObject:(id)object {
    return [self isEqualStringPropertyToObject:object ignoredKey:nil];
}


- (BOOL)isEqualStringPropertyToObject:(id)object ignoredKey:(NSString *)ignoredKey {
    
    if (![self isKindOfClass:[object class]]) {
        return NO;
    }
    
    //获得所有属性名字
    NSDictionary *properties = [[self class] extGetPropertys];
    NSArray *names = properties[@"name"];
    
    for (NSString *key in names) {
        if (![key isKindOfClass:[NSString class]]) {
            return NO;
        }
        
        if (ignoredKey && [key isEqualToString:ignoredKey]) {
            continue ;
        }
        
        NSString *selfString = [self valueForKey:key];
        NSString *objString = [object valueForKey:key];
        
        if ([selfString isKindOfClass:[NSString class]] &&
            [objString isKindOfClass:[NSString class]]) {
            if (![selfString isEqualToString:objString]) {
                return NO;
            }
        }
        else {
            return NO;
        }
    }
    return YES;
}

@end

//@implementation NSObject(FreeRequestDelegate)
//
//- (void)freeRequestDelegates
//{
//    // 释放request代理
//    unsigned int numIvars; //成员变量个数
//    Ivar *vars = class_copyIvarList([self class], &numIvars);
//    for(int i = 0; i < numIvars; i++) {
//        Ivar thisIvar = vars[i];
//        NSString *belongClass = [NSString stringWithUTF8String:ivar_getTypeEncoding(thisIvar)]; //获取成员变量的数据类型
//        if (belongClass.length > 3) {
//            belongClass = [belongClass substringWithRange:NSMakeRange(2, belongClass.length-3)];
//        }
//        Class cls = NSClassFromString(belongClass);
//        if ([cls isSubclassOfClass:[QMRequester class]]) {
//            QMRequester *req = object_getIvar(self, thisIvar);
//            req.delegate = nil;
//            req = nil;
//        }
//    }
//    free(vars);
//}

//@end
