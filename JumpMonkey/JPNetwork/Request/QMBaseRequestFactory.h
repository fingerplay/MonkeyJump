//
//  QMBaseRequestFactory.h
//  JPNetworkDemo
//
//  Created by 彭军 on 2017/6/12.
//  Copyright © 2017年 卷皮网. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QMCommand.h"
@class AFHTTPSessionManager;
@interface QMBaseRequestFactory : NSObject
+ (NSURLSessionDataTask *)dataTaskWithCommand:(QMCommand *)command
                                      manager:(AFHTTPSessionManager *)sessionManager
                                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

+ (NSString *)stringForRequestMethod:(QMRequestMethod)method;
@end
