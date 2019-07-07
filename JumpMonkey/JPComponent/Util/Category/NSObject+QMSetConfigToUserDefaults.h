//
//  NSObject+QMSetConfigToUserDefaults.h
//  juanpi3
//
//  Created by Liu on 15/8/13.
//  Copyright (c) 2015年 Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (QMSetConfigToUserDefaults)

/**
 *  设置配置信息，主要是后台控制的配置信息，开关、链接、图片URL等，主要通过userDefaults存储，需要手动进行synchronize同步
 *
 *  @param configDic 字典
 *  @param key       存储字典的key
 *
 *  @return 成功 YES；失败，NO
 */
+ (BOOL)setConfigDictionary:(NSDictionary *)configDic forKey:(NSString *)key;

/**
 *  设置配置信息，主要是后台控制的配置信息，开关、链接、图片URL等
 *  存储的key是［self class］的类名
 *  @param configDic 字典
 *
 *  @return 成功 YES；失败，NO
 */
+ (BOOL)setConfigDictionary:(NSDictionary *)configDic;

/**
 *  设置配置信息，主要是后台控制的配置信息，
 *
 *  @param config string
 *  @param key  存储字典的key
 *
 *  @return 成功 YES；失败，NO
 */
+ (BOOL)setConfigString:(NSString *)config forKey:(NSString *)key;

/**
 *  设置配置信息，主要是后台控制的配置信息，
 *  存储的key是［self class］的类名
 *  @param config string
 *
 *  @return 成功 YES；失败，NO
 */
+ (BOOL)setConfigString:(NSString *)config;

//通过key获取配置字典
+ (NSDictionary *)configDictionaryForKey:(NSString *)key;

//通过key获取配置string
+ (NSString *)configStringForKey:(NSString *)key;

//通过类名作为key来获取配置字典
+ (NSDictionary *)configDictionary;

//通过类名作为key来获取配置string
+ (NSString *)configString;

@end
