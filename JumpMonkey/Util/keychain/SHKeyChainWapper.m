//
//  SHKeyChainWapper.m
//  SmartHome
//
//  Created by hd on 2017/7/20.
//  Copyright © 2017年 EverGrande. All rights reserved.
//

#import "SHKeyChainWapper.h"

@implementation SHKeyChainWapper

#pragma mark - Base64编码

static NSData *base64_decode(NSString *str){
    NSData *data = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return data;
}

#pragma mark 写入

+ (BOOL)addKeyChainWithRSASecKey:(SecKeyRef)SecKey identifier:(NSString *)identifier isPublicKey:(BOOL)isPublickey{
    
    NSMutableDictionary * queryKey = [self getSecKeyRefKeychainQuery:identifier isPublicKey:isPublickey];
    
    [queryKey setObject:(__bridge id)SecKey forKey:(__bridge id)kSecValueRef];
    
    return [self saveQueryKey:queryKey identfier:identifier isPublicKey:isPublickey]?YES:NO;
    
}

+ (SecKeyRef)saveQueryKey:(NSDictionary *)dict identfier:(NSString *)identifier isPublicKey:(BOOL)isPublickey
{
    
    OSStatus status = noErr;
    CFTypeRef result;
    CFDataRef keyData = NULL;
    //如果已经存在,先删除原来的在重新写入
    if (SecItemCopyMatching((__bridge CFDictionaryRef) dict, (CFTypeRef *)&keyData) == noErr) {
        
        [self deleteRASKeyWithIdentifier:identifier isPublicKey:isPublickey];
        status = SecItemAdd((__bridge CFDictionaryRef) dict, &result);
        
        if (status == errSecSuccess) {
            return [self loadSecKeyRefWithIdentifier:identifier isPublicKey:isPublickey];
        }
    }
    
    status = SecItemAdd((__bridge CFDictionaryRef) dict, &result);
    if (status == errSecSuccess) {
        return [self loadSecKeyRefWithIdentifier:identifier isPublicKey:isPublickey];
    }
    
    return nil;
}


+ (BOOL)savePassWordDataWithdIdentifier:(NSString *)identifier data:(id)data accessGroup:(NSString *) accessGroup{
    
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:identifier accessGroup:accessGroup];
    //Delete old item before add new item
    SecItemDelete((CFDictionaryRef)keychainQuery);
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    //Add item to keychain with the search dictionary
    OSStatus status =  SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
    if (status != noErr) {
        return NO;
    }
    return YES;
}

+ (BOOL)saveStringWithdIdentifier:(NSString *)identifier data:(NSString *)str;
{
    
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:identifier accessGroup:nil];
    //Delete old item before add new item
    SecItemDelete((CFDictionaryRef)keychainQuery);
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:str] forKey:(id)kSecValueData];
    //Add item to keychain with the search dictionary
    OSStatus status =  SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
    if (status != noErr) {
        return NO;
    }
    return YES;
    
}
#pragma mark 读取
+ (id)loadPassWordDataWithIdentifier:(NSString *)identifier accessGroup:(NSString *) accessGroup
{
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:identifier accessGroup:accessGroup];
    //Configure the search setting
    //Since in our simple case we are expecting only a single attribute to be returned (the password) we can set the attribute kSecReturnData to kCFBooleanTrue
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            
        } @finally {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}
