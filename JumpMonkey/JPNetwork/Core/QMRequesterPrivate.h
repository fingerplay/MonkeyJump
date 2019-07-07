//
//  QMRequesterPrivate.h
//  juanpi3
//
//  Created by 罗谨 on 15/8/13.
//  Copyright (c) 2015年 罗谨. All rights reserved.
//


@interface QMRequester (Inherrit)

//是否缓存数据，以便在断网情况下使用缓存数据，默认为NO
@property (nonatomic, readonly, assign) BOOL useNetUnavailableCache;

@property (nonatomic, assign) QMBusinessType businessType;

/************ 以下方法由子类继承，外部不需要调用 *********/
/**
 *  根据command发起请求，需要使用command时可重载
 *
 *  @param command command对象
 */
- (void)startRequestWithCommand:(QMCommand *)command;

#pragma mark - ParamConstructor
/**
 *  配置command，必要时可重载，不重载则command使用默认值
 *
 *  @param command 请求命令
 */
- (void)configCommand:(QMCommand *)command;

/**
 *  根据Requester的属性创建input，有参数的请求需要重载
 *
 *  @return input对象
 */
- (QMInput *)buildInput;

/**
 *  根据Requester属性创建pb请求data
 *
 *  @return pb数据对应的NSData
 */
- (NSData *)buildProtocolBufferData;

#pragma mark - Reformer
/**
 *  解析data，得到业务数据
 *
 *  @param data      返回的json对象里面data字段的内容
 *
 *  @return 解析的结果
 */
- (id)reformJsonData:(id)data;

- (id)reformJsonData:(id)data withStatus:(QMStatus *)status;


/**
 *  解析data，得到业务数据
 *
 *  @param pbData      返回的protobuffer对象里面的data字段的内容
 *
 *  @return 解析的结果
 */
- (id)reformProtoBufferData:(id)pbData status:(QMStatus *)status;


#pragma mark - RequestResult

/**
 *  请求成功之后的处理
 *
 *  @param status         请求结果的状态
 *  @param output         结果解析后的对象
 *  @param input          原始请求的参数
 */
- (void)requestSuccess:(QMStatus *)status output:(id)output input:(QMInput*)input;

/**
 *  请求失败的处理
 *
 *  @param status    请求结果的状态
 *  @param error     错误信息
 *  @param input     原始请求的参数
 */
- (void)requestFailed:(QMStatus *)status input:(QMInput*)input error:(NSError *)error;

@end
