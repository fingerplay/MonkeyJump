//
//  NSString+Json.h
//  juanpi3
//
//  Created by zagger on 15/4/2.
//  Copyright (c) 2015年 zagger. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, QMSortType) {
    QMSortTypeNone = 0,//不进行排序
    QMSortTypeAscending,//升序排列
    QMSortTypeDescending//降序排列
};

@interface NSString (Json)

/**
 *  返回一个排序的json字符串
 *
 *  @param jsonDic  json字典
 *  @param sortType 排序方式（升序或降序）
 *
 *  @return 按要求排好序的字符串
 */
+ (NSString *)stringWithJsonDictionary:(NSDictionary *)jsonDic sortType:(QMSortType)sortType;

/**
 *  返回一个排序的query字符串，如：name=petter&pwd=123456&
 *
 *  @param dic      源字典
 *  @param sortType 升序或降序或无序
 *
 *  @return query字符串
 */
+ (NSString *)queryStringWithDictionary:(NSDictionary *)dic sortType:(QMSortType)sortType;
+ (NSString *)queryStringWithDictionary:(NSDictionary *)dic sortType:(QMSortType)sortType encode:(BOOL)encode;
+ (NSString *)urlEncodeStringWithString:(NSString *)originalString;
@end
