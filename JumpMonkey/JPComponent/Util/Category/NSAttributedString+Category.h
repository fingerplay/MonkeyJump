//
//  NSAttributedString+Category.h
//  juanpi3
//
//  Created by 苏金辉 on 16/3/23.
//  Copyright © 2016年 苏金辉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSAttributedString (Category)

/**
 *  获取属性字符串高度
 *
 *  @param width 宽度
 *
 *  @retun 高度
 */
- (CGFloat)getHeightWithWidth:(CGFloat)width;

@end
