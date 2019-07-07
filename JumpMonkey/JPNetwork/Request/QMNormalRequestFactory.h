//
//  QMNormalRequestFactory.h
//  juanpi3
//
//  Created by zagger on 15/9/9.
//  Copyright (c) 2015年 zagger. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 正常业务网络请求,包含公参、验签、post添加get参数、所有get参数加"n_"前缀等处理
#import "QMBaseRequestFactory.h"
@interface QMNormalRequestFactory : QMBaseRequestFactory
@end
