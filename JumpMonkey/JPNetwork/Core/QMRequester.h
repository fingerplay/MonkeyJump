//
//  QMRequester.h
//  juanpi3
//
//  Created by zagger on 15/8/6.
//  Copyright © 2015年 zagger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QMRequestManager.h"
#import "QMInput.h"
#import "QMStatus.h"
#import "QMCommand.h"
#import "QMRequesterDelegate.h"
#import "QMRequesterCode.h"

#pragma mark - 断网下刷新停止时的通知
static NSString  *const NOTIFY_EndRefreshWhenNoNetwork = @"NOTIFY_EndRefreshWhenNoNetwork";
#pragma mark - 断网下开始刷新时的通知
static NSString  *const NOTIFY_BeginRefreshWhenNoNetwork = @"NOTIFY_BeginRefreshWhenNoNetwork";

typedef NS_ENUM(NSInteger, QMRepeatRequestPolicy) {
    QMRepeatRequestPolicyDefault, //默认策略，全部请求都发出
    QMRepeatRequestPolicyCancelPrevious,  //撤销之前的请求
    QMRepeatRequestPolicyCancelCurrent,   //撤销当前的请求
};

typedef void(^QMRequesterSuccCallback)(QMStatus* status, QMInput* input, id output);
typedef void(^QMRequesterFailCallback)(QMStatus* status, QMInput* input, NSError *error);


/** 该类用于封装一个api请求相关的各种处理，包括发起请求，处理请求返回数据等 */
@interface QMRequester : NSObject

//请求回调的委托对象
@property (nonatomic, weak) id<QMRequesterDelegate> delegate;

//当请求重复时，处理的策略
@property (nonatomic, assign) QMRepeatRequestPolicy policy;

//请求的url,会覆盖子类预定义的url，请勿在此添加请求参数，参数统一放到子类处理
@property (nonatomic, copy) NSString *customUrl;

//添加自定义的公参GET请求
@property (nonatomic, strong) NSMutableDictionary *customParamsDict;

/** 请求的url,用于埋点 */
@property (nonatomic, copy) NSString *staFunUrl;

/** Success Block */
@property (nonatomic, copy) QMRequesterSuccCallback succCallback;

/** fail Block */
@property (nonatomic, copy) QMRequesterFailCallback failCallback;

@property (nonatomic, strong) QMCommand *rnCommandConfig;
//记录请求的字典
@property (nonatomic, readonly, strong) NSMutableArray *requestOperations;
/**
 *  发起请求
 */
- (void)startRequest;

/**
 *  发起请求
 *  @param succCallback 请求成功的回调函数
 *  @param failCallback 请求失败的回调函数
 *  @note  调用含有block回调函数的startRequest方法时，不会收到delegate的回调
 */
- (void)startRequestWithSuccCallback:(QMRequesterSuccCallback)succCallback failCallback:(QMRequesterFailCallback)failCallback;

/**
 *  RN调用原生发起请求
 */
- (void)startRNRequestCompletion:(void(^)(NSString *response))completion;

/**
 *  撤销所有请求
 */
- (void)cancalAllRequest;
/**
*  区分业务请求
*/
- (QMBusinessType)businessType;
/**
 *  获取动态url
 */
- (NSString *)generateDynamicUrl:(NSString *)requestUrl;
@end



