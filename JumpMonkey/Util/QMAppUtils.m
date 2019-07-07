//
//  QMAppUtils.m
//  juanpi3
//
//  Created by Jay on 16/1/8.
//  Copyright © 2016年 Jay. All rights reserved.
//

#import "QMAppUtils.h"


@implementation QMAppUtils

+ (UIViewController *)currentVisibleVC { 
    UIViewController *visibleVC = [self currentNavController].visibleViewController;
    return visibleVC;
}

+ (UIViewController *)currentViewableVC
{
    UIViewController *ctl = [self currentVisibleVC];
    if ([ctl conformsToProtocol:@protocol(QMChildsVCProtocol)]) {
        ctl = [ctl performSelector:@selector(visibleChildVC)];
    }
    return ctl;
}

+ (UINavigationController *)currentNavController {
   UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
    UIViewController *vc = topWindow.rootViewController;
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return (UINavigationController*)vc;
    }
    return nil;
}


+ (UIViewController *)getCurrentRootViewController {
    
    UIViewController *result;
    UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
    if (topWindow.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(topWindow in windows) {
            if (topWindow.windowLevel == UIWindowLevelNormal)
                break;
        }
    }
    UIView *rootView = [[topWindow subviews] objectAtIndex:0];
    id nextResponder = [rootView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        result = nextResponder;
    }
    else if ([topWindow respondsToSelector:@selector(rootViewController)] && topWindow.rootViewController != nil) {
        result = topWindow.rootViewController;
    }
    else {
        NSAssert(NO, @"ShareKit: Could not find a root view controller.  You can assign one manually by calling [[SHK currentHelper] setRootViewController:YOURROOTVIEWCONTROLLER].");
    }
    
    return result;
}

+ (UIImage *)getTheLaunchImage {
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    NSString *viewOrientation = nil;
    if (([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown) || ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait)) {
        viewOrientation = @"Portrait";
    } else {
        viewOrientation = @"Landscape";
    }
    NSString *launchImage = nil;
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary *dict in imagesDict){
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]){
            launchImage = dict[@"UILaunchImageName"];
        }
    }
    return [UIImage imageNamed:launchImage];
}

CGRect QMRectMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height, CGFloat scale) {
    return CGRectMake(x*scale, y*scale, width*scale, height*scale);
}

@end
