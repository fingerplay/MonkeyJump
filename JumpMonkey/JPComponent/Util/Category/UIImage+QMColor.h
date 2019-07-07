//
//  UIImage+QMColor.h
//  JPComponentDemo
//
//  Created by 彭军 on 2017/1/19.
//  Copyright © 2017年 卷皮网. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (QMColor)
/**
 *  用一个颜色生成图片
 *
 *  @param color 图片颜色
 *
 *  @return 图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 *  用一个颜色生成图片
 *
 *  @param color 图片颜色
 *  @param size  图片大小
 *
 *  @return 图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

@end
