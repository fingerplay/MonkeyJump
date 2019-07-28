//
//  QMRequestManager.m
//  juanpi3
//
//  Created by zagger on 15/8/6.
//  Copyright © 2015年 zagger. All rights reserved.
//

#import "QMRequestManager.h"
#import "QMReqLogger.h"
#import "QMNormalRequestFactory.h"
#ifndef TODAY_EXTENSION
#import "QMStatisticsRequestFactory.h"
#endif
#import "QMPushRequestFactory.h"
#import "QMSimpleRequestFactory.h"
#import "AFSecurityPolicy.h"
#import "AFHTTPSessionManager.h"
#import "QMRequester.h"

#define iOS9Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)

@interface QMRequestManager ()

/** OperationManager */
@property (nonatomic, strong) AFHTTPSessionManager *requestSessionManager;

/** 埋点:单条数据OperationManager */
@property (nonatomic, strong) AFHTTPSessionManager *staSessionManager;

/** 埋点:多条数据OperationManager */
@property (nonatomic, strong) AFHTTPSessionManager *staMultiSessionManager;

/** 当前请求的requester */
@property (nonatomic, strong) NSMutableDictionary *requestersRecord;

@property (nonatomic, strong) AFHTTPSessionManager *downloadSessionManager;

@end

@implementation QMRequestManager

#pragma mark - Lifecycle

+ (instancetype)sharedManager {
    static QMRequestManager *__manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __manager = [[QMRequestManager alloc] init];
    });
    return __manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _requestersRecord = [NSMutableDictionary dictionary];
    }
    return self;
}
#pragma mark - Private Methods

- (NSString *)requestHashKey:(QMRequester *)requester {
    NSString *key = [NSString stringWithFormat:@"%lu", (unsigned long)[requester hash]];
    return key;
}

- (void)addRequester:(QMRequester *)requester {
    if (requester) {
        NSString *key = [self requestHashKey:requester];
        @synchronized(self) {
            [_requestersRecord safeSetObject:requester forKey:key];
        }
    }
//    NSLog(@"addRequester = %lu %@", (unsigned long)[_requestersRecord count], requester.class);
}

- (void)removeRequester:(QMRequester *)requester {
    NSString *key = [self requestHashKey:requester];
    @synchronized(self) {
        [_requestersRecord removeObjectForKey:key];
    }
//    NSLog(@"removeRequester = %lu %@", (unsigned long)[_requestersRecord count], requester.class);
}


#pragma mark - Requests
- (NSURLSessionDataTask *)requestWithCommand:(QMCommand *)command
                       businessType:(QMBusinessType)businessType
                            success:(void (^)(NSURLSessionDataTask *task, id responseObject, QMInput *input))success
                            failure:(void (^)(NSURLSessionDataTask *task, NSError *error, QMInput *input))failure {
    
    NSURLSessionDataTask *dataTask = nil;
    self.requestSessionManager.requestSerializer.timeoutInterval = command.timeoutInterval;//重置超时时间
    
    if (businessType == QMBusinessTypeNormal) {
        [self operationManagerSecurityPolicy:self.requestSessionManager httpType:command.httpType];
        dataTask = [self normaldataTaskWithCommand:command success:success failure:failure];
    }
#ifndef TODAY_EXTENSION
    else if (businessType == QMBusinessTypeStaOne) {
        [self operationManagerSecurityPolicy:self.staSessionManager httpType:command.httpType];
        dataTask = [self statisticsdataTaskWithCommand:command operationManager:self.staSessionManager success:success failure:failure];
    }
    else if (businessType == QMBusinessTypeStaMulti) {
        [self operationManagerSecurityPolicy:self.staMultiSessionManager httpType:command.httpType];
        dataTask = [self statisticsdataTaskWithCommand:command operationManager:self.staMultiSessionManager success:success failure:failure];
    }
#endif
    else if (businessType == QMBusinessTypePush) {
        [self operationManagerSecurityPolicy:self.requestSessionManager httpType:command.httpType];
        dataTask = [self pushdataTaskWithCommand:command success:success failure:failure];
    }
    else if (businessType == QMBusinessTypeSimple) {
        [self operationManagerSecurityPolicy:self.requestSessionManager httpType:command.httpType];
        dataTask = [self simpledataTaskWithCommand:command success:success failure:failure];
    }
    if (iOS9Later) {
        if (command.priority==QMRequestPriorityLow){
            dataTask.priority = NSURLSessionTaskPriorityLow;
        }else if (command.priority==QMRequestPriorityHigh){
            dataTask.priority = NSURLSessionTaskPriorityHigh;
        }else{
            dataTask.priority = NSURLSessionTaskPriorityDefault;
        }
    }
    dataTask.startDate = [NSDate date];
    return dataTask;
}


