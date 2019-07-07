//
//  QMCommand.h
//  juanpi3
//
//  Created by zagger on 15/8/10.
//  Copyright © 2015年 zagger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QMInput.h"


/** 请求类型 */
typedef NS_ENUM(NSInteger, QMRequestMode) {
    QMRequestModeDefault,//默认
    QMRequestModeUpload,//上传
    QMRequestModeDownload//下载
};


/**请求方式*/
typedef NS_ENUM(NSInteger, QMRequestMethod) {
    QMRequestMethodPost = 0,
    QMRequestMethodGet = 1,
    QMRequestMethodTCP = 2
};


/**请求优先级*/
typedef NS_ENUM(NSInteger, QMRequestPriority) {
    QMRequestPriorityDefault = 0,
    QMRequestPriorityLow = 1,
    QMRequestPriorityHigh = 2
};

/** 请求使用的数据类型 */
typedef NS_ENUM(NSInteger, QMDataType) {
    QMDataTypeJson,
    QMDataTypeProtocolBuffer,
    QMDataTypeXML
};

/** 请求方式,HTTP(默认)/HTTPS */
typedef NS_ENUM(NSInteger, QMHTTPType) {
    QMHTTPType_HTTP = 0,
    QMHTTPType_HTTPS,
};


@protocol AFMultipartFormData;

/** 封装一个请求的相关参数，如请求方式、请求数据类型，请求url、请求参数等 */
@interface QMCommand : NSObject


#pragma mark - 请求相关数据
/** 数据类型，json/protocol buffer等 */
@property (nonatomic, assign) QMDataType dataType;

/** 请求方式get、post等 */
@property (nonatomic, assign) QMRequestMethod method;

/** 请求优先级 */
@property (nonatomic, assign) QMRequestPriority priority;

/** 采用pb类型时，传生成好的pb请求数据，为NSData类型，采用json该值传nil */
@property (nonatomic, strong) NSData *pbData;

/** 输入参数为QMInput或其子类，即使用pb数据类型也应该传该参数，以便在回调中获取请求时的相关信息。 */
@property (nonatomic, readonly, strong) QMInput *input;

//添加自定义的公参GET请求
@property (nonatomic, strong) NSMutableDictionary *customParamsDict;

/** 请求的url */
@property (nonatomic, copy)   NSString *url;

/** 超时时间 */
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

/** 请求方式,HTTP(默认)/HTTPS */
@property (nonatomic, assign) QMHTTPType httpType;

/** POST请求url默认不带get参数,3.3.7定的规则 */
@property (nonatomic, assign) BOOL isPOSTWithUrlParam;
/** rn调用QMRequest时 的参数*/
@property (nonatomic, strong) NSDictionary *rnParams;

/**
 *  构建一个command对象
 *
 *  @param input 请求参数
 *
 *  @return command对象
 */
+ (QMCommand *)buildCommandWithInput:(QMInput *)input;


#pragma mark - 上传下载相关
/** 请求类型 */
@property (nonatomic, assign) QMRequestMode mode;

/** 下载:目标路径 */
@property (nonatomic, copy) NSString *targetPath;

/** 下载:是否断点续传 */
@property (nonatomic, assign) BOOL shouldResume;

@property (nonatomic, copy) void (^uploadDataBlock)(id <AFMultipartFormData> formData);

#pragma mark - 其他
/** 返回能唯一标记该请求的一个字符串 */
@property (nonatomic, readonly, copy) NSString *identifier;

/** 判断自己和另一个command是不是同一个请求 */
- (BOOL)isTheSameCommand:(QMCommand *)otherCommand;



@end
