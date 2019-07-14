//
//  QMNetException.h
//  juanpi3
//
//  Created by zagger on 15/8/6.
//  Copyright © 2015年 zagger. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, QMNetErrorType) {
    QMNetErrorTypeUndefined,
    QMNetErrorTypeUncollected,//无网——提示设置网络页面；
    QMNetErrorTypeTimeout,//有网，但无数据返回（超时）；
    QMNetErrorTypeService,//有网，服务器问题（非200）；
    QMNetErrorTypeNoData,//有网，服务器（200）。
    QMNetErrorTypeServiceUnable// 有网，服务器维护状态
};

/**
 *  保存api请求返回的基本信息，包括状态码，info字段，网请求错误类型等
 */
@interface QMStatus : NSObject

/** 用operation来初始化，相关信息会从operation中取得 */
- (instancetype)initWithSessionTask:(NSURLSessionDataTask *)task responseObject:(NSDictionary *)responseObject;

/** 网络请求的状态 */
@property (nonatomic, assign) NSInteger code;

/** 网络请求错误类型 */
@property (nonatomic, assign) QMNetErrorType errorType;

/** 错误信息,少数情况下也可能不是错误信息，而是一些提示信息，统一在此处理 */
@property (nonatomic, copy) NSString *info;

@property (nonatomic, strong) NSDictionary *responseHeader;
/** 请求耗时*/
@property (nonatomic, assign) NSTimeInterval timeDuring;

@end