-(void)operationManagerSecurityPolicy:(AFHTTPSessionManager *)sessionManager httpType:(QMHTTPType)httpType{

    if (httpType == QMHTTPType_HTTPS) {
        
        AFSecurityPolicy *httpsSecurityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
//#ifdef DEBUG
//        httpsSecurityPolicy.allowInvalidCertificates = YES; //开发模式下不验证证书，方便开发抓包
//#else
//        if ([self.requestConfig.utm isEqualToString:@"103524"]) {
//            httpsSecurityPolicy.allowInvalidCertificates = YES; //103524渠道不验证证书，方便测试抓包
//        } else {
            httpsSecurityPolicy.allowInvalidCertificates = NO;
//        }
//#endif
        httpsSecurityPolicy.validatesDomainName = YES;
        sessionManager.securityPolicy = httpsSecurityPolicy;
    }
    else {
        sessionManager.securityPolicy = [AFSecurityPolicy defaultPolicy];;
    }
}


-(AFHTTPSessionManager *)downloadDataWithSessionManager{
    
    return self.downloadSessionManager;
}

- (NSInteger)statisticsRequestingOperationCount {
    return self.staMultiSessionManager.operationQueue.operationCount;
}


#pragma mark - operations
- (NSURLSessionDataTask *)normaldataTaskWithCommand:(QMCommand *)command
                                               success:(void (^)(NSURLSessionDataTask *task, id responseObject, QMInput *input))success
                                               failure:(void (^)(NSURLSessionDataTask *task, NSError *error, QMInput *input))failure {
    __block QMInput *bInput = command.input;
    NSURLSessionDataTask *dataTask = [QMNormalRequestFactory  dataTaskWithCommand:command
                                                                              manager:self.requestSessionManager
                                                                              success:^(NSURLSessionDataTask *task, id responseObject) {
                                                                                  [QMReqLogger logResponseWithDataTask:task responseObject:responseObject error:nil];
                                                                                  
                                                                                  if (success) {
                                                                                      success(task, responseObject, bInput);
                                                                                  }
                                                                              }
                                                                              failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                                                  [QMReqLogger logResponseWithDataTask:task responseObject:nil error:error];
                                                                                  
                                                                                  if (failure) {
                                                                                      failure(task, error, bInput);
                                                                                  }
                                                                              }];
    
    
    return dataTask;
}
#ifndef TODAY_EXTENSION
- (NSURLSessionDataTask *)statisticsdataTaskWithCommand:(QMCommand *)command
                                          operationManager:(AFHTTPSessionManager *)sessionManager
                                                   success:(void (^)(NSURLSessionDataTask *task, id responseObject, QMInput *input))success
                                                   failure:(void (^)(NSURLSessionDataTask *task, NSError *error, QMInput *input))failure {
    __block QMInput *bInput = command.input;
     NSURLSessionDataTask *dataTask = [QMStatisticsRequestFactory dataTaskWithCommand:command
                                                                                 manager:sessionManager
                                                                                 success:^(NSURLSessionDataTask *task, id responseObject) {
                                                                                     if (success) {
                                                                                         success(task, responseObject, bInput);
                                                                                     }
                                                                                 }
                                                                                 failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                                                     if (failure) {
                                                                                         failure(task, error, bInput);
                                                                                     }
                                                                                 }];
    return dataTask;
}
#endif

- (NSURLSessionDataTask *)pushdataTaskWithCommand:(QMCommand *)command
                                             success:(void (^)(NSURLSessionDataTask *task, id responseObject, QMInput *input))success
                                             failure:(void (^)(NSURLSessionDataTask *task, NSError *error, QMInput *input))failure {
    __block QMInput *bInput = command.input;
     NSURLSessionDataTask *dataTask = [QMPushRequestFactory dataTaskWithCommand:command
                                                                           manager:self.requestSessionManager
                                                                           success:^(NSURLSessionDataTask *task, id responseObject) {
                                                                               [QMReqLogger logResponseWithDataTask:task responseObject:responseObject error:nil];
                                                                               if (success) {
                                                                                   success(task, responseObject, bInput);
                                                                               }
                                                                           }
                                                                           failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                                               [QMReqLogger logResponseWithDataTask:task responseObject:nil error:error];
                                                                               if (failure) {
                                                                                   failure(task, error, bInput);
                                                                               }
                                                                           }];

    return dataTask;
}

- (NSURLSessionDataTask *)simpledataTaskWithCommand:(QMCommand *)command
                                             success:(void (^)(NSURLSessionDataTask *task, id responseObject, QMInput *input))success
                                             failure:(void (^)(NSURLSessionDataTask *task, NSError *error, QMInput *input))failure {
    __block QMInput *bInput = command.input;
     NSURLSessionDataTask *dataTask = [QMSimpleRequestFactory dataTaskWithCommand:command
                                                                           manager:self.requestSessionManager
                                                                           success:^(NSURLSessionDataTask *task, id responseObject) {
                                                                               [QMReqLogger logResponseWithDataTask:task responseObject:responseObject error:nil];
                                                                               if (success) {
                                                                                   success(task, responseObject, bInput);
                                                                               }
                                                                           }
                                                                           failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                                               [QMReqLogger logResponseWithDataTask:task responseObject:nil error:error];
                                                                               if (failure) {
                                                                                   failure(task, error, bInput);
                                                                               }
                                                                           }];
    return dataTask;
}


