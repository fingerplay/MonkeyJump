//
//  UIImage+QMColor.m
//  JPComponentDemo
//
//  Created by 彭军 on 2017/1/19.
//  Copyright © 2017年 卷皮网. All rights reserved.
//

#import "UIImage+QMColor.h"

@implementation UIImage (QMColor)

+ (UIImage *)imageWithColor:(UIColor *)color
{
    return [UIImage imageWithColor:color size:CGSizeMake(1.0f, 1.0f)];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    
    if (!color) {
        return nil;
    }
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
