//
//  NSData+imagetype.m
//  BBCommonToolsDemo
//
//  Created by Brick on 14-8-12.
//  Copyright (c) 2014年 Brick. All rights reserved.
//

#import "NSData+imagetype.h"
#import "QMFoundationDataForwardTarget.h"

@implementation NSData (imagetype)

- (NSString *)typeForImageData{
    uint8_t c;
    [self getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return @"image/jpeg";
        case 0x89:
            return @"image/png";
        case 0x47:
            return @"image/gif";
        case 0x49:
        case 0x4D:
            return @"image/tiff";
    }
    return nil;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return [[QMFoundationDataForwardTarget alloc] init];
}

@end
