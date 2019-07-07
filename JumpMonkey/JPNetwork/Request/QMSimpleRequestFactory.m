//
//  QMSimpleRequestFactory.m
//  juanpi3
//
//  Created by Jay on 15/9/15.
//  Copyright (c) 2015年 Jay. All rights reserved.
//

#import "QMSimpleRequestFactory.h"
#import "QMReqLogger.h"
#import "MJExtension.h"
#import "AFHTTPSessionManager.h"
#import "QMRequestManager.h"
@implementation QMSimpleRequestFactory

+ (NSURLSessionDataTask *)dataTaskWithCommand:(QMCommand *)command
                                      manager:(AFHTTPSessionManager *)sessionManager
                                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure  {
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
    
    if ([REQUEST_MANAGER.requestConfig logEnabled]) {
        [QMReqLogger logRequestWithCommand:command params:parameters request:dataTask.currentRequest];
    }
    return dataTask;

}

+ (NSMutableDictionary *)parametersWithCommand:(QMCommand *)commnad {
    
    return commnad.input.mj_JSONObject;
}

@end
