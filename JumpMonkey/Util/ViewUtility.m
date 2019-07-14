//
//  ViewUtility.m
//  SmartHome
//
//  Created by 刘以浩 on 2017/11/24.
//  Copyright © 2017年 EverGrande. All rights reserved.
//

#import "ViewUtility.h"
#import "QMRuntimeHelper.h"


@implementation ViewUtility

+ (UIViewController *_Nullable)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[[UIApplication sharedApplication].windows firstObject] rootViewController]];
    while (resultVC.presentedViewController && ![resultVC.presentedViewController isKindOfClass:[UIAlertController class]]) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}


+ (UINavigationController *_Nullable)topViewControllerNavigationController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[[UIApplication sharedApplication].windows firstObject] rootViewController]];
    while (resultVC.presentedViewController && ![resultVC.presentedViewController isKindOfClass:[UIAlertController class]]) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    
    if ([resultVC isKindOfClass:[UINavigationController class]]) {
        return (UINavigationController*)resultVC;
    }
    else{
        return resultVC.navigationController;
    }
}

+(UIViewController* _Nullable)GetPresentRootViewController:(UIViewController* _Nullable)currentVC{
    if (![currentVC isKindOfClass:[UIViewController class]]) {
        return  nil;
    }
    
    UIViewController * presentingViewController = currentVC.presentingViewController;
    while (presentingViewController.presentingViewController) {
        presentingViewController = presentingViewController.presentingViewController;
    }
    return presentingViewController;
}

+ (UIViewController *_Nullable)_topViewController:(UIViewController *_Nullable)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
}

+ (UIViewController*)getViewControllerWithIdentifier:(NSString *_Nullable)identifier storyboard:(NSString *_Nonnull)storyboardName{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    if (identifier.length > 0) {
        return [storyboard instantiateViewControllerWithIdentifier:identifier];
    } else {
        return [storyboard instantiateInitialViewController];
    }
}


+ (UIViewController*)getViewControllerWithNavigationControllerAtIdentifier:(NSString *_Nullable)identifier storyboard:(NSString *_Nonnull)storyboardName{
    UIViewController *destination = [ViewUtility getViewControllerWithIdentifier:identifier storyboard:storyboardName];
    if (![destination isKindOfClass:[UINavigationController class]]) {
        destination = [[UINavigationController alloc] initWithRootViewController:destination];
    }
    return destination;
}

+ (void)setValues:(NSDictionary*)keyValues forObject:(id)object {
    if (keyValues && object) {
        for (id key in keyValues.allKeys) {
            if (![key isKindOfClass:[NSString class]]) {
                NSCAssert(NO, @"key:%@ 不是字符串",key);
                continue;
            }
            if (![QMRuntimeHelper isClass:[object class] hasProperty:key]) {
                NSCAssert(NO, @"key:%@ 不存在 ",key);
                continue;
            }
            
            id value = [keyValues objectForKey:key];
            NSError *error = nil;
            if (![object validateValue:&value forKey:key error:&error]) {
                NSCAssert(NO, @"value:%@ 类型错误,key:%@",value,key);
                continue;
            } else {
                [object setValue:value forKey:key];
            }
        }
    }
}

@end
