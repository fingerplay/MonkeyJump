//
//  SHLoadingView.h
//  ToastTest
//
//  Created by Aron.li on 2018/8/10.
//  Copyright © 2018年 Aron.li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHLoadingView : UIView

typedef NS_ENUM(NSUInteger, SHLoadingViewType) {
    SHLoadingViewTypeCommon,
    SHLoadingViewTypeCustom
};

+ (instancetype)sharedInstance;

/**
 * loading with text
 */
- (void)showLoadingOnView:(UIView *)parent withMessage:(NSString *)message;

/**
 * loading with img only,消失需调用dismiss method
 */
- (void)showLoadingOnView:(UIView *)parent;

/**
 * 在window层上显示加载信息
 */
- (void)showLoadingWithMessage:(NSString *)message;

/**
 * 自定义蓝色小点 loading with text,消失需调用dismiss method
 */
- (void)showCustomLoadingOnView:(UIView *)parent withMessage:(NSString *)message;

- (void)dismiss;
- (void)dismissOnView:(UIView *)view;

@end
