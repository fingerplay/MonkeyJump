//
//  QMGlobalConfig.h
//  juanpi3
//
//  Created by 罗谨 on 15/7/31.
//  Copyright (c) 2015年 罗谨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QMGlobalAppearance : NSObject

/**
 *  设置导航栏背景透明，注意是全局设置!!!
 */
+ (void)setNavigationBarTransparentBackground;

/**
 *  设置导航栏背景不透明，注意是全局设置!!!
 */
+ (void)setNavigationBarOpaqueBackground;

/**
 *  设置状态栏颜色:白色
 */
+ (void)setStatusBarWhite;

/**
 *  设置状态栏颜色:灰色
 */
+ (void)setStatusBarDark;

/**
 *  设置导航栏总体风格
 *
 *  @param vc UIViewController
 */
+ (void)setNavigationBarStyleWithVC:(UIViewController *)vc;

/**
 *  设置导航栏APP风格
 *
 *  @param vc UIViewController
 */
+ (void)setNavigationBarAppStyleWithVC:(UIViewController *)vc;

@end