+ (SecKeyRef)loadSecKeyRefWithIdentifier:(NSString *)identifier isPublicKey:(BOOL)isPublickey;
{
    
    NSMutableDictionary *keychainQuery =[self getSecKeyRefKeychainQuery:identifier isPublicKey:isPublickey];
    CFDataRef keyData = NULL;
    //如果已经存在,先删除原来的在重新写入
    if (SecItemCopyMatching((__bridge CFDictionaryRef) keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        return (SecKeyRef)keyData;
    }
    
    return nil;
}

//返回需要的 key 字符串
+ (NSString *)base64EncodedFromPEMFormat:(NSString *)PEMFormat
{
    /*
     -----BEGIN RSA PRIVATE KEY-----
     中间是需要的 key 的字符串
     -----END RSA PRIVATE KEY----
     */
    
    PEMFormat = [PEMFormat stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    PEMFormat = [PEMFormat stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    PEMFormat = [PEMFormat stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    PEMFormat = [PEMFormat stringByReplacingOccurrencesOfString:@" "  withString:@""];
    if (![PEMFormat containsString:@"-----"]) {
        return PEMFormat;
    }
    NSString *key = [[PEMFormat componentsSeparatedByString:@"-----"] objectAtIndex:2];
    
    
    
    return key?key:PEMFormat;
}

#pragma mark - 通用方法

+ (NSMutableDictionary *)getSecKeyRefKeychainQuery:(NSString *)identifier isPublicKey:(BOOL)isPublickey{
    
    NSData *d_tag = [NSData dataWithBytes:[identifier UTF8String] length:[identifier length]];
    NSMutableDictionary *publickey =[[NSMutableDictionary alloc]init];
    [publickey setObject:(__bridge id) kSecClassKey forKey:(__bridge id)kSecClass];
    [publickey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id) kSecAttrKeyType];
    [publickey setObject:d_tag forKey:(__bridge id)kSecAttrApplicationTag];
    [publickey setObject:(id)(isPublickey?kSecAttrKeyClassPublic:kSecAttrKeyClassPrivate) forKey:(id)kSecAttrKeyClass];
    [publickey setObject:@YES forKey:(__bridge id) kSecReturnRef];
    
    return publickey;
}


//获取通用密码类型的一个查询体
+ (NSMutableDictionary *)getKeychainQuery:(NSString *)identifier accessGroup:(NSString *)accessGroup
{
    
    
    
    NSMutableDictionary *dic =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                               (id)kSecClassGenericPassword,(id)kSecClass,
                               identifier, (id)kSecAttrAccount,//一般密码
                               (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible,
                               nil];
    if (accessGroup) {
        [dic setObject:accessGroup forKey:(id)kSecAttrAccessGroup];
        [dic setObject:identifier forKey:(id)kSecAttrGeneric];
        
        /*
         kSecAttrAccessGroup
         
         如果希望这个keychain的item可以被多个应用share，可以给这个item设置这个属性，类型是CFStringRef。应用程序在被编译时，可以在entitlement中指定自己的accessgroup，如果应用的accessgroup名字和keychain item的accessgroup名字一致，那这个应用就可以访问这个item，不过这个设计并不是很好，因为应用的accessgroup是由应用开发者指定的，它可以故意跟其他应用的accessgroup一样，从而访问其他应用的item，更可怕的是还支持wildcard，比如keychain-dumper将自己的accessgroup指定为*，从而可以把keychain中的所有item都dump出来。
         实测,如果设置了这个属性,读取写入的时候会出现-34018错误,应该是这个属性会迫使 app 检测是否开启了 group id 证书.
         如果想要实现分享 keychain 给别的 App 共享,这个基本的功能,可以这样做
         
         需要开启 Tag-Capabilities-Share KeyChian 选项
         在keychain sharing 里添加你要分享的另一个APP的bundle ID
         但是这样也会出现,如果知道你的谋和 app 的 bundleID 就能读取你的 item的情况出现.
         所以如果想要实现安全的 kechain 公钥,需要配合 groupid实现比较好.但是需要证书支持才可以.
         */
        
    }
    return dic;
}

#pragma mark - Delete RSA key
+ (BOOL)deleteRASKeyWithIdentifier:(NSString *)identifier isPublicKey:(BOOL)isPublickey {
    OSStatus status = noErr;
    NSMutableDictionary * queryKey = [self getSecKeyRefKeychainQuery:identifier isPublicKey:isPublickey];
    status = SecItemDelete((__bridge CFDictionaryRef) queryKey);
    
    return status ==noErr;
    
}


@end
