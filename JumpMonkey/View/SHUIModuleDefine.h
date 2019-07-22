//
//  SHUIModuleDefine.h
//  SHUIKit
//
//  Created by 汤浩博 on 2018/8/10.
//

#ifndef SHUIModuleDefine_h
#define SHUIModuleDefine_h

#import "UIColor+ColorConvert.h"

// Color related macros
#define UIColorFromHexValue(hexValue)       [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0]
#define UIColorFromHexString(hexString)     [UIColor colorWithHexString:hexString]
#define RGBAColor(r, g, b, a)               [UIColor colorWithRed:(r) / 255.0f green:(g) / 255.0f blue:(b) / 255.0f alpha:(a)]
#define RGBColor(r, g, b)                   RGBAColor(r, g, b, 1.0)

//字体
#define kSystemFontName @"Helvetica"

// Font
#define kFontWithNameAndSize(name, sz)      [UIFont fontWithName:name size:sz]
#define kPingfangRegularFont(size)          kFontWithNameAndSize(@"PingFangSC-Regular", size)
#define kPingfangMediumFont(size)           kFontWithNameAndSize(@"PingFangSC-Medium", size)
#define kPingfangLightFont(size)            kFontWithNameAndSize(@"PingFangSC-Light", size)
#define kSystemFont(size)                   [UIFont systemFontOfSize:size]
#define kBoldSystemFont(size)               [UIFont boldSystemFontOfSize:size]

// Color
#define kDefaultButtonColor                 UIColorFromHexString(@"#13D5DC")
#define kCommonTextColor                    UIColorFromHexString(@"#C8CACC")
#define kDefaultDisableColor                UIColorFromHexString(@"#A9F4F6")
#define kDefaultNavigationColor             UIColorFromHexString(@"#FFFFFF")
#define kDefaultNavigationTitleColor        UIColorFromHexString(@"#081530")
#define kDefaultBlackColor                  UIColorFromHexString(@"#2F3133")
#define kDefaultRedColor                    UIColorFromHexString(@"#F26161")
#define kDefaultGreyColor                   UIColorFromHexString(@"#76787A")
#define kLightGreyColor                     UIColorFromHexString(@"#DBDBDB")
#define kHighlightGreyColor                 UIColorFromHexString(@"#EBEBEB")
#define kDefaultYellowColor                 UIColorFromHexString(@"#FFD53D")

#define SV_UIKIT_IS_iPhoneX        ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)     // iPhone X/XS
#define SV_UIKIT_IS_iPhoneXR       ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) : NO)     // iPhone XR
#define SV_UIKIT_IS_iPhoneXSMax    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)     // iPhone XSMax
#define SV_UIKIT_IS_iPhoneX_All    (SV_UIKIT_IS_iPhoneX || SV_UIKIT_IS_iPhoneXR || SV_UIKIT_IS_iPhoneXSMax) // iPhone X系列

#define SV_UIKIT_ISIOS11 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0)
#define SV_UIKIT_SafeStatusBarHeight            (SV_UIKIT_IS_iPhoneX_All ? 44 : 20)
#define SV_UIKIT_SafeNavigationBarHeight        (SV_UIKIT_IS_iPhoneX_All ? 88 : 64)

static NSString *const SCAlertControllerAttributedTitleKey = @"SCAlertControllerAttributedTitleKey";
static NSString *const SCAlertControllerAttributedMessageKey = @"SCAlertControllerAttributedMessageKey";
#endif /* SHUIModuleDefine_h */
