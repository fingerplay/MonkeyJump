//
//  QMRequester.m
//  juanpi3
//
//  Created by zagger on 15/8/6.
//  Copyright © 2015年 zagger. All rights reserved.
//

#import "QMRequester.h"
#import "QMRequesterDelegate.h"
#import "QMRequesterPrivate.h"
#import "MJExtension.h"
#ifndef TODAY_EXTENSION
#import "QMReqCacheManager.h"
#endif
#import "NSString+QMRequest.h"
#import "AFNetworkReachabilityManager.h"

@interface QMRequester ()
{
    NSMutableArray *_requestOperations;
}

@property (nonatomic, copy) void (^rnRequestCallBack)(NSString *response);

@end

@implementation QMRequester

#pragma mark - LifeCycle
- (void)dealloc {
    [self cancalAllRequest];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        //初始化相关参数
    }
    return self;
}

#pragma mark - Request
- (void)startRequestWithCommand:(QMCommand *)command {
    
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *dataTask = [REQUEST_MANAGER requestWithCommand:command
                                                    businessType:self.businessType
                                                         success:^(NSURLSessionDataTask *task, id responseObject, QMInput *input) {
                                                             __strong typeof(weakSelf) strongSelf = weakSelf;
                                                             [strongSelf handleSuccWithDataTask:task response:responseObject command:command];
                                                             //请求执行成功以后，从requestOperations里面移除
                                                             @synchronized(self.requestOperations) {
                                                                 [strongSelf.requestOperations removeObject:task];
                                                             }
                                                             
                                                             [REQUEST_MANAGER removeRequester:strongSelf];
                                                         }
                                                         failure:^(NSURLSessionDataTask *task, NSError *error, QMInput *input) {
                                                             __strong typeof(weakSelf) strongSelf = weakSelf;
                                                             
                                                             if (task.state != NSURLSessionTaskStateCanceling) {
                                                                 [strongSelf handleFailWithDataTask:task error:error command:command];
                                                             }else {
                                                                 [strongSelf handleCancelWithDataTask:task error:error command:command];
                                                             }
                                                             //请求撤销或者执行失败以后，从requestOperations里面移除
                                                             @synchronized(self.requestOperations) {
                                                                 [strongSelf.requestOperations removeObject:task];
                                                             }
                                                             
                                                             [REQUEST_MANAGER removeRequester:strongSelf];
                                                         }];
    
    [dataTask resume];
    
    @synchronized(self.requestOperations) {
        [self.requestOperations safeAddObject:dataTask];
    }

    [REQUEST_MANAGER addRequester:self];
}

- (void)handleSuccWithDataTask:(NSURLSessionDataTask*)task response:(id)responseObject command:(QMCommand *)command {
    
    QMStatus *status = [[QMStatus alloc] initWithSessionTask:task responseObject:responseObject];
    id dataObject = responseObject;
    
    [self cacheResponse:dataObject forCommand:command status:status];//处理缓存
    id output = [self reformDataWithResponseObject:dataObject command:command status:status];
    if (status.code == ERROR_CODE_SUCCESS) {
        if (self.succCallback) {
            self.succCallback(status,command.input,output);
        } else {
            [self requestSuccess:status output:output input:command.input];
        }
        
        if (self.rnRequestCallBack) {
            NSInteger httpCode  = [(NSHTTPURLResponse *)task.response statusCode];
            if ([dataObject isKindOfClass:[NSDictionary class]]) {
                NSMutableDictionary *mulDic = [NSMutableDictionary dictionaryWithDictionary:dataObject];
                [mulDic setObject:@(httpCode) forKey:@"httpCode"];
                dataObject = mulDic;
            }
            self.rnRequestCallBack(((NSObject *)dataObject).mj_JSONString);
        }
        [REQUEST_MANAGER requester:self handleSuccessAOPWithStatus:status dataTask:task];
    }else {
        if (self.failCallback) {
            self.failCallback(status,command.input,nil);
        } else {
            [self requestFailed:status input:command.input error:nil];
        }
        
        if (self.rnRequestCallBack) {
            BOOL hasNetwork = [AFNetworkReachabilityManager sharedManager].reachable;
            NSInteger httpCode  = [(NSHTTPURLResponse *)task.response statusCode];
            NSMutableDictionary *mulDic = [NSMutableDictionary dictionary];
            [mulDic setObject:@(httpCode) forKey:@"httpCode"];
            [mulDic setObject:@(hasNetwork) forKey:@"hasNetwork"];
            self.rnRequestCallBack(mulDic.mj_JSONString);
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_EndRefreshWhenNoNetwork object:nil];
        [REQUEST_MANAGER requester:self handleFailedAOPWithStatus:status dataTask:task];
    }
   
}

