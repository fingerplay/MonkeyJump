//
//  QMStatisticsRequestFactory.m
//  juanpi3
//
//  Created by zagger on 15/9/9.
//  Copyright (c) 2015年 zagger. All rights reserved.
//

#import "QMStatisticsRequestFactory.h"
#import "QMReqLogger.h"
#import "AFHTTPSessionManager.h"
#import "ASIDataCompressor.h"
#import "QMRequestManager.h"
#import "MJExtension.h"
#import "QMCustomLog.h"
@implementation QMStatisticsRequestFactory

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
    
//    AFHTTPRequestOperation *operation = [operationManager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
////TODO:打印埋点数据
////        [QMStaLoger logWithOperation:operation error:nil];
//        
//        if (success) {
//            success(operation, responseObject);
//        }
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
////TODO:打印埋点数据
////        [QMStaLoger logWithOperation:operation error:error];
//        
//        if (failure) {
//            failure(operation, error);
//        }
//    }];
//    
//    operation.queuePriority = command.priority;
//TODO:打印埋点数据
//    [QMStaLoger logWithOperation:operation command:command params:parameters];
    
    
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
    
    return dataTask;

}

+ (NSMutableDictionary *)parametersWithCommand:(QMCommand *)commnad {
    
    NSMutableDictionary *dic = commnad.input.mj_JSONObject;
    //把数组里面的input转换成up_input
    NSMutableArray *upDataArr = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSInteger i=0; i<commnad.input.data.count; i++) {
        NSObject *baseInput = [commnad.input.data safeObjectAtIndex:i];
        [upDataArr safeAddObject:[self toDictionaryWithObject:baseInput]];
    }

#ifdef DEBUG
    QMLogDebug(@"**************************************************************");
    QMLogDebug(@"埋点要上传的数据:%@", commnad.input.mj_JSONString);
    QMLogDebug(@"**************************************************************\n\n\n\n");
#endif
    
    if ([upDataArr count]==0) {
        return nil;
    }
    //1.把字典里面的data转成JSONData
    NSData *JSONData = [self toJSONStringData:upDataArr];
    
    //2.把JSONData打包成gzip格式
    NSData *gzipData = [ASIDataCompressor compressData:JSONData error:nil];
    
    if (!gzipData) {
        return nil;
    }
    
    //3.把gzip格式转成字符串("iso-8859-1"编码)
    NSString *gzipStr = [[NSString alloc] initWithData:gzipData encoding:NSISOLatin1StringEncoding];
    
    //data
    if (gzipStr) {
        [dic setValue:gzipStr forKey:@"data"];
    }
    
    
    if (!JSONData) {
        return nil;
    }
    
    //验签
    //压缩前的字符串
    NSString *JSONStr = [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding];
    //    NSLog(@"要上传%@的data数据:%@", [self class], JSONStr);
    
    NSString *sign = [REQUEST_MANAGER requesterStatSecretKeyStr:JSONStr];
    if (sign) {
        [dic setValue:sign forKey:@"sign"];
    }
    
    return dic;
}

+ (NSData *)toJSONStringData:(id)theData
{
    if (![NSJSONSerialization isValidJSONObject:theData]) {
        QMLogError(@"不是有效的JSONObject");
        return nil;
    }
    
    NSError* error = nil;
    NSData *jsonStrData = [NSJSONSerialization dataWithJSONObject:theData options:kNilOptions error:&error];
    if (error != nil) {
        return nil;
    }
    return jsonStrData;
}

+ (NSMutableDictionary *)toDictionaryWithObject:(NSObject *)object {
    
    NSMutableDictionary *dic = object.mj_keyValues;
    
    [dic removeObjectForKey:@"rowid"];
    
    return dic;
}

@end
