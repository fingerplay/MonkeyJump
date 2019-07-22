//
//  UIColor+CustomColor.h
//  Juanpi
//
//  Created by luoyi on 13-12-31.
//  Copyright (c) 2013年 Juanpi. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RGB(r, g, b)             [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]
#define RGBAlpha(r, g, b, a)     [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:(a)]

#define HexRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define HexRGBAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

// color congfig
#define BLOCK_SEPARATOR_COLOR HexRGB(0xebebeb) //模块广告 分割线颜色

@interface UIColor (CustomColor)

#pragma mark - 16进制颜色获取

/**
 * 根据字符串转换成对应的颜色
 */
+ (UIColor *)colorWithHexString:(NSString *)hex;

/**
 *  根据16进制RGB值，获取UIColor
 *
 */

+ (UIColor *)colorWithHexRGB:(NSInteger)rgbValue;
+ (UIColor *)colorWithHexRGB:(NSInteger)rgbValue alpha:(CGFloat)alpha;



#pragma mark - 总体风格
+ (UIColor *)appStyleColor;
+ (UIColor *)appStyleColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)navigationBarBackground;

+ (UIColor *)globalBuyColor;

#pragma mark - 按钮颜色
/*
 *  灰色圆角按钮颜色
 *
 *  @return UIColor
 */
+(UIColor *)button_grayColor;

/*
 *  绿色圆角按钮颜色
 *
 *  @return UIColor
 */
+(UIColor *)button_greenColor;

/*
 *  红色圆角按钮颜色
 *
 *  @return UIColor
 */
+(UIColor *)button_redColor;

/**
 *  红色按钮高亮状态颜色
 *
 *  @return UIColor
 */
+ (UIColor *)button_redColorHighlight;




#pragma mark - 其他
+(UIColor*)homePage_background;
/**
 *  价格 灰色颜色
 *
 *  @return UIColor
 */
+(UIColor *)priGrayColor;

/**
 *  新普通ProductViewCell颜色
 *
 *  @return UIColor
 */
+(UIColor*)statue_unstart_NewProductViewCell;



/*
 *  类目背景颜色
 *
 *  @return UIColor
 */
+(UIColor *)menu_grayColor;

/*
 *  类目字体颜色
 *
 *  @return UIColor
 */
+(UIColor *)menufont_grayColor;

/*
 *  类目字体选择颜色
 *
 *  @return UIColor
 */
+(UIColor *)menufont_redColor;

/*
 *  原价颜色
 *
 *  @return UIColor
 */
+ (UIColor *)UnitProduct_oprice_Color;

+ (UIColor *)finishBorderColor;

+ (UIColor *)leftMenuColor;

/*
 *  首页区块占位符底色
 *  @return UIColor
 */
+ (UIColor *)homeBlockPlaceholderColor;

/*
 *  商品标题的字体颜色
 *  @return UIColor
 */
+ (UIColor *)goodsTitleColor;

/**
 *  灰色背景颜色
 */
+ (UIColor *)grayBG;

/**
 *  0x666666
 *
 *  @return UIColor
 */
+ (UIColor *)menuTitleColor;

/**
 *  首页Tab title颜色
 *  0x333333
 *  @return UIColor
 */
+ (UIColor *)mainPageTitleColor;

/**
 *  上拉切换到XXX title颜色
 *  0x666666
 *  @return UIColor
 */
+ (UIColor *)upPullFooterTitleColor;

/** 分割线颜色 */
+ (UIColor *)graylineColor;


/**
 *  特卖的商品标题等深的颜色，为0x333333
 */
+ (UIColor *)tmGoodsTitleColor;

/**
 *  特卖的其它标题的浅的颜色，为0x999999
 */
+ (UIColor *)tmOtherColor;

/**
 *  红色按钮高亮颜色
 *
 *  @param alpha 透明度
 *
 *  @return  UIColor
 */
+ (UIColor *)button_redColorHighlightWithAlpha:(CGFloat)alpha;

/**
 *  收货地址每一项的内容颜色
 *
 *  @return UIColor
 */
+ (UIColor *)addressTextColor;

/**
 *  收货地址每一项的标题颜色
 *
 *  @return UIColor
 */
+ (UIColor *)addressTitleColor;

/**
 *  购物车的商品标题等深的颜色，为0x4a4a4a
 */
+ (UIColor *)cartGoodsTitleColor;

/**
 *  购物车的SKU以及原价等浅的颜色，为0xbbbbbb
 */
+ (UIColor *)cartSKUColor;

+ (UIColor *)tmDetailTextColor;

/**
 *  白色区域点击的高亮颜色
 */
+ (UIColor *)whiteHighlightColor;


/**
 * 色值为0x333333
 */
+ (UIColor *)allThreeForColor;


/**
 * 色值为0x333333(含透明度)
 */
+ (UIColor *)allThreeForColorWithAlpha:(CGFloat)alpha;

/**
 * 色值为0x666666
 */
+ (UIColor *)allSixForColor;

/**
 * 色值为0x666666(含透明度)
 */
+ (UIColor *)allSixForColorWithAlpha:(CGFloat)alpha;

/**
 * 色值为0x999999
 */
+ (UIColor *)allNineForColor;

/**
 * 色值为0x999999(含透明度)
 */
+ (UIColor *)allNineForColorWithAlpha:(CGFloat)alpha;

/**
 * 色值为0xebebeb
 */
+ (UIColor *)eggAndbananaForColor;

/**
 * 色值为0xebebeb(含透明度)
 */
+ (UIColor *)eggAndbananaForColorWithAlpha:(CGFloat)alpha;

@end
