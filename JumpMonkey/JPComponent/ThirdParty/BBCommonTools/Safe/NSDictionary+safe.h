//
//  NSDictionary+safe.h
//  Juanpi
//
//  Created by huang jiming on 14-1-8.
//  Copyright (c) 2014年 Juanpi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (safe)

+ (id)safeDictionaryWithObject:(id)object forKey:(id <NSCopying>)key;

/** 安全返回id */
- (id)safeObjectForKey:(id)key;

/** 安全返回NSString */
- (NSString *)safeStringForKey:(id)key;

/** 安全返回NSArray */
- (NSArray *)safeArrayForKey:(id)key;

/** 安全返回NSDictionary */
- (NSDictionary *)safeDictionaryForKey:(id)key;

- (NSMutableDictionary *)mutableDeepCopy;

@end
