//
//  QMRequesterCode.h
//  juanpi3
//
//  Created by Jay on 16/5/16.
//  Copyright © 2016年 Jay. All rights reserved.
//

#ifndef QMRequesterCode_h
#define QMRequesterCode_h


static NSInteger const ERROR_CODE_SUCCESS = 0;
static NSInteger const ERROR_CODE_INSERT_FAILED = 1;  // 数据更新失败
static NSInteger const ERROR_CODE_REQUEST_DATA_ERROR = 2;  // 请求数据格式错误
static NSInteger const ERROR_CODE_NO_DATA = 3;  // 数据库中查不到数据
static NSInteger const ERROR_CODE_NO_NEED_UPDATE = 4;  // 无需更新数据
static NSInteger const ERROR_CODE_UNKNOWN = 5;  // 未知错误
static NSInteger const ERROR_CODE_REQUEST_DATA_VALUE_ERROR = 6;  // 请求数据值错误
static NSInteger const ERROR_CODE_NO_LOGIN_ERROR = 7;  // 尚未登录
static NSInteger const ERROR_CODE_SIGN_ERROR = 8;  // 非法访问
static NSInteger const ERROR_CODE_CODEC_ERROR = 9;  // 编解码错误
static NSInteger const ERROR_CODE_SAME_NAME = 10;  // 该姓名已被使用
static NSInteger const ERROR_CODE_PASSWORD_ERROR = 11;  // 密码错误


#endif /* QMRequesterCode_h */
