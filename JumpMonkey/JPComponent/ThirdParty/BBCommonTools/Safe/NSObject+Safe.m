//
//  NSObject+Safe.m
//  juanpi3
//
//  Created by Jay on 14-12-23.
//  Copyright (c) 2014年 Jay. All rights reserved.
//

#import "NSObject+Safe.h"

@implementation NSObject (Safe)


- (id)qm_safeValueForKey:(NSString *)key
{
    
    if (!key){
        return @"";
    }
    
    id value = [self valueForKey:key];
    if(value == nil)
    {
        return @"";
    }
    return value;
}


- (void)qm_safeSetValue:(id)value forKey:(NSString *)key
{
    if (!value || !key){
        return ;
    }
    
    [self setValue:value forKey:key];
}


@end
