//
//  QMDeviceHelper
//  juanpi3
//
//  Created by zhaojun on 15-2-11.
//  Copyright (c) 2015年 zhaojun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#define Scale(a) (a)/ScreenScale()

#define ScreenWidth [UIScreen mainScreen].bounds.size.width //屏幕宽
#define ScreenHeight [UIScreen mainScreen].bounds.size.height //屏幕高
#define NavHeight (64)
#define ScreenWidthScale (ScreenWidth/320) //屏幕宽比例


#define SCREEN_W [UIScreen mainScreen].bounds.size.width //屏幕宽
#define SCREEN_H [UIScreen mainScreen].bounds.size.height //屏幕高

#define IPHONEX_SAFE_AREA_TOP       44 // iphoneX 顶部安全区域
#define IPHONEX_SAFE_AREA_BOTTOM      34 // iPhoneX 底部安全区域

//i4的屏幕宽高比例
#define S_SCALE_W_4(w) (SCREEN_W*(w)/320)
#define S_SCALE_H_4(h) (SCREEN_H*(h)/480)

//i5的屏幕宽高比例
#define S_SCALE_W_5(w) (SCREEN_W*(w)/320)
#define S_SCALE_H_5(h) (SCREEN_H*(h)/568)

//i6的屏幕宽高比例
#define S_SCALE_W_6(w) (SCREEN_W*(w)/375)
#define S_SCALE_H_6(h) (SCREEN_H*(h)/667)

//i6P的屏幕宽高比例
#define S_SCALE_W_6P(w) (SCREEN_W*(w)/414)
#define S_SCALE_H_6P(h) (SCREEN_H*(h)/736)


typedef NS_ENUM (NSUInteger, ScreenSize) {
    ScreenSizeUnKnown = 0,//未知
    ScreenSizeIphone4 = 35,//3.5寸,iPhone4,4s
    ScreenSizeIphone5 = 40,//4.0寸,iPhone5,5c,5s
    ScreenSizeIphone6 = 47,//4.7寸,iphone6
    ScreenSizeIphone6P = 55,//5.5寸,iphone6plus
    ScreenSizeIphoneX = 58,
};

@interface QMDeviceHelper : NSObject

#pragma mark - 系统、版本、名称等
//返回系统版本号
CGFloat SystemVersion();

//返回当前app名称
NSString *AppName();

//返回当前app版本号
NSString *AppVersion();

//返回当前app build版本号
NSString *AppBuildVersion();

//返回当前设备名称，如：iPhone 6
NSString *DeviceName();


#pragma mark - 屏幕分辨率、尺寸
//返回当前屏分辨率
CGSize ScreenResolution();

//返回屏幕分辨率，格式“高x宽”，如“960x640”
NSString *ScreenResolutionHxW();

//返回屏幕分辨率，格式“宽x高”，如“640x960”
NSString *ScreenResolutionWxH();

//屏幕尺寸
ScreenSize ScreenInch();

//屏幕scale
CGFloat ScreenScale();


#pragma mark - 本地信息相关：运营商、国家、语言等
//返回当前手机的移动运营商
NSString *MobileOperator();

//国家
NSString *LocalCountry();

//语言
NSString *LocalLanguage();


#pragma mark - 破解越狱


/**
 *  判断设备是否越狱，判断方法根据apt和Cydia.app的path来判断
 *
 *  @return Yes for jailbroken, No for not
 */
BOOL isJailbroken();

/**
 *  判断你的App是否被破解
 *
 *  @return Yes for 破解, No for not
 */
BOOL isPirated();

@end