- (void)handleFailWithDataTask:(NSURLSessionDataTask*)task error:(NSError *)error command:(QMCommand *)command{
    QMStatus *status = [[QMStatus alloc] initWithSessionTask:task responseObject:nil];
//生成异常情况一个实例，保存异常信息，空态请求出错等。
#ifndef TODAY_EXTENSION
    //断网时部分api使用本地缓存
    if (self.useNetUnavailableCache && ![REQUEST_MANAGER.requestConfig.canPingJuanpi boolValue]) {
        id responseObject = [REQ_CACHE_MANAGER cachedHTTPResponseForCommand:command.identifier];
        if (responseObject) {
            status.code = ERROR_CODE_SUCCESS;
            
            //解析data，得到业务数据
            id output = [self reformDataWithResponseObject:responseObject command:command status:status];
            if (self.succCallback) {
                self.succCallback(status,command.input,output);
            } else {
                [self requestSuccess:status output:output input:command.input];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_BeginRefreshWhenNoNetwork object:nil];
            return;
        }
    }
#endif
    
    if (self.failCallback) {
        self.failCallback(status,command.input,error);
    } else {
        [self requestFailed:status input:command.input error:error];
    }
    
    if (self.rnRequestCallBack) {
        BOOL hasNetwork = [AFNetworkReachabilityManager sharedManager].reachable;
        NSInteger httpCode  = [(NSHTTPURLResponse *)task.response statusCode];
        NSMutableDictionary *mulDic = [NSMutableDictionary dictionary];
        [mulDic setObject:@(httpCode) forKey:@"httpCode"];
        [mulDic setObject:@(hasNetwork) forKey:@"hasNetwork"];
        self.rnRequestCallBack(mulDic.mj_JSONString);
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_EndRefreshWhenNoNetwork object:nil];
    [REQUEST_MANAGER requester:self handleFailedAOPWithStatus:status dataTask:task];
}

- (void)handleCancelWithDataTask:(NSURLSessionDataTask*)task error:(NSError *)error command:(QMCommand *)command {
    QMStatus *status = [[QMStatus alloc] initWithSessionTask:task responseObject:nil];//生成异常情况一个实例，保存异常信息，空态请求出错等。
    [self requestCancel:status input:command.input error:error];
}


- (id)reformDataWithResponseObject:(id)responseObject command:(QMCommand *)command status:(QMStatus *)status {
    if (command.dataType == QMDataTypeJson) {
//        if (self.businessType == QMBusinessTypeStaOne ||
//            self.businessType == QMBusinessTypeStaMulti ||
//            self.businessType == QMBusinessTypeSimple) {
        
            return [self reformJsonData:responseObject withStatus:status];
//        } else {
//            if ([responseObject respondsToSelector:@selector(objectForKey:)]) {
//                return [self reformJsonData:[responseObject objectForKey:@"data"] withStatus:status];
//            }
//        }
    }
    else if (command.dataType == QMDataTypeProtocolBuffer) {
        return [self reformProtoBufferData:responseObject status:status];
    }
    
    return nil;
}



#pragma mark - Cache
- (void)cacheResponse:(NSDictionary *)responseObject forCommand:(QMCommand *)command status:(QMStatus *)status {
    if (status.code == ERROR_CODE_SUCCESS || command.dataType == QMDataTypeProtocolBuffer) {
#ifndef TODAY_EXTENSION
        //请求成功后根据需要缓存数据
        if (self.useNetUnavailableCache) {
            [REQ_CACHE_MANAGER cacheObject:responseObject forCommand:command.identifier];
        }
#endif
    }
}


#pragma mark - ParamConstructor(Inherritable)
- (void)configCommand:(QMCommand *)command {
    
}

- (void)addRnCommandConfigIfNeed:(QMCommand *)command{
    if (self.rnCommandConfig.url.length) {
        command.url = self.rnCommandConfig.url;
        command.method = self.rnCommandConfig.method;
        command.rnParams = self.rnCommandConfig.rnParams;
    }
}

