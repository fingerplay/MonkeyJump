//
//  QMCustomLog.m
//  juanpi3
//
//  Created by 彭军 on 2016/12/1.
//  Copyright © 2016年 彭军. All rights reserved.
//

#import "QMCustomLog.h"
#import "QMLogFormatter.h"
#import "QMFileLogFormatter.h"

#import "QMLogFileManager.h"
// Log 开关状态，默认不输出log信息

#ifdef DEBUG
static BOOL QM_Log_Enable = YES;
#else
static BOOL QM_Log_Enable = NO;
#endif

@implementation QMCustomLog

+(DDFileLogger *)initLogConfig{

    QMLogFormatter *formatter = [[QMLogFormatter alloc] init];
    
#ifdef DEBUG
    //开启使用 XcodeColors
    setenv("XcodeColors", "YES", 0);
    //检测
    char *xcode_colors = getenv("XcodeColors");
    if (xcode_colors && (strcmp(xcode_colors, "YES") == 0))
    {
        // XcodeColors is installed and enabled!
        QMLog(@"XcodeColors is installed and enabled");
    }
    //开启DDLog 颜色
//    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
//    [[DDTTYLogger sharedInstance] setForegroundColor:DDMakeColor(192, 192, 192) backgroundColor:nil forFlag:DDLogFlagVerbose];
//    [[DDTTYLogger sharedInstance] setForegroundColor:DDMakeColor(255, 255, 255) backgroundColor:[UIColor redColor] forFlag:DDLogFlagError];
//
//    [[DDTTYLogger sharedInstance] setForegroundColor:DDMakeColor(147, 198, 111) backgroundColor:nil forFlag:DDLogFlagInfo];
//    [[DDTTYLogger sharedInstance] setForegroundColor:DDMakeColor(209, 141, 89) backgroundColor:nil forFlag:DDLogFlagWarning];
    
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [[DDTTYLogger sharedInstance] setLogFormatter:formatter];
#else
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [[DDASLLogger sharedInstance] setLogFormatter:formatter];

#endif
    
    QMLogFileManager *logFileManager = [[QMLogFileManager alloc] init];
    QMFileLogFormatter *fileFormatter = [[QMFileLogFormatter alloc] init];
    
    DDFileLogger *fileLogger = [[DDFileLogger alloc] initWithLogFileManager:logFileManager];
    fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    fileLogger.logFormatter = fileFormatter;
    [DDLog addLogger:fileLogger];
    return fileLogger;
}

+ (BOOL)logEnable {
    return QM_Log_Enable;
}

+ (void)setLogEnable:(BOOL)flag {
    QM_Log_Enable = flag;
}


@end
