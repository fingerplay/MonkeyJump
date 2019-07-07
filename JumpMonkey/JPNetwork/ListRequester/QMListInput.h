//
//  QMListInput.h
//  juanpi3
//
//  Created by Jay on 15/8/10.
//  Copyright (c) 2015年 Jay. All rights reserved.
//


/**
 *  请求List的基类
 */

#import "QMInput.h"


@interface QMListInput : QMInput

/**
 *  当前的页面,默认是0，每次调用loadNextPage会加1
 */
@property (nonatomic, assign) NSUInteger page;

@end
