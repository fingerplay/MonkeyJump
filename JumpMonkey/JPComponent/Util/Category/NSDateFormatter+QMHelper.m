//
//  NSDateFormatter+QMHelper.m
//  juanpi3
//
//  Created by 苏金辉 on 20/12/2016.
//  Copyright © 2016 苏金辉. All rights reserved.
//

#import "NSDateFormatter+QMHelper.h"
#import "NSDictionary+safe.h"
#import "NSMutableDictionary+safe.h"
@implementation NSDateFormatter (QMHelper)

+ (NSDateFormatter *)dateFormatterWithFormatString:(NSString *)format
{
    NSMutableDictionary *threadDic = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *dateFormatter = [threadDic safeObjectForKey:format];
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = format;
        [threadDic safeSetObject:dateFormatter forKey:format];
    }
    return dateFormatter;
}

@end
