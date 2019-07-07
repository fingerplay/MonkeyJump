//
//  QMFileLogFormatter.m
//  juanpi3
//
//  Created by 彭军 on 2017/1/6.
//  Copyright © 2017年 彭军. All rights reserved.
//

#import "QMFileLogFormatter.h"

@implementation QMFileLogFormatter
- (NSString *)formatLogMessage:(DDLogMessage *)logMessage{
    NSTimeInterval interval  = [logMessage->_timestamp timeIntervalSince1970] *1000;
    NSString *logLevel;
    switch (logMessage->_flag)
    {
        case DDLogFlagError:
            logLevel = @"E";
            break;
        case DDLogFlagWarning:
            logLevel = @"W";
            break;
        case DDLogFlagInfo:
            logLevel = @"I";
            break;
        case DDLogFlagDebug:
            logLevel = @"D";
            break;
        default:
            logLevel = @"V";
            break;
    }
    
    NSString *info = [NSString stringWithFormat:@"%f|%@|%@",interval,self.uid,self.jpid];
    
    NSString *formatStr = [NSString stringWithFormat:@"%@|%@|%@| %@",
                 info,logLevel,logMessage->_function, logMessage->_message];
    
    return formatStr;
}
@end
