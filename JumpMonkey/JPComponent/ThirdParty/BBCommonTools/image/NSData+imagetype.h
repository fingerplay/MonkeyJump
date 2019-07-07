//
//  NSData+imagetype.h
//  BBCommonToolsDemo
//
//  Created by Brick on 14-8-12.
//  Copyright (c) 2014年 Brick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (imagetype)
/*
    @"image/jpeg";
    @"image/png";
    @"image/gif";
    @"image/tiff";
*/
 
- (NSString *)typeForImageData;

@end
