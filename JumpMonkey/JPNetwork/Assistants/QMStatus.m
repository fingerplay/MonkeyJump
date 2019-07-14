//
//  QMNetException.m
//  juanpi3
//
//  Created by zagger on 15/8/6.
//  Copyright © 2015年 zagger. All rights reserved.
//

#import "QMStatus.h"
#import "QMRequesterCode.h"
#import "QMReqLogger.h"
#import "QMRequestManager.h"
#
@implementation QMStatus


- (instancetype)initWithSessionTask:(NSURLSessionDataTask *)task responseObject:(NSDictionary *)responseObject{
    if (self = [super init]) {
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse*)task.response;
        
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *dataDict = responseObject;
            [self parseDataDict:dataDict];
            
        } else if (response.statusCode != 200) {
            self.code = response.statusCode;
        }
        self.errorType = [self errorTypeFromResponse:response];
        
        self.responseHeader = ((NSHTTPURLResponse *)task.response).allHeaderFields;
        
        self.timeDuring = [[NSDate date] timeIntervalSinceDate:task.startDate];
    }
    return self;
}

- (void)parseDataDict:(NSDictionary *)dataDict {
    
    NSString *code= [dataDict safeStringForKey:@"errorCode"];
    
    if (code.length) {
        self.code = [code integerValue];
    }else{
        self.code = QMNetErrorTypeService;
    }
    self.info = [dataDict safeStringForKey:@"errorMsg"];
}

- (QMNetErrorType)errorTypeFromResponse:(NSHTTPURLResponse *)response {
    
    if (![REQUEST_MANAGER.requestConfig.canPingJuanpi boolValue]){
        return QMNetErrorTypeUncollected;
    }
    else{
        
        if (!response) {
            return QMNetErrorTypeTimeout;
        }
        else if (response.statusCode == 200){
            return QMNetErrorTypeNoData;
        }
    }
    return QMNetErrorTypeService;
}

@end

