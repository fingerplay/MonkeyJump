//
//  QMRequestManager.h
//  juanpi3
//
//  Created by zagger on 15/8/6.
//  Copyright © 2015年 zagger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QMInput.h"
#import "QMCommand.h"
#import "QMRequestConfig.h"
#import "QMRequesterDelegate.h"
#import "BBSafeEX.h"
@class AFHTTPSessionManager;
#define REQUEST_MANAGER [QMRequestManager sharedManager]

typedef NS_ENUM(NSInteger, QMBusinessType) {
    QMBusinessTypeNormal,//正常业务
    QMBusinessTypeStaOne,//埋点统计单个发送
    QMBusinessTypeStaMulti,//埋点统计多个发送
    QMBusinessTypePush,//自建push
    QMBusinessTypeSimple,//外网请求,不带任何公参
};

@protocol AFMultipartFormData;
@class AFHTTPRequestOperation;
@class QMRequester;
@interface QMRequestManager : NSObject
/**
 *  网络请求配置参数
 */
@property (nonatomic,strong)QMRequestConfig *requestConfig;
/**
 *  网络请求所需公参的datasource
 */
@property (nonatomic,weak) id<QMRequesterDatasource> datasource;
@property (nonatomic,weak) id<QMResponseAOPDelegate> aopDelegate;

+ (instancetype)sharedManager;
/**
 *  发起请求
 *
 *  @param command 上传数据请求的相关参数
 *  @param success 请求成功的回调
 *  @param failure 请求失败的回调
 *
 *  @return 请求对应的operation
 */
- (NSURLSessionDataTask *)requestWithCommand:(QMCommand *)command
                                businessType:(QMBusinessType)businessType
                                     success:(void (^)(NSURLSessionDataTask *task, id responseObject, QMInput *input))success
                                     failure:(void (^)(NSURLSessionDataTask *task, NSError *error, QMInput *input))failure;



/**
 *  下载数据
 *
 *  @param command 上传数据请求的相关参数
 *
 *  @return 请求对应的operation
 */
//- (NSOperation *)downloadDataWithCommand:(QMCommand *)command;

-(AFHTTPSessionManager *)downloadDataWithSessionManager;

/** 请求队列中，埋点请求的个数 */
- (NSInteger)statisticsRequestingOperationCount;

/** add Requester */
- (void)addRequester:(QMRequester *)requester;

/** remove Requester */
- (void)removeRequester:(QMRequester *)requester;


//获取动态参数替换列表
- (NSDictionary *)requesterPublicParamsWithParamType:(QMRequestParamType)paramType command:(QMCommand*)command;
//
- (NSString *)requesterUidAbtestStr;
//添加自定义UA
- (NSString *)requesterCommonUserAgent:(NSString *)originUserAgent;
//业务APi请求生成签名
- (NSString *)requesterApisignForParameters:(NSDictionary *)params command:(QMCommand *)command;
//对埋点的内容进行加密
- (NSString *)requesterStatSecretKeyStr:(NSString *)srcString;
//根据参数生成验签字符串,推送专用
- (NSString *)requesterApisignForPushParameters:(NSDictionary *)params;
//根据自定义kye获取自定义url
- (NSString *)requesterCustomUrlWithKey:(NSString *)key;
//请求成功回调
- (void)requester:(QMRequester *)requester handleSuccessAOPWithStatus:(QMStatus *)status dataTask:(NSURLSessionDataTask *)dataTask;
//请求失败回调
- (void)requester:(QMRequester *)requester handleFailedAOPWithStatus:(QMStatus *)status dataTask:(NSURLSessionDataTask *)dataTask;
@end
