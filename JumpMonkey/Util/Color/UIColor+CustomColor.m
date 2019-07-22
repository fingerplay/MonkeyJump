//
//  UIColor+CustomColor.m
//  Juanpi
//
//  Created by luoyi on 13-12-31.
//  Copyright (c) 2013年 Juanpi. All rights reserved.
//

#import "UIColor+CustomColor.h"

@implementation UIColor (CustomColor)

#pragma mark - 16进制颜色获取

+ (UIColor *)colorWithHexString:(NSString *)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor clearColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    
    if ([cString length] != 6) return  [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}


//根据16进制RGB数值，返回UIColor
+ (UIColor *)colorWithHexRGB:(NSInteger)rgbValue
{
    return  [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
}

+ (UIColor *)colorWithHexRGB:(NSInteger)rgbValue alpha:(CGFloat)alpha
{
    return  [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alpha];
}

+ (UIColor*)r:(CGFloat)red g:(CGFloat)green b:(CGFloat)blue a:(CGFloat)alpha
{
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
}


#pragma mark - 总体风格
+ (UIColor *)appStyleColor
{
    return [[self class] appStyleColorWithAlpha:1.0];
}

+ (UIColor *)appStyleColorWithAlpha:(CGFloat)alpha
{
#ifdef APP_JP
    return HexRGBAlpha(0xff464e, alpha);
#elif APP_JKY
    return HexRGBAlpha(0xff464e, alpha);
#elif APP_JPHD
    return HexRGBAlpha(0xff464e, alpha);
#elif APP_JKYHD
    return HexRGBAlpha(0xff464e, alpha);
#endif
    return HexRGBAlpha(0xff464e, alpha);
}

//全球购紫色
+ (UIColor *)globalBuyColor
{
    return HexRGBAlpha(0x6600EE, 1.0);
}




#pragma mark - 按钮颜色
//灰色圆角按钮颜色，按钮不可点击时颜色
+(UIColor *)button_grayColor
{
    return [UIColor r:204 g:204 b:204 a:1];
}

//绿色圆角按钮颜色
+(UIColor *)button_greenColor
{
    return [UIColor r:75 g:213 b:98 a:1];
}

//红色圆角按钮颜色
+(UIColor *)button_redColor
{
    return [self appStyleColor];
}

//红色按钮高亮状态颜色
+ (UIColor *)button_redColorHighlight
{
#ifdef APP_JP
    return [UIColor colorWithHexRGB:0xeb2424];
#elif APP_JKY
    return [UIColor colorWithHexRGB:0xeb2424];
#elif APP_JPHD
    return [UIColor colorWithHexRGB:0xeb2424];
#elif APP_JKYHD
    return [UIColor colorWithHexRGB:0xeb2424];
#endif
    return [UIColor colorWithHexRGB:0xeb2424];
}

//红色按钮高亮状态颜色
+ (UIColor *)button_redColorHighlightWithAlpha:(CGFloat)alpha
{
#ifdef APP_JP
    return [UIColor colorWithHexRGB:0xeb2424 alpha:alpha];
#elif APP_JKY
    return [UIColor colorWithHexRGB:0xeb2424 alpha:alpha];
#elif APP_JPHD
    return [UIColor colorWithHexRGB:0xeb2424 alpha:alpha];
#elif APP_JKYHD
    return [UIColor colorWithHexRGB:0xeb2424 alpha:alpha];
#endif
    return [UIColor colorWithHexRGB:0xeb2424 alpha:alpha];
}


#pragma mark - 其他
+ (UIColor*)homePage_background
{//首页背景颜色
    return [UIColor r:236 g:236 b:236 a:1];
}

+ (UIColor *)priGrayColor
{//价格灰色
    return [UIColor r:180 g:180 b:180 a:1.0];
}

//新普通ProductViewCell颜色
+(UIColor*)statue_unstart_NewProductViewCell
{
    return HexRGB(0x79b103);
}

//类目背景颜色
+(UIColor *)menu_grayColor
{
    return [UIColor r:236 g:236 b:236 a:1];
}

//类目字体颜色
+ (UIColor *)menufont_grayColor
{
    return [UIColor r:47 g:47 b:47 a:1];
}

//类目字体选择颜色
+ (UIColor *)menufont_redColor
{
    return [UIColor r:219 g:59 b:16 a:1];
}

//原价颜色
+ (UIColor *)UnitProduct_oprice_Color
{
    return HexRGB(0xbbbbbb);
}

+ (UIColor *)finishBorderColor
{
#ifdef APP_JP
    return HexRGB(0xacce7e);
#elif APP_JKY
    return HexRGB(0xacce7e);
#elif APP_JPHD
    return HexRGB(0xacce7e);
#elif APP_JKYHD
    return HexRGB(0xed9d87);
#endif
    return HexRGB(0xed9d87);
}

+ (UIColor *)leftMenuColor
{
    return [UIColor r:83 g:94 b:94 a:1];
}

//首页区块占位符底色 3.3.8 add
+ (UIColor *)homeBlockPlaceholderColor
{
    return HexRGB(0xf8f8f8);
}

//商品标题的字体颜色
+ (UIColor *)goodsTitleColor
{
    return HexRGB(0x333333);
}

//0xf2f2f2
+ (UIColor *)grayBG
{
    return HexRGB(0xf4f4f8);
}

+ (UIColor *)menuTitleColor
{
    return HexRGB(0x333333);
}

+ (UIColor *)mainPageTitleColor
{
    return HexRGB(0x333333);
}

+ (UIColor *)upPullFooterTitleColor
{
    return HexRGB(0x666666);
}

//多个cell之间的灰色分割线
+ (UIColor *)graylineColor
{
    return HexRGB(0xebebeb);
}

+ (UIColor *)tmGoodsTitleColor
{
    return HexRGB(0x333333);
}

+ (UIColor *)tmOtherColor
{
    return HexRGB(0x999999);
}

+ (UIColor *)navigationBarBackground
{
    return HexRGB(0xfafafa);
}

+ (UIColor *)addressTextColor
{
    return HexRGB(0x333333);
}

+ (UIColor *)cartGoodsTitleColor
{
    return HexRGB(0x333333);
}

+ (UIColor *)addressTitleColor
{
    return HexRGB(0x999999);
}

+ (UIColor *)cartSKUColor
{
    return HexRGB(0xbbbbbb);
}

+ (UIColor *)tmDetailTextColor
{
    return HexRGB(0x333333);
}

+ (UIColor *)whiteHighlightColor
{
    return HexRGB(0xdbdbdb);
}

+ (UIColor *)allThreeForColor
{
    return HexRGB(0x333333);
}

+ (UIColor *)allThreeForColorWithAlpha:(CGFloat)alpha
{
    return [UIColor colorWithHexRGB:0x333333 alpha:alpha];
}

+ (UIColor *)allSixForColor
{
    return HexRGB(0x666666);
}

+ (UIColor *)allSixForColorWithAlpha:(CGFloat)alpha
{
    return [UIColor colorWithHexRGB:0x666666 alpha:alpha];
}

+ (UIColor *)allNineForColor
{
    return HexRGB(0x999999);
}

+ (UIColor *)allNineForColorWithAlpha:(CGFloat)alpha
{
    return [UIColor colorWithHexRGB:0x999999 alpha:alpha];
}

+ (UIColor *)eggAndbananaForColor
{
    return HexRGB(0xebebeb);
}

+ (UIColor *)eggAndbananaForColorWithAlpha:(CGFloat)alpha
{
    return [UIColor colorWithHexRGB:0xebebeb alpha:alpha];
}

@end