#pragma mark - Properties
- (AFHTTPSessionManager *)requestSessionManager {
    if (!_requestSessionManager) {
        _requestSessionManager = [self generalManager];
    }
    return _requestSessionManager;
}


- (AFHTTPSessionManager *)staSessionManager {
    if (!_staSessionManager) {
        _staSessionManager = [self generalManager];
        _staSessionManager.session.configuration.HTTPMaximumConnectionsPerHost = self.requestConfig.staMaxConcurrentOperationCount;
    }
    return _staSessionManager;
}

- (AFHTTPSessionManager *)staMultiSessionManager {
    if (!_staMultiSessionManager) {
        _staMultiSessionManager = [self generalManager];
        _staMultiSessionManager.session.configuration.HTTPMaximumConnectionsPerHost = self.requestConfig.staMaxConcurrentOperationCount;
    }
    return _staMultiSessionManager;
}


-(AFHTTPSessionManager *)downloadSessionManager{
    if (!_downloadSessionManager) {
        _downloadSessionManager = [self generalManager];
    }
    return _downloadSessionManager;
}

- (AFHTTPSessionManager *)generalManager {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.session.configuration.HTTPMaximumConnectionsPerHost = self.requestConfig.normalMaxConcurrentOperationCount;//同一时间最多允许10个请求并发
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;

    AFJSONResponseSerializer *responseSerializer = (AFJSONResponseSerializer *)manager.responseSerializer;
    responseSerializer.removesKeysWithNullValues = YES;//移除返回数据中的NSNull对象
    
    //增加一个contentTypes
    NSMutableSet *contentTypes = [NSMutableSet setWithSet:manager.responseSerializer.acceptableContentTypes];
    [contentTypes addObject:@"text/html"];
    [contentTypes addObject:@"text/plain"];
    [contentTypes addObject:@"application/octet-stream"];//pb需要
    manager.responseSerializer.acceptableContentTypes = contentTypes;
    
    return manager;
}


//获取动态参数列表
- (NSDictionary *)requesterPublicParamsWithParamType:(QMRequestParamType)paramType{
    if (self.datasource && [self.datasource respondsToSelector:@selector(requesterPublicParamsWithParamType:)]) {
        return [self.datasource requesterPublicParamsWithParamType:paramType];
    }
    return [NSDictionary dictionary];
}

- (NSString *)requesterUidAbtestStr{
    if (self.datasource && [self.datasource respondsToSelector:@selector(requesterUidAbtestStr)]) {
        return [self.datasource requesterUidAbtestStr];
    }
    return nil;
}
- (NSString *)requesterCommonUserAgent:(NSString *)originUserAgent{
    if (self.datasource && [self.datasource respondsToSelector:@selector(requesterCommonUserAgent:)]) {
        return [self.datasource requesterCommonUserAgent:originUserAgent];
    }
    return originUserAgent;
}

- (NSString *)requesterApisignForParameters:(NSDictionary *)params command:(QMCommand *)command{
    if (self.datasource && [self.datasource respondsToSelector:@selector(requesterApisignForParameters:command:)]) {
        return [self.datasource requesterApisignForParameters:params command:command];
    }
    return nil;
}

- (NSString *)requesterStatSecretKeyStr:(NSString *)srcString{
    if (self.datasource && [self.datasource respondsToSelector:@selector(requesterStatSecretKeyStr:)]) {
        return [self.datasource requesterStatSecretKeyStr:srcString];
    }
    return nil;
}
//根据参数生成验签字符串,推送专用
- (NSString *)requesterApisignForPushParameters:(NSDictionary *)params{
    if (self.datasource && [self.datasource respondsToSelector:@selector(requesterApisignForPushParameters:)]) {
        return [self.datasource requesterApisignForPushParameters:params];
    }
    return nil;
}
//根据自定义kye获取自定义url
- (NSString *)requesterCustomUrlWithKey:(NSString *)key{
    if (self.datasource && [self.datasource respondsToSelector:@selector(requesterCustomUrlWithKey:)]) {
        return [self.datasource requesterCustomUrlWithKey:key];
    }
    return nil;
}
//请求成功回调
- (void)requester:(QMRequester *)requester handleSuccessAOPWithStatus:(QMStatus *)status dataTask:(NSURLSessionDataTask *)dataTask{
    if (self.aopDelegate && [self.aopDelegate respondsToSelector:@selector(requester:handleSuccessAOPWithStatus:dataTask:)]) {
        [self.aopDelegate requester:requester handleSuccessAOPWithStatus:status dataTask:dataTask];
    }
}
//请求失败回调
- (void)requester:(QMRequester *)requester handleFailedAOPWithStatus:(QMStatus *)status dataTask:(NSURLSessionDataTask *)dataTask{
    if (self.aopDelegate && [self.aopDelegate respondsToSelector:@selector(requester:handleFailedAOPWithStatus:dataTask:)]) {
        [self.aopDelegate requester:requester handleFailedAOPWithStatus:status dataTask:dataTask];
    }
}
@end
