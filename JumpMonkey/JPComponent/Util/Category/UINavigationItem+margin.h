//
//  UINavigationItem+margin.h
//  Juanpi_2.0
//
//  Created by luoshuai on 14-3-12.
//  Copyright (c) 2014年 Juanpi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationItem (margin)

- (void)setupLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem;
- (void)setupLeftBarButtonItems:(NSArray *)leftItems;
- (void)setupRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem;
- (void)setupRightBarButtonItems:(NSArray *)rightItems;

/**
 * 项目中常用的UIBarButtonItem
 *
 * @param imageName 正常状态下背景图片的名字
 *
 * @param highImageName 高亮状态下背景图片的名字
 *
 * @param target 执行方法者
 *
 * @param action 事件需要执行的方法(单击)
 *
 * @return 配置好的按钮
 */
+ (UIBarButtonItem *)itemWithImage:(NSString *)imageName highImage:(NSString *)highImageName target:(id)target action:(SEL)action;

@end
