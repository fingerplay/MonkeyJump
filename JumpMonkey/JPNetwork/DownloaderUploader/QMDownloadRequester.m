//
//  QMDownloadRequester.m
//  juanpi3
//
//  Created by Jay on 15/8/11.
//  Copyright (c) 2015年 Jay. All rights reserved.
//

#import "QMDownloadRequester.h"
#import "QMRequesterPrivate.h"
#import "QMReqLogger.h"
#import <CommonCrypto/CommonDigest.h>

#define kQMNetworkIncompleteDownloadFolderName @"Incomplete"
@interface QMDownloadRequester ()
@end

@implementation QMDownloadRequester

#pragma mark - Inherit

/**
 * 下载文件,由父类进行调用
 */
- (void)startRequestWithCommand:(QMCommand *)command {
    
    /** command.url为nil会崩溃在AFDownloadRequestOperation */
    if (!command.url) {
        return ;
    }
    
    if (self.downloadTask && self.downloadTask.state == NSURLSessionTaskStateRunning) {
        [self downloadCancel];
    }
    
    __weak typeof(self) weakSelf = self;
    AFURLSessionTaskProgressBlock progressBlock= ^(NSProgress *progress) {
        NSLog(@"Downloading: %lld / %lld", progress.completedUnitCount, progress.totalUnitCount);
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.block) {
            strongSelf.block((CGFloat)progress.completedUnitCount/(CGFloat)progress.totalUnitCount);
        }
        
    };
    
    NSError * __autoreleasing requestSerializationError = nil;
    self.downloadTask = [self downloadTaskWithDownloadPath:command.targetPath  URLString:command.url parameters:nil timeoutInterval:command.timeoutInterval input:command.input progress:progressBlock error:&requestSerializationError];
    
    if (self.downloadTask) {

        @synchronized(self.requestOperations) {
            [self.requestOperations safeAddObject:self.downloadTask];
        }
        
        [REQUEST_MANAGER addRequester:self];
        
        [self.downloadTask resume];
        
        [QMReqLogger logRequestWithCommand:command params:nil request:self.downloadTask.currentRequest];
    }

}


- (NSURLSessionDownloadTask *)downloadTaskWithDownloadPath:(NSString *)downloadPath
                                                 URLString:(NSString *)URLString
                                                parameters:(id)parameters
                                           timeoutInterval:(NSTimeInterval)timeoutInterval
                                                     input:(QMInput *)input
                                                  progress:(nullable void (^)(NSProgress *downloadProgress))downloadProgressBlock
                                                     error:(NSError * _Nullable __autoreleasing *)error {
    
    self.manager = [REQUEST_MANAGER downloadDataWithSessionManager];
    
    // add parameters to URL;
    NSMutableURLRequest *urlRequest = [self.manager.requestSerializer requestWithMethod:@"GET" URLString:URLString parameters:parameters error:error];
    urlRequest.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    urlRequest.timeoutInterval = timeoutInterval;
    NSString *downloadTargetPath;
    BOOL isDirectory;
    if(![[NSFileManager defaultManager] fileExistsAtPath:downloadPath isDirectory:&isDirectory]) {
        isDirectory = NO;
    }
    // If targetPath is a directory, use the file name we got from the urlRequest.
    // Make sure downloadTargetPath is always a file, not directory.
    if (isDirectory) {
        NSString *fileName = [urlRequest.URL lastPathComponent];
        downloadTargetPath = [NSString pathWithComponents:@[downloadPath, fileName]];
    } else {
        downloadTargetPath = downloadPath;
    }
    
    // AFN use `moveItemAtURL` to move downloaded file to target path,
    // this method aborts the move attempt if a file already exist at the path.
    // So we remove the exist file before we start the download task.
    // https://github.com/AFNetworking/AFNetworking/issues/3775
    if ([[NSFileManager defaultManager] fileExistsAtPath:downloadTargetPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:downloadTargetPath error:nil];
    }
    BOOL resumeDataFileExists = NO;
    if (downloadPath && downloadPath.length) {
        NSURL *fileUrl = [self incompleteDownloadTempPathForDownloadPath:downloadPath];
        if (fileUrl) {
            resumeDataFileExists = [[NSFileManager defaultManager] fileExistsAtPath:fileUrl.path];
        }else{
            NSError *pathError = [NSError errorWithDomain:@"下载目标路径为空！" code:404 userInfo:nil];
            [self handleLocalErrorWithInput:input error:pathError];
            return nil;
        }
        
    }else{
        NSError *pathError = [NSError errorWithDomain:@"下载目标路径为空！" code:404 userInfo:nil];
        [self handleLocalErrorWithInput:input error:pathError];
        return nil;
    }
    NSData *data = [NSData dataWithContentsOfURL:[self incompleteDownloadTempPathForDownloadPath:downloadPath]];
    BOOL resumeDataIsValid = [QMDownloadRequester validateResumeData:data];
    
    BOOL canBeResumed = resumeDataFileExists && resumeDataIsValid;
    BOOL resumeSucceeded = NO;
//    __block NSURLSessionDownloadTask *downloadTask = nil;
    // Try to resume with resumeData.
    // Even though we try to validate the resumeData, this may still fail and raise excecption.
    __weak typeof(self) weakSelf = self;
    if (canBeResumed) {
        @try {
            self.downloadTask = [_manager downloadTaskWithResumeData:data progress:downloadProgressBlock destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                return [NSURL fileURLWithPath:downloadTargetPath isDirectory:NO];
            } completionHandler:
                            ^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                                [weakSelf handleRequestResult:weakSelf.downloadTask input:input error:error];
                            }];
            resumeSucceeded = YES;
        } @catch (NSException *exception) {
            NSLog(@"Resume download failed, reason = %@", exception.reason);
            resumeSucceeded = NO;
        }
    }
    if (!resumeSucceeded) {
        self.downloadTask = [_manager downloadTaskWithRequest:urlRequest progress:downloadProgressBlock destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            return [NSURL fileURLWithPath:downloadTargetPath isDirectory:NO];
        } completionHandler:
                        ^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                            [weakSelf handleRequestResult:weakSelf.downloadTask input:input error:error];
                        }];
    }
    
    return self.downloadTask;
}

