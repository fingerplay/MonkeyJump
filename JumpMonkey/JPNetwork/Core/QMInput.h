//
//  QMInput.h
//  juanpi3
//
//  Created by zagger on 15/8/7.
//  Copyright © 2015年 zagger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+Json.h"

/** 请求参数的基类 */
@interface QMInput : NSObject
@property (nonatomic, strong) NSMutableArray *data;
@end
