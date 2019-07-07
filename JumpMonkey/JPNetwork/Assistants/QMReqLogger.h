//
//  QMReqLogger.h
//  juanpi3
//
//  Created by zagger on 15/8/10.
//  Copyright © 2015年 zagger. All rights reserved.
//

#import <Foundation/Foundation.h>
@class QMCommand;
@interface QMReqLogger : NSObject

/** 打印request信息 */
+ (void)logRequestWithCommand:(QMCommand *)command params:(id)params request:(NSURLRequest *)request;

/** 打印请求返回的信息 */
+ (void)logResponseWithDataTask:(NSURLSessionDataTask *)dataTask responseObject:(id)responseObject error:(NSError *)error;


@end



static char kAFStartDateKey;
@interface NSObject (Date)

@property (nonatomic, strong) NSDate *startDate;

@end
