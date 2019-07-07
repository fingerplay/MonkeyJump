//
//  QMLogFormatter.m
//  juanpi3
//
//  Created by 彭军 on 2016/12/6.
//  Copyright © 2016年 彭军. All rights reserved.
//

#import "QMLogFormatter.h"

@implementation QMLogFormatter

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage{
    
    NSString *logLevel = nil;
    
    
    switch (logMessage->_flag)
    {
        case DDLogFlagError:
            logLevel = @"[ERROR] >  ";
            break;
        case DDLogFlagWarning:
            logLevel = @"[WARN]  >  ";
            break;
        case DDLogFlagInfo:
            logLevel = @"[INFO]  >  ";
            break;
        case DDLogFlagDebug:
            logLevel = @"[DEBUG] >  ";
            break;
        default:
            logLevel = @"[VBOSE] >  ";
            break;
    }
    NSString *formatStr;
    if (logMessage->_flag==DDLogFlagDebug) {
        formatStr = [NSString stringWithFormat:@"%@ %@",logLevel,logMessage->_message];
    }else{
        formatStr = [NSString stringWithFormat:@"%@[%@][line %ld] %@",
                     logLevel,logMessage->_function,
                     (unsigned long)logMessage->_line, logMessage->_message];
    }
  
    return formatStr;
}

@end
