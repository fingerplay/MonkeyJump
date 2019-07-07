//
//  QMRequesterDelegate.h
//  juanpi3
//
//  Created by 罗谨 on 15/8/7.
//  Copyright (c) 2015年 罗谨. All rights reserved.
//


typedef NS_ENUM(NSInteger, QMRequestParamType) {
    QMRequestCustomPublicParam = 1,//接口下发动态参数列表
    QMRequestAPPPublicParams,//APP本地缓存的公共参数列表
    QMRequestHDCustomPublicParam,//iPad版本接口下发动态参数列表
    QMRequestPublicParamsOnRuntime,//运行时添加的公参
    QMRequestQimiextParams,//qimi协议下发api请求url追加参数qimiext
};


@class QMRequester,QMStatus,QMInput,AFHTTPRequestOperation;
@protocol QMRequesterDelegate <NSObject>

@optional

/** request成功 */
- (void)requester:(QMRequester *)requester successWithStatus:(QMStatus *)status input:(QMInput *)input output:(id)output;

/** request失败 */
- (void)requester:(QMRequester *)requester failedWithStatus:(QMStatus *)status input:(QMInput *)input error:(NSError *)error;

@optional
/** request取消*/
- (void)requester:(QMRequester *)requester cancelWithStatus:(QMStatus *)status input:(QMInput *)input error:(NSError *)error;

@end

@class request_header;

@protocol QMRequesterDatasource <NSObject>

@optional
#ifdef APP_PH
/** protocol buffer公参数据*/
- (request_header *)requesterProtoBufPublicParams;
#endif

//获取动态参数替换列表
- (NSDictionary *)requesterPublicParamsWithParamType:(QMRequestParamType)paramType;
//
- (NSString *)requesterUidAbtestStr;
//添加自定义UA
- (NSString *)requesterCommonUserAgent:(NSString *)originUserAgent;
//业务APi请求生成签名
- (NSString *)requesterApisignForParameters:(NSDictionary *)params command:(QMCommand *)command;
//对埋点的内容进行加密
- (NSString *)requesterStatSecretKeyStr:(NSString *)srcString;
//根据参数生成验签字符串,推送专用
- (NSString *)requesterApisignForPushParameters:(NSDictionary *)params;
//根据自定义kye获取自定义url
- (NSString *)requesterCustomUrlWithKey:(NSString *)key;

@end


//拦截请求返回数据回调进行业务操作 比如 刷新菜单、qimi协议、用户签名错误
@protocol QMResponseAOPDelegate <NSObject>
- (void)requester:(QMRequester *)requester handleSuccessAOPWithStatus:(QMStatus *)status dataTask:(NSURLSessionDataTask *)dataTask;
- (void)requester:(QMRequester *)requester handleFailedAOPWithStatus:(QMStatus *)status dataTask:(NSURLSessionDataTask *)dataTask;;
@end
