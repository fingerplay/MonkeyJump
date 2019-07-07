//
//  NSArray+QMCategory.m
//  juanpi3
//
//  Created by Jay on 15-3-28.
//  Copyright (c) 2015年 Jay. All rights reserved.
//

#import "NSArray+QMCategory.h"
#import "NSMutableArray+safe.h"
@implementation NSArray (QMCategory)

+ (NSString *)stringAppendWithVLine:(NSArray *)array {    
    return [array componentsJoinedByString:@"||"];
}

+ (NSArray *)parseStringToArray:(NSString *)str {
    str = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    NSArray *separatedArray = [str componentsSeparatedByString:@"|"];
    for (NSString *str in separatedArray) {
        NSRange rang = [str rangeOfString:@"="];
        if (rang.location!=NSNotFound) {
            NSString *key = [str substringToIndex:rang.location];
            NSString *value = [str substringFromIndex:rang.location + rang.length];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            if (key) {
                
                BOOL hasKey = NO;
                //防御性判断存在多个key相同情况
                for (NSDictionary * dic in dataArray) {
                    if ([[dic allKeys]containsObject:key]) {
                        hasKey = YES;
                    }
                }
                
                if (hasKey) {
                    continue;
                }
                
                
                if (value) {
                    [dic setObject:value forKey:key];
                    
                }else{
                    //防止value为空情况
                    [dic setObject:@"" forKey:key];
                }
                [dataArray safeAddObject:dic];
            }
            
        }
    }
    return dataArray;

}

@end
