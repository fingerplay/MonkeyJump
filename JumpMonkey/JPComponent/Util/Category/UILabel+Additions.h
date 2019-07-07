//
//  UILabel+Additions.h
//  Juanpi_2.0
//
//  Created by lee on 14-2-18.
//  Copyright (c) 2014年 Juanpi. All rights reserved.
//

/**
 UILabel类扩展
 **/


#import <UIKit/UIKit.h>

@interface UILabel (Additions)

@property (nonatomic, readonly) CGSize textSize;

+ (UILabel *)labelWithTextColor:(UIColor *)textColor textFont:(UIFont *)textFont;

+ (UILabel *)labelWithTextColor:(UIColor *)textColor
                       textFont:(UIFont *)textFont
                  textAlignment:(NSTextAlignment)alignment;

+ (UILabel *)labelWithTextColor:(UIColor *)textColor
                backgroundColor:(UIColor *)backgroundColor
                       textFont:(UIFont *)textFont
                  textAlignment:(NSTextAlignment)alignment
                   nuberOflines:(NSInteger)lines;


- (void)addalignment:(NSTextAlignment)alignment backgroundColor:(UIColor*)color titleColor:(UIColor*)titleColor labelTag:(NSInteger)tag font:(UIFont *)fontSize;
- (NSDictionary *)attributesWithAlignment:(NSTextAlignment)alignment textColor:(UIColor *)textColor font:(UIFont *)font;
/// 设置富文本
- (CGFloat)setAttrbuteWithFirstString:(NSString *)firstString secondString:(NSString *)secondString firstColor:(UIColor *)firstColor secondColor:(UIColor *)secondColor firstFont:(CGFloat)firstFont secondFont:(CGFloat)secondFont ;
/// 设置富文本
- (CGFloat)setAttrbuteWithFirstString:(NSString *)firstString secondString:(NSString *)secondString firstColor:(UIColor *)firstColor secondColor:(UIColor *)secondColor firstFont:(CGFloat)firstFont secondFont:(CGFloat)secondFont alignment:(NSTextAlignment)alignment;


- (CGSize)textSizeWithLimitWidth:(CGFloat)limitWidth;

- (CGSize)addAotuSizeLabel:(NSString *)label maximumSize:(CGSize)size;
/** 添加跑马灯效果*/
- (void)addPMDEffection:(NSTimeInterval)animationDuration;
/** 移除跑马灯效果*/
- (void)removePMDEffection;

@end
