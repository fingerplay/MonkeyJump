//
//  NSObject+Safe.h
//  juanpi3
//
//  Created by Jay on 14-12-23.
//  Copyright (c) 2014年 Jay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Safe)

/**
 *  Key-Value 安全取值
 *
 *  @param key key
 *
 *  @return value
 */
- (id)qm_safeValueForKey:(NSString *)key;

/**
 *  Key-Value 安全赋值
 *
 *  @param value value
 *  @param key   key
 */
- (void)qm_safeSetValue:(id)value forKey:(NSString *)key;

@end
