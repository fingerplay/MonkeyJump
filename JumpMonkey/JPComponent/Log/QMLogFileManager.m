//
//  QMLogFileManager.m
//  juanpi3
//
//  Created by 彭军 on 2016/12/6.
//  Copyright © 2016年 彭军. All rights reserved.
//

#import "QMLogFileManager.h"
#import "QMCustomLog.h"
//#import "BBSafeEX.h"
@implementation QMLogFileManager

// Notifications from DDFileLogger

/**
 *  Called when the roll action was executed and the log was archieved
 */
- (void)didRollAndArchiveLogFile:(NSString *)logFilePath{
    QMLog(@"日志归档完毕：%@",logFilePath);
}

- (NSString *)createLogZipWithMinCount:(NSInteger)minCount{

#ifndef TODAY_EXTENSION
    NSArray *logFiles = self.sortedLogFileInfos;
    
    if ([logFiles count]==0) {
        return nil;
    }
    
    if (minCount !=0 && [logFiles count] < minCount) {
        //不满足最小数量不对其进行压缩
        return nil;
    }

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (DDLogFileInfo *logFileInfo in logFiles) {
        
        if (!logFileInfo.isArchived) {
            
            float min = logFileInfo.age/60;
            
            if (min>=5) {
                //文件创建时间超过五分钟之内的才进行归档压缩，否则不处理，避免设置页面频繁点击上传日志
                [logFileInfo setIsArchived:YES];
            }
        }
    
        if (logFileInfo.isArchived) {
            
            [dic setObject:logFileInfo.filePath forKey:logFileInfo.fileName];
        }
    }
    
    if ([dic count]>0) {
        
        NSString *logDiretory= [[self logsDirectory] stringByAppendingPathComponent:@"zip"];
        
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:logDiretory]) {
            NSError *err = nil;
            
            if (![[NSFileManager defaultManager] createDirectoryAtPath:logDiretory
                                           withIntermediateDirectories:YES
                                                            attributes:nil
                                                                 error:&err]) {
                QMLogError(@"QMLogFileManager: Error creating logsDirectory: %@", err);
                return nil;
            }
        }
        
//        QM_ZipArchive *za = [[QM_ZipArchive alloc] init];
        
        NSString *fileName =  [NSString stringWithFormat:@"ios_log_%@.zip",[self stringWithDate:[NSDate date]]];
        NSString *zipFile = [logDiretory stringByAppendingPathComponent:fileName];
//        [za CreateZipFile2:zipFile];
//        for (NSString  *key in  dic.allKeys) {
//             [za addFileToZip:[dic objectForKey:key] newname:key];
//        }
//        BOOL success = [za CloseZipFile2];
        
//        if (success) {
//            for (DDLogFileInfo *logFileInfo in logFiles) {
//                //压缩成功后删除原来的log文件
//                if (logFileInfo.isArchived) {
//                    [[NSFileManager defaultManager] removeItemAtPath:logFileInfo.filePath error:nil];
//                }
//            }
//        }else{
//            QMLogError(@"压缩Log文件失败！！！");
//        }
         return zipFile;
    }

#endif
    
    return nil;
}


- (NSString *)stringWithDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *datestr = [dateFormatter stringFromDate:date];
    return datestr;
}

@end
