//
//  NSMutableString+QMExtand.h
//  juanpi3
//
//  Created by Jay on 15-4-22.
//  Copyright (c) 2015年 Jay. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSMutableString (QMExtand)

//=========用于商品曝光===============

/**
 *  如果@",appendStr,"不存在self中,在self后面增加@"appendStr,"
 *
 *  @param appendStr appendStr
 *
 *  @return 是否存在self中,YES/NO
 */
- (BOOL)stringAppendNotExistWithDot:(NSString *)appendStr;

/**
 *  是否存在self中
 *
 *  @param dotStr 字符串@",appendStr,"
 *
 *  @return YES/NO
 */
- (BOOL)isExistWithDot:(NSString *)dotStr;


///**
// *  goods
// *
// *  @param goods 元素为QMUGoods
// *
// *  @return 例如:@"good_id,good_id,good_id"
// */
//- (NSString *)stringGoodsIdWithDot:(NSArray *)goods;

//========================

@end
