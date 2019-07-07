//
//  QMReqLogger.m
//  juanpi3
//
//  Created by zagger on 15/8/10.
//  Copyright © 2015年 zagger. All rights reserved.
//

#import "QMReqLogger.h"
#import "QMCommand.h"
#import "MJExtension.h"
#import "QMCustomLog.h"
@implementation QMReqLogger

+ (void)logRequestWithCommand:(QMCommand *)command params:(id)params request:(NSURLRequest *)request {
#ifdef DEBUG
    NSMutableString *logString = [NSMutableString stringWithString:@"\n\n**************************************************************\n*                          请求开始                           *\n**************************************************************\n"];

    [logString appendFormat:@"请求方式：%@\n", [self stringForMethod:command.method]];
    [logString appendFormat:@"数据类型：%@\n", [self stringForDataType:command.dataType]];
    [logString appendFormat:@"优先级别：%@\n", [self stringForPriority:command.priority]];
    [logString appendFormat:@"超时时间：%@\n", @(command.timeoutInterval)];
    [logString appendFormat:@"请求地址：%@\n", command.url];
    [logString appendFormat:@"请求参数：%@\n", params];
    [logString appendFormat:@"httpheader：%@\n", request.allHTTPHeaderFields ? request.allHTTPHeaderFields : @"空"];
    [logString appendFormat:@"**************************************************************\n\n"];
    
    QMLogDebug(@"%@", logString);
    
   
#endif
}

+ (void)logResponseWithDataTask:(NSURLSessionDataTask *)dataTask responseObject:(id)responseObject error:(NSError *)error{

/** 埋点,统计api请求,3.4.1 */
//埋点统计api请求移至 handleSuccessAOPWithStatus和handleFailedAOPWithStatus两个回调方法内
//    [QMStaFunApiResponse staApiResponseWithOperation:operation];
  
#ifdef DEBUG
    BOOL shouldLogError = error ? YES : NO;
    
    NSMutableString *logString = [NSMutableString stringWithString:@"\n\n==============================================================\n=                           请求返回                          =\n==============================================================\n"];
    NSTimeInterval timeDuring =[[NSDate date] timeIntervalSinceDate:dataTask.startDate];

    NSURLRequest *request = dataTask.currentRequest;
    NSHTTPURLResponse *response = (NSHTTPURLResponse*)dataTask.response;
    [logString appendFormat:@"请求耗时：%.3f秒   状态码：%ld\n\n", timeDuring, (long)response.statusCode];
    [logString appendFormat:@"请求地址：%@://%@%@\n\n", request.URL.scheme, request.URL.host, request.URL.path];
    [logString appendFormat:@"get子串：\n\t%@\n\n", request.URL.query];
    
    NSString *responseJsonStr;
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        responseJsonStr = [responseObject mj_JSONString];
    }else{
        responseJsonStr = responseObject;
    }
    [logString appendFormat:@"返回json数据：\n\n%@\n", responseJsonStr];

    if (shouldLogError) {
        [logString appendFormat:@"Error Domain:\t\t\t\t\t\t\t%@\n", error.domain];
        [logString appendFormat:@"Error Domain Code:\t\t\t\t\t\t%ld\n", (long)error.code];
        [logString appendFormat:@"Error Localized Description:\t\t\t%@\n", error.localizedDescription];
        [logString appendFormat:@"Error Localized Failure Reason:\t\t\t%@\n", error.localizedFailureReason];
        [logString appendFormat:@"Error Localized Recovery Suggestion:\t%@\n\n", error.localizedRecoverySuggestion];
    }
    
//    NSHTTPURLResponse *response = operation.response;
//    [logString appendFormat:@"httpheader：\n\n\t\t\t\t%@\n", response.allHeaderFields ? response.allHeaderFields : @"空"];
    [logString appendFormat:@"==============================================================\n\n"];
    
    QMLogDebug(@"%@", logString);
    
#endif
}


#pragma mark - Helper
+ (NSString *)stringForMethod:(QMRequestMethod)method {
    switch (method) {
        case QMRequestMethodGet:
            return @"GET";
            break;
        case QMRequestMethodPost:
            return @"POST";
            break;
        case QMRequestMethodTCP:
            return @"TCP";
            break;
            
        default:
            break;
    }
    return @"unknow";
}

+ (NSString *)stringForDataType:(QMDataType)dataType {
    switch (dataType) {
        case QMDataTypeJson:
            return @"Json";
            break;
        case QMDataTypeProtocolBuffer:
            return @"protocolBuffer";
            break;
        case QMDataTypeXML:
            return @"XML";
            break;
        default:
            break;
    }
    return @"unknow";
}

+ (NSString *)stringForPriority:(QMRequestPriority)priority {
    switch (priority) {
        case NSOperationQueuePriorityVeryLow:
            return @"NSOperationQueuePriorityVeryLow";
            break;
        case NSOperationQueuePriorityLow:
            return @"NSOperationQueuePriorityLow";
            break;
        case NSOperationQueuePriorityNormal:
            return @"NSOperationQueuePriorityNormal";
            break;
        case NSOperationQueuePriorityHigh:
            return @"NSOperationQueuePriorityHigh";
            break;
        case NSOperationQueuePriorityVeryHigh:
            return @"NSOperationQueuePriorityVeryHigh";
            break;
            
        default:
            break;
    }
    return @"unknow";
}


@end



@implementation NSObject (Date)

- (NSDate *)startDate {
    return (NSDate *)objc_getAssociatedObject(self, &kAFStartDateKey);
}

- (void)setStartDate:(NSDate *)startDate {
    objc_setAssociatedObject(self, &kAFStartDateKey, startDate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

