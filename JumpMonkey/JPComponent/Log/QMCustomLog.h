//
//  QMCustomLog.h
//  juanpi3
//
//  Created by 彭军 on 2016/12/1.
//  Copyright © 2016年 彭军. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CocoaLumberjack/CocoaLumberjack.h>
#ifdef DEBUG
static const int ddLogLevel = DDLogLevelVerbose;  //全部打印
//static const int ddLogLevel = DDLogLevelDebug;  //打印debug及以下级别日志
//static const int ddLogLevel = DDLogLevelInfo;   //打印Info及以下级别日志
//static const int ddLogLevel = DDLogLevelWarning;//打印Warning及以下级别日志
//static const int ddLogLevel = DDLogLevelError;  //只打印Error日志
#else
static const int ddLogLevel = DDLogLevelVerbose;
#endif


////调试使用 全部打印
//#define QMLog(format,...) if([QMCustomLog logEnable]) {\
//DDLogVerbose(format,##__VA_ARGS__);\
//} else{ \
//QMLogError(format,##__VA_ARGS__);\
//}

//调试使用 全部打印
#define QMLog(format,...) if([QMCustomLog logEnable]) DDLogVerbose(format,##__VA_ARGS__)
//调试使用，api请求、返回 以及 埋点log打印
#define QMLogDebug(format,...) if([QMCustomLog logEnable]) DDLogDebug(format,##__VA_ARGS__)
//调试使用 如不需要api数据打印以及埋点日志 请使用 QMLogInfo  ddLogLevel定义为 DDLogLevelInfo
#define QMLogInfo(format,...) if([QMCustomLog logEnable]) DDLogInfo(format,##__VA_ARGS__)
//此级别打印可能出现问题的地方
#define QMLogWarn(format,...) if([QMCustomLog logEnable]) DDLogWarn(format,##__VA_ARGS__)
//此级别Log会进行文件记录并上传 方便发现异常以及定位问题
#define QMLogError(format,...) DDLogError(format,##__VA_ARGS__)

@interface QMCustomLog : NSObject

/**
 *  初始化log配置
 *
 */
+ (DDFileLogger *)initLogConfig;

/**
 *  Log 输出开关 (release默认关闭)
 *
 *  @param flag 是否开启
 */
+ (void)setLogEnable:(BOOL)flag;

/**
 *  是否开启了 Log 输出
 *
 *  @return Log 开关状态
 */
+ (BOOL)logEnable;

@end
