//
//  ViewUtility.h
//  SmartHome
//
//  Created by 刘以浩 on 2017/11/24.
//  Copyright © 2017年 EverGrande. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "SHFamilyModel.h"

@interface ViewUtility : NSObject

+ (UIViewController *_Nullable)topViewController;

+ (UIViewController *_Nullable)_topViewController:(UIViewController *_Nullable)vc;

+ (UINavigationController *_Nullable)topViewControllerNavigationController;

+ (UIViewController* _Nullable)getViewControllerWithIdentifier:(NSString* _Nullable)identifier storyboard:(NSString* _Nonnull)storyboardName;
+ (UIViewController* _Nullable)getViewControllerWithNavigationControllerAtIdentifier:(NSString *_Nullable)identifier storyboard:(NSString *_Nonnull)storyboardName;

@end
