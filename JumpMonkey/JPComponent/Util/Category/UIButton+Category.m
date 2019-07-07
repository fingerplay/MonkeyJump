//
//  UIButton+Category.m
//  Juanpi_2.0
//
//  Created by luoshuai on 14-2-24.
//  Copyright (c) 2014年 Juanpi. All rights reserved.
//

#import "UIButton+Category.h"
#import "UIImage+QMColor.h"

@implementation UIButton (Category)

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state
{
    [self setBackgroundImage:[UIImage imageWithColor:backgroundColor] forState:state];
}

+ (UIButton *)buttonWithTitle:(NSString *)title
                   titleColor:(UIColor *)titleColor
        highlightedTitleColor:(UIColor *)highlightedTitleColor
           disabledTitleColor:(UIColor *)disabledTitleColor
                         font:(UIFont *)font
              backgroundColor:(UIColor *)bgColor
                       target:(id)target
                       action:(SEL)action
{
    return [UIButton buttonWithTitle:title
                          titleColor:titleColor
               highlightedTitleColor:highlightedTitleColor
                  disabledTitleColor:disabledTitleColor
                                font:font
                     backgroundColor:bgColor
          highlightedBackgroundColor:nil
             disabledBackgroundColor:nil
                              target:(id)target
                              action:(SEL)action];
}

+ (UIButton *)buttonWithBackgroundImage:(UIImage *)bgImage
             highlightedBackgroundImage:(UIImage *)highlightedBgImage
                disabledBackgroundImage:(UIImage *)disabledBgImage
                                 target:(id)target
                                 action:(SEL)action
{
    return [UIButton buttonWithTitle:nil
                          titleColor:nil
               highlightedTitleColor:nil
                  disabledTitleColor:nil
                                font:nil
                               image:nil
                    highlightedImage:nil
                       disabledImage:nil
                     backgroundImage:bgImage
          highlightedBackgroundImage:highlightedBgImage
             disabledBackgroundImage:disabledBgImage
                              target:target action:action];
}

+ (UIButton *)buttonWithImage:(UIImage *)image
             highlightedImage:(UIImage *)highlightedImage
                disabledImage:(UIImage *)disabledImage
              backgroundColor:(UIColor *)bgColor
   highlightedBackgroundColor:(UIColor *)highlightedBgColor
      disabledBackgroundColor:(UIColor *)disabledBgColor
                       target:(id)target
                       action:(SEL)action
{
    return [UIButton buttonWithTitle:nil
                          titleColor:nil
               highlightedTitleColor:nil
                  disabledTitleColor:nil
                                font:nil
                               image:image
                    highlightedImage:highlightedImage
                       disabledImage:disabledImage
                     backgroundColor:bgColor
          highlightedBackgroundColor:highlightedBgColor
             disabledBackgroundColor:disabledBgColor
                              target:target
                              action:action];
}

+ (UIButton *)buttonWithTitle:(NSString *)title
                   titleColor:(UIColor *)titleColor
        highlightedTitleColor:(UIColor *)highlightedTitleColor
           disabledTitleColor:(UIColor *)disabledTitleColor
                         font:(UIFont *)font
              backgroundColor:(UIColor *)bgColor
   highlightedBackgroundColor:(UIColor *)highlightedBgColor
      disabledBackgroundColor:(UIColor *)disabledBgColor
                       target:(id)target
                       action:(SEL)action
{
    return [UIButton buttonWithTitle:title
                          titleColor:titleColor
               highlightedTitleColor:highlightedTitleColor
                  disabledTitleColor:disabledTitleColor
                                font:font
                               image:nil
                    highlightedImage:nil
                       disabledImage:nil
                     backgroundColor:bgColor
          highlightedBackgroundColor:highlightedBgColor
             disabledBackgroundColor:disabledBgColor
                              target:target
                              action:action];
}

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
                       action:(SEL)action
{
    return [UIButton buttonWithTitle:title
                          titleColor:titleColor
               highlightedTitleColor:highlightedTitleColor
                  disabledTitleColor:disabledTitleColor
                                font:font
                               image:image
                    highlightedImage:highlightedImage
                       disabledImage:disabledImage
                     backgroundImage:[UIImage imageWithColor:bgColor]
          highlightedBackgroundImage:[UIImage imageWithColor:highlightedBgColor]
             disabledBackgroundImage:[UIImage imageWithColor:disabledBgColor]
                              target:target
                              action:action];
}

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
                       action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (title) {
        [btn setTitle:title forState:UIControlStateNormal];
    }
    if (titleColor) {
        [btn setTitleColor:titleColor forState:UIControlStateNormal];
    }
    if (highlightedTitleColor) {
        [btn setTitleColor:highlightedTitleColor forState:UIControlStateHighlighted];
    }
    if (disabledTitleColor) {
        [btn setTitleColor:disabledTitleColor forState:UIControlStateDisabled];
    }
    if (font) {
        [btn.titleLabel setFont:font];
    }
    if (image) {
        [btn setImage:image forState:UIControlStateNormal];
    }
    if (highlightedImage) {
        [btn setImage:highlightedImage forState:UIControlStateHighlighted];
    }
    if (disabledImage) {
        [btn setImage:disabledImage forState:UIControlStateDisabled];
    }
    if (bgImage) {
        [btn setBackgroundImage:bgImage forState:UIControlStateNormal];
    }
    if (highlightedBgImage) {
        [btn setBackgroundImage:highlightedBgImage forState:UIControlStateHighlighted];
    }
    if (disabledBgImage) {
        [btn setBackgroundImage:disabledBgImage forState:UIControlStateDisabled];
    }
    if (target && action) {
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return btn;
}

- (void)sendImageToCenter
{
    self.imageView.frame = CGRectMake(self.bounds.size.width/2-self.imageView.image.size.width/2, self.bounds.size.height/2-self.imageView.image.size.height/2, self.imageView.image.size.width, self.imageView.image.size.height);
}

@end
