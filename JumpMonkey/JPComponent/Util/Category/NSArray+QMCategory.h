//
//  NSArray+QMCategory.h
//  juanpi3
//
//  Created by Jay on 15-3-28.
//  Copyright (c) 2015年 Jay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (QMCategory)


/**
 *  把数组里面的字符串用@"||"连接起来
 *
 *  @param array array,例:@[@"a",@"b",@"c",@"d"]
 *
 *  @return a||b||c||d
 */
+ (NSString *)stringAppendWithVLine:(NSArray *)array;

+ (NSArray *)parseStringToArray:(NSString *)str;

@end
