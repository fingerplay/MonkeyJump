//
//  QMAppUtils.h
//  juanpi3
//
//  Created by Jay on 16/1/8.
//  Copyright © 2016年 Jay. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol QMChildsVCProtocol <NSObject>

@required
- (UIViewController *)visibleChildVC;

@end


@interface QMAppUtils : NSObject

/**
 *  获取当前显示的VC
 *
 *  @return VC
 */
+ (UIViewController *)currentVisibleVC;

/**
 *  获取当前的VC 例如,QMBannerVC为QMHomeVC子控制器,获取的是QMBannerVC
 *
 *  @return VC
 */
+ (UIViewController *)currentViewableVC;

/**
 *  获取当前显示导航控制器
 *
 *  @return VC
 */
+ (UINavigationController *)currentNavController;

/**
 *  获取当前RootVC
 *
 *  @return RootViewController
 */
+ (UIViewController *)getCurrentRootViewController;

/**
 *  获取启动图片
 *
 *  @return UIImage
 */
+ (UIImage *)getTheLaunchImage;

CGRect QMRectMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height, CGFloat scale);

@end
