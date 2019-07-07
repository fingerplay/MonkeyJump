//
//  NSString+Json.m
//  juanpi3
//
//  Created by zagger on 15/4/2.
//  Copyright (c) 2015年 zagger. All rights reserved.
//

#import "NSString+Json.h"

@implementation NSString (Json)

+ (NSString *)stringWithJsonDictionary:(NSDictionary *)jsonDic sortType:(QMSortType)sortType
{
    if (!jsonDic || ![jsonDic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    NSArray *sortedKeys = [self sortArray:jsonDic.allKeys withSortType:sortType];
    
    NSMutableString *jsonString = [[NSMutableString alloc] init];
    [jsonString appendString:@"{"];
    for (NSString *key in sortedKeys) {
        [jsonString appendFormat:@"\"%@\"", key];
        [jsonString appendString:@":"];
        
        id value = [jsonDic objectForKey:key];
        if ([value isKindOfClass:[NSDictionary class]]) {
            [jsonString appendFormat:@"%@", [self stringWithJsonDictionary:value sortType:sortType]];
        }
        else{
            [jsonString appendFormat:@"\"%@\"", value];
        }
        
        [jsonString appendString:@","];
    }
    if ([jsonString length] > 2) {
        [jsonString deleteCharactersInRange:NSMakeRange([jsonString length] - 1, 1)];
    }
    [jsonString appendString:@"}"];
    
    return jsonString;
}

+ (NSString *)queryStringWithDictionary:(NSDictionary *)dic sortType:(QMSortType)sortType {
    return [self queryStringWithDictionary:dic sortType:sortType encode:NO];
}

+ (NSString *)queryStringWithDictionary:(NSDictionary *)dic sortType:(QMSortType)sortType encode:(BOOL)encode {
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    NSArray *sortedKeys = [self sortArray:dic.allKeys withSortType:sortType];
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:sortedKeys.count];
    for (NSString *key in sortedKeys) {
        id value = [dic objectForKey:key];
        NSString *valueString = [[NSString stringWithFormat:@"%@",value] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (encode) {
            valueString = [self urlEncodeStringWithString:valueString];
        }
        NSString *str = [NSString stringWithFormat:@"%@=%@",key,valueString];
        [array addObject:str];
    }
    
    return [array componentsJoinedByString:@"&"];
}


+ (NSString *)urlEncodeStringWithString:(NSString *)originalString
{//对cookies值进入URL encode,以支持中文字符和其他特殊字符
    if (!originalString) {
        return @"";
    }
    if (![originalString isKindOfClass:[NSString class]]) {
        originalString = [NSString stringWithFormat:@"%@",originalString];
    }
    CFStringRef encodedString = CFURLCreateStringByAddingPercentEscapes(
                                                                        kCFAllocatorDefault,
                                                                        (__bridge CFStringRef)(originalString),
                                                                        NULL,
                                                                        CFSTR(":/?#[]@!$&'()*+,;="),
                                                                        kCFStringEncodingUTF8);
    return (NSString *)CFBridgingRelease(encodedString);
}


#pragma mark - helper
+ (NSArray *)sortArray:(NSArray *)originArray withSortType:(QMSortType)sortType {
    if (sortType == QMSortTypeNone || !originArray || originArray.count <= 0) {
        return originArray;
    }
    
    NSArray *resultArray = [originArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([obj1 isKindOfClass:[NSString class]] && [obj2 isKindOfClass:[NSString class]]) {
            NSString *str1 = (NSString *)obj1;
            NSString *str2 = (NSString *)obj2;
            
            if (sortType == QMSortTypeDescending) {
                return [str2 compare:str1];
            }
            else if (sortType == QMSortTypeAscending) {
                return [str1 compare:str2];
            }
        }
        return NSOrderedSame;
    }];
    
    return resultArray;
}

@end
