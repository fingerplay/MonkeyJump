//
//  BBSystemValue.h
//  BBCommonToolsDemo
//
//  Created by Brick on 14-7-19.
//  Copyright (c) 2014年 Brick. All rights reserved.
//

#import <UIKit/UIKit.h>
#define SYSTEMVALUE [BBSystemValue sharedInstance]

@interface BBSystemValue : NSObject

+ (BBSystemValue *)sharedInstance;


@property (strong, nonatomic) NSString    *bundleID;      // bundleID
@property (strong, nonatomic) NSString    *systemVersion; // 系统版本号
@property (strong, nonatomic) NSString      *deviceName;    // 设备名称
@property (strong, nonatomic) NSString      *app_Name;      // APP名字
@property (strong, nonatomic) NSString      *app_Version;   // APP版本
@property (strong, nonatomic) NSString      *app_build;     // APP build号
@property (strong, nonatomic) NSNumber    * isJailBreak;

@property (strong, nonatomic) NSNumber    *screenHeight;   // 屏幕尺寸(物理尺寸)
@property (strong, nonatomic) NSNumber    *screenWidth;

//判断是否是iphone5或者iphone5c以及ipad4
@property (assign, nonatomic) BOOL isOldDevice;

@property (assign, nonatomic) BOOL isIPod;
@end
