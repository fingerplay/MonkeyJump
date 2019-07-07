//
//  QMReqCacheManager.m
//  juanpi3
//
//  Created by zagger on 15/8/11.
//  Copyright © 2015年 zagger. All rights reserved.
//

#import "TMCache.h"
#import "QMCommand.h"
#import "NSString+QMRequest.h"
#import "QMReqCacheManager.h"

static NSString * const kDatavertionKey = @"dataversion";

@implementation QMReqCacheManager

+ (instancetype)sharedManager {
    static QMReqCacheManager *__manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __manager = [[QMReqCacheManager alloc] init];
    });
    return __manager;
}

#pragma mark - Public Methods
//请求成功后，缓存对应数据
- (void)cacheObject:(id)responseObject forCommand:(NSString *)cmdIdentifier {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self saveHTTPResponse:responseObject forCommand:cmdIdentifier];
    });
}

#pragma mark - 保存、移除、获取，请求的数据版本，服务端数据版本未更新时，使用本地缓存的数据（部分接口需要）
- (void)saveDataVersion:(NSNumber *)dataVersion forCommand:(NSString *)cmdIdentifier {
    [[TMDiskCache sharedCache] setObject:dataVersion forKey:[self keyForCacheDataVersion:cmdIdentifier]];
}

- (void)removeCachedDataVersionForCommand:(NSString *)cmdIdentifier {
    [[TMDiskCache sharedCache] removeObjectForKey:[self keyForCacheDataVersion:cmdIdentifier]];
}

- (NSNumber *)cachedVersionForCommand:(NSString *)cmdIdentifier {
    return (NSNumber *)[[TMDiskCache sharedCache] objectForKey:[self keyForCacheDataVersion:cmdIdentifier]];
}

- (NSString *)keyForCacheDataVersion:(NSString *)cmdIdentifier {
    return [self cachedFileNameForKey:[NSString stringWithFormat:@"dv_%@",cmdIdentifier]];
}

#pragma mark - 保存、移除、获取，请求返回的数据
- (void)saveHTTPResponse:(id)responseObject forCommand:(NSString *)cmdIdentifier {
    [[TMDiskCache sharedCache] setObject:responseObject forKey:[self keyForCacheHTTPResponse:cmdIdentifier]];
}

- (void)removeCachedHTTPResponseForCommand:(NSString *)cmdIdentifier {
    [[TMDiskCache sharedCache] removeObjectForKey:[self keyForCacheHTTPResponse:cmdIdentifier]];
}

- (id)cachedHTTPResponseForCommand:(NSString *)cmdIdentifier {
    return [[TMDiskCache sharedCache] objectForKey:[self keyForCacheHTTPResponse:cmdIdentifier]];
}

- (NSString *)keyForCacheHTTPResponse:(NSString *)cmdIdentifier {
    return [self cachedFileNameForKey:[NSString stringWithFormat:@"rp_%@",cmdIdentifier]];
}


#pragma mark - Private Methods
- (NSString *)cachedFileNameForKey:(NSString *)key
{//32位MD5编码
    return [key MD5String];
}

@end
