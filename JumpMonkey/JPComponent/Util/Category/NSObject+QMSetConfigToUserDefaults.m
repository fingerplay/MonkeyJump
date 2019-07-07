//
//  NSObject+QMSetConfigToUserDefaults.m
//  juanpi3
//
//  Created by Liu on 15/8/13.
//  Copyright (c) 2015年 Liu. All rights reserved.
//

#import "NSObject+QMSetConfigToUserDefaults.h"

@implementation NSObject (QMSetConfigToUserDefaults)

+ (NSString *)qm_defaultKey
{
    return [NSString stringWithFormat:@"%@_Config_Default_Key", NSStringFromClass([self class])];
}

+ (BOOL)setConfigDictionary:(NSDictionary *)configDic forKey:(NSString *)key
{
    if (configDic && key && [configDic isKindOfClass:[NSDictionary class]]) {
        [[NSUserDefaults standardUserDefaults] setObject:configDic forKey:key];
        return YES;
    }
    return NO;
}

+ (BOOL)setConfigDictionary:(NSDictionary *)configDic
{
    return [self setConfigDictionary:configDic forKey:[self qm_defaultKey]];
}

+ (BOOL)setConfigString:(NSString *)config forKey:(NSString *)key
{
    if (config && key && [config isKindOfClass:[NSString class]]) {
        [[NSUserDefaults standardUserDefaults] setObject:config forKey:key];
        return YES;
    }
    return NO;
}

+ (BOOL)setConfigString:(NSString *)config
{
    return [self setConfigString:config forKey:[self qm_defaultKey]];
}

+ (NSDictionary *)configDictionaryForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (NSDictionary *)configDictionary
{
    return [self configDictionaryForKey:[self qm_defaultKey]];
}

+ (NSString *)configStringForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (NSString *)configString
{
    return [self configStringForKey:[self qm_defaultKey]];
}

@end
