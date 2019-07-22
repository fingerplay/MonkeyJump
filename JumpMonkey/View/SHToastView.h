//
//  SHToastView.h
//  SmartHome
//
//  Created by sxy on 2017/7/5.
//  Copyright © 2017年 EverGrande. All rights reserved.
//
#import <UIKit/UIKit.h>

#define kToastWarningWhiteImg @"warning_round_white"

#define ToastViewSharedInstance [SHToastView sharedInstance]

//toast位置
typedef NS_ENUM(NSInteger, SHToastViewPosition)  {
    /** 导航栏下方横幅 */
    SHToastViewPositionTopBanner,
    /** 屏幕上方 */
    SHToastViewPositionTopCenter,
    /** 屏幕中部 */
    SHToastViewPositionCenter,
};

@interface SHToastView : UIView

@property (nonatomic, assign) SHToastViewPosition mode;
@property (nonatomic, assign) NSTimeInterval animationDelay; //动画延迟执行的时间

+ (instancetype)sharedInstance;

/**
 * 纯文本，默认显示在屏幕中央 && 自动消失
 */
- (void)showOnView:(UIView *)parent withMessage:(NSString *)message;

/**
 * error图像 + 文本，默认显示在屏幕中央 && 自动消失
 */
- (void)showErrorOnView:(UIView *)parent withMessage:(NSString *)message;

/**
 * 纯文本,默认显示在屏幕中央，不会自动消失，需调用dismiss method
 */
- (void)showWithStatus:(NSString *)status onView:(UIView *)parent;

/**
 * 纯文本，默认自动消失
 */
- (void)showOnView:(UIView *)parent withMessage:(NSString *)message mode:(SHToastViewPosition)mode;
- (void)showOnView:(UIView *)parent withMessage:(NSString *)message mode:(SHToastViewPosition)mode completionBlock:(dispatch_block_t)completionBlock;

/**
 * 图片名 + 文本 ，默认自动消失
 */
- (void)showOnView:(UIView *)parent withMessage:(NSString *)message image:(NSString *)imageName mode:(SHToastViewPosition)mode;
- (void)showOnView:(UIView *)parent withMessage:(NSString *)message image:(NSString *)imageName mode:(SHToastViewPosition)mode completionBlock:(dispatch_block_t)completionBlock;

/**
 * 图片类型 + 文本，默认自动消失
 */
- (void)showOnView:(UIView *)parent withMessage:(NSString *)message alertType:(NSInteger)alertType mode:(SHToastViewPosition)mode;
- (void)showOnView:(UIView *)parent withMessage:(NSString *)message alertType:(NSInteger)alertType mode:(SHToastViewPosition)mode completionBlock:(dispatch_block_t)completionBlock;


- (void)dismiss;
- (void)dismissAfterDelay:(NSTimeInterval)delay;
- (void)dismissOnView:(UIView *)view;

@end
