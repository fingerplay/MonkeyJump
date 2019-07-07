//
//  QMNormalRequestFactory.m
//  juanpi3
//
//  Created by zagger on 15/9/9.
//  Copyright (c) 2015年 zagger. All rights reserved.
//

#import "QMNormalRequestFactory.h"
#import "QMReqLogger.h"
#import "NSString+Json.h"
#import "NSString+QMRequest.h"
#import "QMInput.h"
#import "AFHTTPSessionManager.h"
#import "QMCommand.h"
#import "QMRequestManager.h"
#import "MJExtension.h"
static NSString * const kApiSign = @"apisign";
static NSString * const kProtoBufName = @"protobuf";//http header中的pb字段的名称

@implementation QMNormalRequestFactory

#pragma mark - 生成operation
+ (NSURLSessionDataTask *)dataTaskWithCommand:(QMCommand *)command
                                       manager:(AFHTTPSessionManager *)sessionManager
                                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    //获取请求参数
    NSMutableDictionary *parameters = [self requestParamsWithCommand:command];
    
    NSString *requestUrl;
    if (QMRequestMethodGet == command.method) {//get请求将参数按升序拼到url
        requestUrl = [self urlForRequest:command getParams:parameters];
    } else {
        requestUrl = [self urlForRequest:command getParams:nil];
    }
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = nil;
    if (command.mode == QMRequestModeUpload && command.uploadDataBlock) {//有上传数据时，忽略method,统一使用post方式
        request = [sessionManager.requestSerializer multipartFormRequestWithMethod:@"POST"
                                                                           URLString:requestUrl
                                                                          parameters:parameters
                                                           constructingBodyWithBlock:command.uploadDataBlock
                                                                               error:&serializationError];
    } else {//没有数据上传时
        request = [sessionManager.requestSerializer requestWithMethod:[self stringForRequestMethod:command.method]
                                                              URLString:requestUrl
                                                             parameters:QMRequestMethodGet == command.method ? nil : parameters
                                                                  error:&serializationError];
    }
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
    
    if (QMRequestMethodGet == command.method) {//get请求header里加公参
        
        NSMutableDictionary *publicParams = [REQUEST_MANAGER requesterPublicParamsWithParamType:QMRequestAPPPublicParams].mutableCopy;
        
        NSDictionary *runtimePublicParams = [REQUEST_MANAGER requesterPublicParamsWithParamType:QMRequestPublicParamsOnRuntime];
        if (runtimePublicParams) {
            //插入新的key-value,如果原来的字典有同样的key，则替换为新的value
            [publicParams addEntriesFromDictionary:runtimePublicParams];
        }
        if (command.customParamsDict) {
            [publicParams safeAddEntriesFromDictionary:command.customParamsDict];
        }
        for (NSString *key in publicParams.allKeys) {
            [request setValue:[NSString urlEncodeStringWithString:[publicParams objectForKey:key]] forHTTPHeaderField:key];
        }
    }
    
    NSString *originUserAgent = [[request allHTTPHeaderFields] objectForKey:@"User-Agent"];
    [request setValue:[REQUEST_MANAGER requesterCommonUserAgent:originUserAgent] forHTTPHeaderField:@"User-Agent"];
    
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






#pragma mark - 参数处理
//json根据相关配置返回最后需要的请求参数
+ (NSMutableDictionary *)requestParamsWithCommand:(QMCommand *)command {

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:command.input.mj_JSONObject];//获取业务参数字典
    // rn调用request时 添加的参数
    if (command.rnParams) {
        [params safeAddEntriesFromDictionary:command.rnParams];
    }
    
    NSMutableDictionary *tmpDic = [NSMutableDictionary dictionary];
    for (NSString *key in params) {//去掉请求参数首尾的空格
        NSString *value = [params objectForKey:key];
        if ([value respondsToSelector:@selector(stringByTrimmingCharactersInSet:)]) {
            [tmpDic safeSetObject:[value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:key];
        } else {
            [tmpDic safeSetObject:value forKey:key];
        }
    }
    
    params = tmpDic;
    
    if (QMRequestMethodGet ==  command.method) {//get请求，对参数值进行encode
        params = [self dynamicParamsWithCommand:command params:params];
    }
    else if (QMRequestMethodPost ==  command.method) {//添加公参
        NSDictionary *publicParams = [REQUEST_MANAGER requesterPublicParamsWithParamType:QMRequestAPPPublicParams];
        for (NSString *key in publicParams.allKeys) {
            [params setObject:publicParams[key] forKey:key];
        }
    }

    BOOL extMatch = false;
    NSDictionary *extParams = [REQUEST_MANAGER requesterPublicParamsWithParamType:QMRequestQimiextParams];
    if (extParams.allKeys.count > 0) {
        NSArray *urls = [extParams safeObjectForKey:@"url"];
        for (NSString *extUrl in urls) {
            if ([command.url containsString:extUrl] && [extParams safeObjectForKey:@"p"] != nil) {
                [params setObject:[extParams safeObjectForKey:@"p"] forKey:@"qimiext"];
                extMatch = true;
                break;
            }
        }
    }
    // qimiext只生效一次,所以在匹配成功时候清除数据
    if (extMatch && [extParams isKindOfClass:[NSMutableDictionary class]]) {
        [(NSMutableDictionary *)extParams removeAllObjects];
    }
    
    NSString *apiSign = [REQUEST_MANAGER requesterApisignForParameters:params command:command];
    if (apiSign.length) {
        //添加验签
        NSString  *apiSignKey = REQUEST_MANAGER.requestConfig.apiSignKey;
        if (!apiSignKey.length) {
            //没有配置signkey 则使用卷皮折扣默认的key
            apiSignKey = kApiSign;
        }
        
        [params safeSetObject:apiSign forKey:apiSignKey];
    }
   
    
    return params;
}

