//
//  QMExtension.h
//  juanpi3
//
//  Created by luoshuai on 14-9-5.
//  Copyright (c) 2014年 luoshuai. All rights reserved.
//

#pragma mark - 字体扩展
#define font(a) [UIFont systemFontOfSize:a]
#define font_B(a) [UIFont boldSystemFontOfSize:a]
//手机号码验证
#define isPhoneNumber @"^1((3[0-9])|(5[0|1|2|3|5|6|7|8|9])|(8[0-9])|(4[5|7])|(7[7]))\\d{8}$"
//身份证验证
#define isCardID @"/^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{4}$/"
//邮编
#define iszipNumber @"[1-9]\\d{5}(?!\\d)"

#define PLACEHOLDER_IMAGE_STRIP @"banner_min" // banner广告替换图
#define PLACEHOLDER_IMAGE_MIN @"default_min" // 商品流豆腐块 方形替换图


#import "NSAttributedString+QMUI.h"
#import "NSString+UI.h"
#import "UIButton+CustomColor.h"
#import "UIColor+CustomColor.h"
#import "UILabel+QMTitle.h"
#import "UINavigationItem+margin.h"
#import "UIView+Common.h"
#import "UILabel+Additions.h"
#import "NSDate+Utilities.h"
#import "UIButton+Category.h"
#import "NSAttributedString+Category.h"