- (QMInput *)buildInput {
    return nil;
}

- (NSData *)buildProtocolBufferData {
    return nil;
}

#pragma mark - Reformer(Inherritable)
- (id)reformJsonData:(id)data {
    //解析data，得到业务数据，保存到requester的属性里面
    return data;
}

- (id)reformJsonData:(id)data withStatus:(QMStatus *)status {
    //默认使用原来的reformJsonData方法，需要用到status的自己重载该方法
    return [self reformJsonData:data];
}

- (id)reformProtoBufferData:(id)pbData status:(QMStatus *)status {
    //解析data，得到业务数据，保存到requester的属性里面
    return pbData;
}

- (void)requestSuccess:(QMStatus *)status output:(id)output input:(QMInput *)input {
    //子类重载
    
    if ([self.delegate respondsToSelector:@selector(requester:successWithStatus:input:output:)]) {
        [self.delegate requester:self successWithStatus:status input:input output:output];
    }
}

- (void)requestFailed:(QMStatus *)status input:(QMInput *)input error:(NSError *)error {
    //子类重载
    
    if ([self.delegate respondsToSelector:@selector(requester:failedWithStatus:input:error:)]) {
        [self.delegate requester:self failedWithStatus:status input:input error:error];
    }
}
- (void)requestCancel:(QMStatus *)status input:(QMInput *)input error:(NSError *)error {
    //子类重载
    
    if ([self.delegate respondsToSelector:@selector(requester:cancelWithStatus:input:error:)]) {
        [self.delegate requester:self cancelWithStatus:status input:input error:error];
    }
}



#pragma mark - Public
- (void)startRequest {
    QMInput *input = [self buildInput];
    QMCommand *command = [self commandWithInput:input];
    if (command.dataType == QMDataTypeProtocolBuffer) {
        command.pbData = [self buildProtocolBufferData];
    }
    [self startRequestWithCommand:command];
}

- (void)startRequestWithSuccCallback:(QMRequesterSuccCallback)succCallback failCallback:(QMRequesterFailCallback)failCallback {
    self.succCallback = succCallback;
    self.failCallback = failCallback;
    [self startRequest];
}

- (void)startRNRequestCompletion:(void(^)(NSString *response))completion
{
    self.rnRequestCallBack = [completion copy];
    [self startRequest];
}

- (void)cancalAllRequest {
    for (NSURLSessionTask *task in self.requestOperations) {
        [task cancel];
    }
}

#pragma mark - Private
- (QMCommand *)commandWithInput:(QMInput *)input {
    QMCommand *command = [QMCommand buildCommandWithInput:input];
    [self configCommand:command];
    [self addRnCommandConfigIfNeed:command];
    if (self.customUrl.length > 0) {
        command.url = self.customUrl;
    }else{
        NSString *dynamicUrl = [self generateDynamicUrl:command.url];
        if (dynamicUrl.length>0) {
            command.url = dynamicUrl;
        }
    }
    if (self.customParamsDict) {
        command.customParamsDict = self.customParamsDict;
    }
    self.staFunUrl = command.url;
    return command;
}

#pragma mark - 动态key规则生成获取动态URL http://wiki.juanpi.org/pages/viewpage.action?pageId=21636796
-(NSString *)generateDynamicUrl:(NSString *)requestUrl{
    NSString *dynamicKey = [requestUrl generateDynamicKey];
    NSString *dynamicUrl = nil;
    if (dynamicKey && dynamicKey.length) {
        dynamicUrl = [REQUEST_MANAGER requesterCustomUrlWithKey:dynamicKey];
    }
    return dynamicUrl;
}


#pragma mark - Property
- (NSMutableArray *)requestOperations {
    if (!_requestOperations) {
        _requestOperations = [[NSMutableArray alloc] init];
    }
    return _requestOperations;
}

- (BOOL)useNetUnavailableCache {
    return NO;
}

- (QMBusinessType)businessType {
    return QMBusinessTypeNormal;
}

- (QMCommand *)rnCommandConfig
{
    if (!_rnCommandConfig) {
        _rnCommandConfig = [[QMCommand alloc] init];
    }
    return _rnCommandConfig;
}

@end
