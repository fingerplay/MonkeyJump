//
//  SHKeyChainWapper.h
//  SmartHome
//
//  Created by hd on 2017/7/20.
//  Copyright © 2017年 EverGrande. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHKeyChainWapper : NSObject


/**
 删除密钥对
 
 @param identifier 密钥的 tag 标志
 @param isPublickey 是否是公钥
 @return 返回是否删除成功
 */
+ (BOOL)deleteRASKeyWithIdentifier:(NSString *)identifier isPublicKey:(BOOL)isPublickey;

/**
 通过 tag 获取密钥
 
 @param identifier 密钥的 tag
 @param isPublickey 是否是公钥
 @return 取到的密钥
 */
+ (SecKeyRef)loadSecKeyRefWithIdentifier:(NSString *)identifier isPublicKey:(BOOL)isPublickey;

/**
 通过 tag 获取数据
 
 @param identifier 密钥的 tag
 @param accessGroup 访问group
 @return 取到的数据
 */
+ (id)loadPassWordDataWithIdentifier:(NSString *)identifier accessGroup:(NSString *) accessGroup;

/**
 通过 tag 保存数据
 
 @param identifier  密钥的tag
 @param accessGroup 访问group
 @param data        要写入的数据
 @return            写入是否成功还是失败
 */
+ (BOOL)savePassWordDataWithdIdentifier:(NSString *)identifier data:(id)data accessGroup:(NSString *) accessGroup;



@end










