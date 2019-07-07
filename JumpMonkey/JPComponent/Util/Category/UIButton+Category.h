//
//  UIButton+Category.h
//  Juanpi_2.0
//
//  Created by luoshuai on 14-2-24.
//  Copyright (c) 2014年 Juanpi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Category)

//为button的特定状态设置对应的背景颜色
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;

/**
 * 函数描述:快速创建一个可以修改文字内容,修改文字字体,正常状态下,高亮状态下和不可点击状态下的文字字体颜色,背景纯色生成图片(系统自带按压效果),带点击事件的按钮(一般比较少用,因为系统自带的颜色跟设计给过来的颜色不一致)
 *
 * @param title 按钮标题
 *
 * @param titleColor 按钮正常状态下标题的颜色  highlightedTitleColor  按钮高亮状态下标题的颜色
          disabledBgColor 按钮不可点击状态下的纯色生成的背景图片
 *
 * @param font 字体
 *
 * @param bgColor 按钮背景颜色(系统自带按压高亮的效果)
 *
 * @param target 方法执行者
 *
 * @param action 事件需要执行的方法(单击)
 *
 * @return 配置好的按钮
 */
+ (UIButton *)buttonWithTitle:(NSString *)title
                   titleColor:(UIColor *)titleColor
        highlightedTitleColor:(UIColor *)highlightedTitleColor
           disabledTitleColor:(UIColor *)disabledTitleColor
                         font:(UIFont *)font
              backgroundColor:(UIColor *)bgColor
                       target:(id)target
                       action:(SEL)action;

/**
 * 函数描述:快速创建一个可以修改正常状态下、高亮状态下和不可点击状态下的背景图片,带点击事件的按钮
 *
 * @param bgImage 按钮正常状态下的背景图片 highlightedBackgroundImage 按钮高亮状态下的背景图片
          disabledBackgroundImage 按钮不可点击状态下的背景图片
 *
 *
 * @param target 方法执行者
 *
 * @param action 事件需要执行的方法(单击)
 *
 * @return 配置好的按钮
 */

+ (UIButton *)buttonWithBackgroundImage:(UIImage *)bgImage
             highlightedBackgroundImage:(UIImage *)highlightedBgImage
                disabledBackgroundImage:(UIImage *)disabledBgImage
                                 target:(id)target
                                 action:(SEL)action;

/**
 * 函数描述:快速创建一个可以显示正常状态下、高亮状态下和不可点击状态下的图片,正常状态下、高亮状态下和不可点击状态下的纯色生成背景图片,带点击事件的按钮
 *
 * @param image 按钮正常状态下左边图片的颜色 highlightedImage 按钮高亮状态下左边图片的颜色
          disabledImage 按钮不可点击状态下左边图片的颜色
 *
 * @param bgColor 按钮正常状态下的纯色生成的背景图片 highlightedBgColor 按钮高亮状态下的纯色生成的背景图片
          disabledBgColor 按钮不可点击状态下的纯色生成的背景图片
 *
 *
 * @param target 方法执行者
 *
 * @param action 事件需要执行的方法(单击)
 *
 * @return 配置好的按钮
 */
+ (UIButton *)buttonWithImage:(UIImage *)image
             highlightedImage:(UIImage *)highlightedImage
                disabledImage:(UIImage *)disabledImage
              backgroundColor:(UIColor *)bgColor
   highlightedBackgroundColor:(UIColor *)highlightedBgColor
      disabledBackgroundColor:(UIColor *)disabledBgColor
                       target:(id)target
                       action:(SEL)action;

/**
 * 函数描述:快速创建一个可以修改文字内容,修改文字字体,正常状态下、高亮状态下和不可点击状态的文字字体颜色,正常状态下、高亮状态下和不可点击状态下的纯色生成背景图片,带点击事件的按钮
 *
 * @param title 按钮标题
 *
 * @param titleColor 按钮正常状态下标题的颜色 highlightedTitleColor 按钮高亮状态下标题的颜色
          disabledTitleColor 按钮不可点击状态下标题的颜色
 *
 * @param bgColor 按钮正常状态下的纯色生成的背景图片 highlightedBgColor 按钮高亮状态下的纯色生成的背景图片
          disabledBgColor 按钮不可点击状态下的纯色生成的背景图片
 *
 * @param font 字体
 *
 * @param target 方法执行者
 *
 * @param action 事件需要执行的方法(单击)
 *
 * @return 配置好的按钮
 */
