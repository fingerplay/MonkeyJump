//
//  SCDevice.h
//  SCFoundation
//
//  Created by huoweian on 2018/6/27.
//  Copyright © 2018年 evergrande. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface SCDevice : NSObject

/// 屏幕宽度
+ (CGFloat)getDeviceScreenWidth;

/// 屏幕高度
+ (CGFloat)getDeviceScreenHeight;

/// 获取设备版本号
+ (NSString *)getDeviceName;

/// 获取iPhone名称
+ (NSString *)getiPhoneName;

/// 是否是iphoneX
+ (BOOL)isIPhoneX;

/// 是否开启了热点
+ (BOOL)isOpenHotspot;

/// 获取电池电量
+ (CGFloat)getBatteryLevel;

/// 当前系统名称
+ (NSString *)getSystemName;

/// 当前系统版本号
+ (NSString *)getSystemVersion;

/// 通用唯一识别码UUID
+ (NSString *)getUUID;

/// 获取当前设备IP
+ (NSString *)getDeviceIPAdress;

/// 获取总内存大小
+ (long long)getTotalMemorySize;

/// 获取当前可用内存
+ (long long)getAvailableMemorySize;

/// 获取精准电池电量
+ (CGFloat)getCurrentBatteryLevel;

/// 获取电池当前的状态，共有4种状态
+ (NSString *) getBatteryState;

/// 获取当前语言
+ (NSString *)getDeviceLanguage;

/// 获取当 MAC 地址
+ (NSString *) getMacAddress;

/// 获取当 wifi 名称
+ (NSString* )getWifiName;

// 设备唯一id
+ (NSString *)deviceUUID;

// 是否越狱
+ (BOOL)isJailbroken;


@end
