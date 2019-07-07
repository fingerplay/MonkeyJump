//
//  QMBaseRequestFactory.m
//  JPNetworkDemo
//
//  Created by 彭军 on 2017/6/12.
//  Copyright © 2017年 卷皮网. All rights reserved.
//

#import "QMBaseRequestFactory.h"

@implementation QMBaseRequestFactory

+ (NSURLSessionDataTask *)dataTaskWithCommand:(QMCommand *)command
                                      manager:(AFHTTPSessionManager *)sessionManager
                                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure{

    
    return nil;
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
