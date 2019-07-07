//
//  QMDownloadRequester.h
//  juanpi3
//
//  Created by Jay on 15/8/11.
//  Copyright (c) 2015年 Jay. All rights reserved.
//

#import "QMRequester.h"
#import "AFHTTPSessionManager.h"
typedef void(^DownLoadBlock)(CGFloat percent);
typedef void (^AFURLSessionTaskProgressBlock)(NSProgress *);
/**
 *  下载请求，发起请求直接使用父类的startRequest方法，这里不提供额外的调用方法
 */
@interface QMDownloadRequester : QMRequester{
    NSString *_filePath;
}

/** 下载队列 */
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;

/** 下载地址 */
@property (nonatomic, copy) NSString *urlString;

/** 存放的路径,例:.../.../xxx.zip */
@property (nonatomic, copy) NSString *filePath;

/** 下载进度 */
@property (nonatomic, copy) DownLoadBlock block;


/** 暂停下载 */
- (void)downloadPause;

/** 继续下载 */
- (void)downloadResume;

/** 取消下载 */
- (void)downloadCancel;



@end
