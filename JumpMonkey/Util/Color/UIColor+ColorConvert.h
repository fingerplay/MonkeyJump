//
//  UIColor+ColorConvert.h
//  SmartHome
//
//  Created by sxy on 19/07/2017.
//  Copyright © 2017 EverGrande. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SHColorWithHexString(color) [UIColor colorWithHexString:color]

@interface UIColor (ColorConvert)

/**
 *颜色转换：十六进制的颜色转换为UIColor(RGB)
 */
+ (UIColor *)colorWithHexString: (NSString *)color;

+ (UIColor *)colorWithHexString: (NSString *)color alpha:(CGFloat)alpha;

//绘制渐变色颜色的方法
+ (CAGradientLayer *)setGradualChangingColor:(UIView *)view
                                   fromColor:(UIColor *)fromHexColor
                                     toColor:(UIColor *)toHexColor;

// 颜色转换为背景图片
- (UIImage *)convertColorToBackgroundImage;

@end
