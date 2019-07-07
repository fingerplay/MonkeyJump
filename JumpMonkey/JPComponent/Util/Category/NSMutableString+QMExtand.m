//
//  NSMutableString+QMExtand.m
//  juanpi3
//
//  Created by Jay on 15-4-22.
//  Copyright (c) 2015年 Jay. All rights reserved.
//

#import "NSMutableString+QMExtand.h"
#import "NSString+safe.h"
@implementation NSMutableString (QMExtand)

- (void)stringAppendWithDot:(NSString *)appendStr {
    NSString *dotStr = [NSString stringWithFormat:@"%@,", appendStr];
    [self appendString:dotStr];
}


- (BOOL)stringAppendNotExistWithDot:(NSString *)appendStr {
    if (!appendStr.length) {
        return YES;
    }
    NSString *dotStr = [NSString stringWithFormat:@"%@,", appendStr];
    
    if ([self isExistWithDot:dotStr]) {
        return YES;
    }
    
    [self appendString:dotStr];
    
    return NO;
}


- (BOOL)isExistWithDot:(NSString *)dotStr {
    if ([self safeRangeOfString:dotStr].location == NSNotFound) {
        return NO;
    }
    return YES;
}

//- (NSString *)stringGoodsIdWithDot:(NSArray *)goods {
//    
//    NSMutableArray *goodIdArr = [[NSMutableArray alloc] initWithCapacity:0];
//    for (QMUGoods *good in goods) {
//        if (![good isKindOfClass:[QMUGoods class]]) {
//            continue ;
//        }
//        [goodIdArr safeAddObject:good.goods_id];
//    }
//    
//    return [goodIdArr componentsJoinedByString:@","];
//    
//}

@end