-(void)handleLocalErrorWithInput:(QMInput *)input error:(NSError *)error{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
    dispatch_async(self.manager.completionQueue ?: dispatch_get_main_queue(), ^{
        [self handleRequestResult:nil input:input error:error];
    });
#pragma clang diagnostic pop
}



-(void)handleRequestResult:(NSURLSessionDownloadTask *)downloadTask input:(QMInput *)input error:(NSError *)error{
    
    QMStatus *status = [[QMStatus alloc] initWithSessionTask:(NSURLSessionDataTask *)downloadTask responseObject:nil];
    
    if (error) {
        
        if (self.failCallback) {
            self.failCallback(status, input, error);
        } else {
            [self requestFailed:status input:input error:error];
        }
        
    }else{
        
        NSInteger statusCode = ((NSHTTPURLResponse *)downloadTask.response).statusCode;
        
        if ((statusCode >= 200) && (statusCode < 300)) {
            
            id output = [self reformJsonData:nil];
            
            if (self.succCallback) {
                self.succCallback(status, input, output);
            } else {
                [self requestSuccess:status output:output input:input];
            }
        }
        else {
            [self requestFailed:status input:input error:nil];
        }
    }
    
    @synchronized(self.requestOperations) {
        [self.requestOperations removeObject:downloadTask];
    }
    [REQUEST_MANAGER removeRequester:self];
}

#pragma mark - Resumable Download

- (NSString *)incompleteDownloadTempCacheFolder {
    NSFileManager *fileManager = [NSFileManager new];
    static NSString *cacheFolder;
    
    if (!cacheFolder) {
        NSString *cacheDir = NSTemporaryDirectory();
        cacheFolder = [cacheDir stringByAppendingPathComponent:kQMNetworkIncompleteDownloadFolderName];
    }
    
    NSError *error = nil;
    if(![fileManager createDirectoryAtPath:cacheFolder withIntermediateDirectories:YES attributes:nil error:&error]) {
        NSLog(@"Failed to create cache directory at %@", cacheFolder);
        cacheFolder = nil;
    }
    return cacheFolder;
}

- (NSURL *)incompleteDownloadTempPathForDownloadPath:(NSString *)downloadPath {
    NSString *tempPath = nil;
    NSString *md5URLString = [self md5StringFromString:downloadPath];
    tempPath = [[self incompleteDownloadTempCacheFolder] stringByAppendingPathComponent:md5URLString];
    NSURL *fileUrl;
    if (tempPath.length) {
        fileUrl = [NSURL fileURLWithPath:tempPath];
    }
    return fileUrl;
}


+ (BOOL)validateResumeData:(NSData *)data {
    // From http://stackoverflow.com/a/22137510/3562486
    if (!data || [data length] < 1) return NO;
    
    NSError *error;
    NSDictionary *resumeDictionary = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:NULL error:&error];
    if (!resumeDictionary || error) return NO;
    
    // Before iOS 9 & Mac OS X 10.11
#if (defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED < 90000)\
|| (defined(__MAC_OS_X_VERSION_MAX_ALLOWED) && __MAC_OS_X_VERSION_MAX_ALLOWED < 101100)
    NSString *localFilePath = [resumeDictionary objectForKey:@"NSURLSessionResumeInfoLocalPath"];
    if ([localFilePath length] < 1) return NO;
    return [[NSFileManager defaultManager] fileExistsAtPath:localFilePath];
#endif
    // After iOS 9 we can not actually detects if the cache file exists. This plist file has a somehow
    // complicated structue. Besides, the plist structure is different between iOS 9 and iOS 10.
    // We can only assume that the plist being successfully parsed means the resume data is valid.
    return YES;
}



- (void)configCommand:(QMCommand *)command {
    command.url = self.urlString;
    command.timeoutInterval = 3600;
    command.shouldResume = YES;
    command.targetPath = self.filePath;
}


- (NSString *)md5StringFromString:(NSString *)string{
    const char *str = [string UTF8String];
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *encryptString = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                               r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    
    return encryptString;
}

#pragma mark - Public Methods

/** 暂停下载 */
- (void)downloadPause
{
    [self.downloadTask suspend];
}

/** 继续下载 */
- (void)downloadResume
{
    [self.downloadTask resume];
}

/** 取消下载 */
- (void)downloadCancel
{
    [self.downloadTask cancel];
}

@end
