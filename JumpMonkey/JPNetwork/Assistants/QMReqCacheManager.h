//
//  QMReqCacheManager.h
//  juanpi3
//
//  Created by zagger on 15/8/11.
//  Copyright © 2015年 zagger. All rights reserved.
//

#import <Foundation/Foundation.h>

#define REQ_CACHE_MANAGER [QMReqCacheManager sharedManager]

@class QMCommand;
/**
 *  该类处理dataversion缓存逻辑和断网时使用缓存的逻辑
 */
@interface QMReqCacheManager : NSObject

+ (instancetype)sharedManager;

/**
 *  请求成功后，缓存对应数据
 *
 *  @param responseObject   http请求返回的数据
 *  @param cmdIdentifier    标记请求的唯一字符串
 */
- (void)cacheObject:(id)responseObject forCommand:(NSString *)cmdIdentifier;

/** 本地缓存的对应请求的返回数据 */
- (id)cachedHTTPResponseForCommand:(NSString *)cmdIdentifier;

@end