//get请求将参数升序拼接到url进行请求
+ (NSString *)urlForRequest:(QMCommand *)command getParams:(NSDictionary *)params {
    
    NSArray *array = [command.url componentsSeparatedByString:@"?"];
    NSString *originUrl = [array safeObjectAtIndex:0];
    
    NSString *queryString = [NSString queryStringWithDictionary:params sortType:QMSortTypeAscending encode:YES];
    if (queryString.length > 0) {
        originUrl = [NSString stringWithFormat:@"%@?%@",originUrl, queryString];
    }
    
    return originUrl;
}




#pragma mark - get请求动态url处理

//替换动态url中的占位符
+ (NSMutableDictionary *)dynamicParamsWithCommand:(QMCommand *)command params:(NSMutableDictionary *)params {
    
    NSArray *array = [command.url componentsSeparatedByString:@"?"];
    NSString *queryString = [array safeObjectAtIndex:1];
    
    if (![command.url isDynamicUrl]) {
        if (queryString.length > 0) {
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:params];
            NSArray *pArray = [queryString componentsSeparatedByString:@"&"];
            
            for (NSString *tmpString in pArray) {
                NSArray *tmpArray = [tmpString componentsSeparatedByString:@"="];
                NSString *value = [tmpArray safeObjectAtIndex:1];
                [dic safeSetObject:value forKey:[tmpArray safeObjectAtIndex:0]];
            }
            return dic;
        } else {
            return params;
        }
    }
    
    
    if (queryString.length > 0) {
        
        /** 3.4.6 配置自定义的公参列表 */
        NSMutableDictionary *publicParams = [NSMutableDictionary safeDictionaryWithDictionary:[REQUEST_MANAGER requesterPublicParamsWithParamType:QMRequestCustomPublicParam]];
        [publicParams safeAddEntriesFromDictionary:[REQUEST_MANAGER requesterPublicParamsWithParamType:QMRequestAPPPublicParams]];
        NSMutableDictionary *paramsPool = [NSMutableDictionary dictionaryWithDictionary:params];
        for (NSString *key in publicParams) {
            [paramsPool setObject:publicParams[key] forKey:key];
        }
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        NSArray *pArray = [queryString componentsSeparatedByString:@"&"];
        
        for (NSString *tmpString in pArray) {
            NSArray *tmpArray = [tmpString componentsSeparatedByString:@"="];
            NSString *value = [tmpArray safeObjectAtIndex:1];
    
            NSRange startRange = [value rangeOfString:@"$${"];
            if (startRange.location != NSNotFound) {
                NSRange endRange = [value rangeOfString:@"}"];
                if (endRange.location != NSNotFound) {
                    NSRange subRange = NSMakeRange(startRange.location, endRange.location - startRange.location + 1);
                    NSString *subValue =  [value substringWithRange:subRange];
                    NSString *subParamsValue = [paramsPool objectForKey:[subValue substringWithRange:NSMakeRange(3, subValue.length -4)]];
                    subParamsValue = subParamsValue ? subParamsValue : @"";
                    value = [value stringByReplacingOccurrencesOfString:subValue withString:subParamsValue];
                }
            }

            if ([value hasPrefix:@"${"]) {
                id paramsValue = [paramsPool objectForKey:[value substringWithRange:NSMakeRange(2, value.length -3)]];
                paramsValue = paramsValue ? paramsValue : @"";
                [dic safeSetObject:paramsValue forKey:[tmpArray safeObjectAtIndex:0]];
            } else {
                [dic safeSetObject:value forKey:[tmpArray safeObjectAtIndex:0]];
            }
        }
        return dic;
    }
    
    return nil;
}


#pragma mark - pbdata转字符串
+ (NSString *)pbStringFromData:(NSData *)pbData {
    if (!pbData) {
        return nil;
    }
    NSString * base64 = @"";
    if ([pbData respondsToSelector:@selector(base64EncodedStringWithOptions:)]) {
        base64 = [pbData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    }else{
        base64 = [pbData base64Encoding];//iOS 6.0下的方法
    }
    
    NSString *urlEncodeBase64String = [NSString urlEncodeStringWithString:base64];
    return urlEncodeBase64String;
}
@end
