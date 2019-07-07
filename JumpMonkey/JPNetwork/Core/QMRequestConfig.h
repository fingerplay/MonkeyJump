//
//  QMRequestConfig.h
//  juanpi3
//
//  Created by 彭军 on 2017/1/13.
//  Copyright © 2017年 彭军. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QMRequestConfig : NSObject
//埋点请求最大并发数，默认是五个
@property (nonatomic,assign)NSInteger staMaxConcurrentOperationCount;
//业务请求最大并发数，默认是十个
@property (nonatomic,assign)NSInteger normalMaxConcurrentOperationCount;
//当前APP渠道
@property (nonatomic,strong)NSString *utm;
//是否debug模式输出请求以及返回log
@property (nonatomic,assign)BOOL logEnabled;

@property (nonatomic,strong)NSNumber *canPingJuanpi;
//验签sign key名  默认是apisign
@property (nonatomic,strong)NSString *apiSignKey;
@end