+ (UIButton *)buttonWithTitle:(NSString *)title
                   titleColor:(UIColor *)titleColor
        highlightedTitleColor:(UIColor *)highlightedTitleColor
           disabledTitleColor:(UIColor *)disabledTitleColor
                         font:(UIFont *)font
              backgroundColor:(UIColor *)bgColor
   highlightedBackgroundColor:(UIColor *)highlightedBgColor
      disabledBackgroundColor:(UIColor *)disabledBgColor
                       target:(id)target
                       action:(SEL)action;

/**
 * 函数描述:快速创建一个可以修改文字内容,修改文字字体,正常状态下、高亮状态下和不可点击状态的文字字体颜色,正常状态下、高亮状态下和不可点击状态下的纯色生成背景图片,可以显示左侧正常状态下、高亮状态下和不可点击状态下的图片,带点击事件的按钮
 *
 * @param title 按钮标题
 *
 * @param titleColor 按钮正常状态下标题的颜色 highlightedTitleColor 按钮高亮状态下标题的颜色
          disabledTitleColor 按钮不可点击状态下标题的颜色
 *
 * @param image 按钮正常状态下左边图片的颜色 highlightedImage 按钮高亮状态下左边图片的颜色
          disabledImage 按钮不可点击状态下左边图片的颜色
 *
 * @param bgColor 按钮正常状态下的纯色生成的背景图片 highlightedBgColor 按钮高亮状态下的纯色生成的背景图片
          disabledBgColor 按钮不可点击状态下的纯色生成的背景图片
 *
 * @param font 字体
 *
 * @param target 方法执行者
 *
 * @param action 事件需要执行的方法(单击)
 *
 * @return 配置好的按钮
 */
+ (UIButton *)buttonWithTitle:(NSString *)title
                   titleColor:(UIColor *)titleColor
        highlightedTitleColor:(UIColor *)highlightedTitleColor
           disabledTitleColor:(UIColor *)disabledTitleColor
                         font:(UIFont *)font
                        image:(UIImage *)image
             highlightedImage:(UIImage *)highlightedImage
                disabledImage:(UIImage *)disabledImage
              backgroundColor:(UIColor *)bgColor
   highlightedBackgroundColor:(UIColor *)highlightedBgColor
      disabledBackgroundColor:(UIColor *)disabledBgColor
                       target:(id)target
                       action:(SEL)action;

/**
 * 函数描述:快速创建一个可以修改文字内容,修改文字字体,正常状态下、高亮状态下和不可点击状态的文字字体颜色,正常状态下、高亮状态下和不可点击状态下的背景图片,可以显示左侧正常状态下、高亮状态下和不可点击状态下的图片,带点击事件的按钮
 *
 * @param title 按钮标题
 *
 * @param titleColor 按钮正常状态下标题的颜色 highlightedTitleColor 按钮高亮状态下标题的颜色
          disabledTitleColor 按钮不可点击状态下标题的颜色
 *
 * @param image 按钮正常状态下左边图片的颜色 highlightedImage 按钮高亮状态下左边图片的颜色
          disabledImage 按钮不可点击状态下左边图片的颜色
 *
 * @param bgImage 按钮正常状态下的背景图片 highlightedBackgroundImage 按钮高亮状态下的背景图片
          disabledBackgroundImage 按钮不可点击状态下的背景图片
 *
 * @param font 字体
 *
 * @param target 方法执行者
 *
 * @param action 事件需要执行的方法(单击)
 *
 * @return 配置好的按钮
 */
+ (UIButton *)buttonWithTitle:(NSString *)title
                   titleColor:(UIColor *)titleColor
        highlightedTitleColor:(UIColor *)highlightedTitleColor
           disabledTitleColor:(UIColor *)disabledTitleColor
                         font:(UIFont *)font
                        image:(UIImage *)image
             highlightedImage:(UIImage *)highlightedImage
                disabledImage:(UIImage *)disabledImage
              backgroundImage:(UIImage *)bgImage
   highlightedBackgroundImage:(UIImage *)highlightedBgImage
      disabledBackgroundImage:(UIImage *)disabledBgImage
                       target:(id)target
                       action:(SEL)action;

/**
 *  设置点击扩大区域时，button的图片在中心，不拉伸
 */
- (void)sendImageToCenter;

@end
