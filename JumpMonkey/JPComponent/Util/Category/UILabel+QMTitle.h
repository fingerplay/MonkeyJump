//
//  UILabel+QMTitle.h
//  Jiukuaiyou_2.0
//
//  Created by Brick on 14-4-18.
//  Copyright (c) 2014年 QM. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UILabel (QMTitle)

-(NSMutableAttributedString*)resetAttributeWithString:(NSString*)string color:(UIColor*)color font:(UIFont*)font;
/**
 *  不加/n
 */
-(void)resetAttributeBaoyou;

/**
 *  添加  /n
 */
-(void)resetAttributeNumberBaoyou;

/**
 *  文字顶对齐
 */
-(void)alignToTop;

/**
 *  字体价格样式表
 *
 *  @param oprice 现价
 *  @param ofont  现价字体
 *  @param ocolor 现价颜色
 *  @param cprice 原价
 *  @param cfont  原价字体
 *  @param ccolor 原价颜色
 */
- (void)addWithStringoprice:(NSString *)oprice ofont:(UIFont *)ofont ocolor:(UIColor *)ocolor
                     cprice:(NSString *)cprice cfont:(UIFont *)cfont ccolor:(UIColor *)ccolor;

/**
 *  现价以及原价字符串，赋给label
 *  @param current 现价
 *  @param old  原价
 */
- (void)addCurrentPrice:(NSString *)current OldPrice:(NSString *)old;

/**
 *  返回价格样式表   ¥22.22
 *
 *  @param ofont  字体
 *  @param ocolor 颜色
 *  @param Dfont  ￥的字体
 */
- (void)addWithStringOfont:(UIFont *)ofont ocolor:(UIColor *)ocolor Dfont:(UIFont *)Dfont;
/**
 *  签到的数字
 *
 *  @param ofont 数字的字体大小
 *  @param font  加号的字体大小
 */
- (void)addWithSignIn:(UIFont *)ofont oStr:(NSString *)oStr addFont:(UIFont *)font addStr:(NSString *)addStr;

- (void)addWithContinuousRegistration:(UIFont *)lfont
                               lColor:(UIColor *)lColor
                                 lStr:(NSString *)lStr
                                cFont:(UIFont *)cfont
                               cColor:(UIColor *)cColor
                                 cStr:(NSString *)cStr
                                rFont:(UIFont *)rfont
                               rColor:(UIColor *)rColor
                                 rStr:(NSString *)rStr;

/**
 *  连续签到的数字
 *
 *  @param lfont 左边的字体大小
 *  @param lStr  左边的字符
 *  @param cfont 中间的字体大小
 *  @param cStr  中间的字符
 *  @param rfont 右边的字体大小
 *  @param rStr  右边的字符
 */
- (void)addWithContinuousRegistration:(UIFont *)lfont
                                 lStr:(NSString *)lStr
                                cFont:(UIFont *)cfont
                                 cStr:(NSString *)cStr
                                rFont:(UIFont *)rfont
                                 rStr:(NSString *)rStr;

- (void)addWithContinuousRegistrationArray:(NSArray *)dic;
/**
 *  返回文字宽高
 */
- (CGSize)getSize;

/**
 *  添加带下划线的string
 */
- (void)addStrikethroughStyleString:(NSString *)string;

@end
