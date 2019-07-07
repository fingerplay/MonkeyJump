//
//  QMGlobalConfig.m
//  juanpi3
//
//  Created by 罗谨 on 15/7/31.
//  Copyright (c) 2015年 罗谨. All rights reserved.
//

#import "QMGlobalAppearance.h"

@implementation QMGlobalAppearance

+ (void)setNavigationBarTransparentBackground {
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];//去掉底部系统的黑线
}

+ (void)setNavigationBarOpaqueBackground {
    [[UINavigationBar appearance] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:nil];
}

+ (void)setStatusBarWhite {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

+ (void)setStatusBarDark {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
}

+ (void)setNavigationBarStyleWithVC:(UIViewController *)vc {
    UINavigationBar *navBar = vc.navigationController.navigationBar;
    [navBar setBackgroundImage:[UIImage imageWithColor:[UIColor navigationBarBackground]] forBarMetrics:UIBarMetricsDefault];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

}

+ (void)setNavigationBarAppStyleWithVC:(UIViewController *)vc {
    UINavigationBar *navBar = vc.navigationController.navigationBar;
    [navBar setBackgroundImage:[UIImage imageWithColor:[UIColor appStyleColor]] forBarMetrics:UIBarMetricsDefault];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
 
}


@end
