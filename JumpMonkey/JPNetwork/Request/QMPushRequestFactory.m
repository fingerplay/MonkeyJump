//
//  QMPushRequestFactory.m
//  juanpi3
//
//  Created by zagger on 15/9/10.
//  Copyright (c) 2015年 zagger. All rights reserved.
//

#import "QMPushRequestFactory.h"
#import "QMCommand.h"
#import "QMReqLogger.h"
#import "AFHTTPSessionManager.h"
#import "QMRequestManager.h"
#import "MJExtension.h"
static NSString *const kApiSignkey = @"apiSign";

@implementation QMPushRequestFactory

+ (NSURLSessionDataTask *)dataTaskWithCommand:(QMCommand *)command
                                      manager:(AFHTTPSessionManager *)sessionManager
                                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    //获取请求参数
    NSMutableDictionary *parameters = [self parametersWithCommand:command];
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = nil;
    
    
    request = [sessionManager.requestSerializer requestWithMethod:[self stringForRequestMethod:command.method]
                                                          URLString:command.url
                                                         parameters:parameters
                                                              error:&serializationError];
    
    if (serializationError) {
        if (failure) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(sessionManager.completionQueue ?: dispatch_get_main_queue(), ^{
                failure(nil, serializationError);
            });
#pragma clang diagnostic pop
        }
        
        return nil;
    }
    
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [sessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
        if (error) {
            if (failure) {
                failure(dataTask, error);
            }
        } else {
            if (success) {
                success(dataTask, responseObject);
            }
        }
    }];
    
    [QMReqLogger logRequestWithCommand:command params:parameters request:request];
    
    return dataTask;
}

+ (NSMutableDictionary *)parametersWithCommand:(QMCommand *)commnad {//生成apisign做验签
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:commnad.input.mj_JSONObject];
    
    NSDictionary *publicParams = [REQUEST_MANAGER requesterPublicParamsWithParamType:QMRequestAPPPublicParams];
    for (NSString *key in publicParams) {
        [params safeSetObject:publicParams[key] forKey:key];
    }
    [params safeSetObject:[REQUEST_MANAGER requesterApisignForPushParameters:params] forKey:kApiSignkey];
    
    return params;
}


+ (NSString *)stringForRequestMethod:(QMRequestMethod)method {
    switch (method) {
        case QMRequestMethodGet:
            return @"GET";
            break;
        case QMRequestMethodPost:
            return @"POST";
            break;
        default:
            return @"";
            break;
    }
}

@end
