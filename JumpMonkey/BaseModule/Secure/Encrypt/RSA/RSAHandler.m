//
//  RSAHandler.m
//  JumpMonkey
//
//  Created by 罗谨 on 2019/7/28.
//  Copyright © 2019 finger. All rights reserved.
//

#import "RSAHandler.h"
#import "x509.h"
#import "NSData+Base64.h"

@implementation RSAHandler
#pragma mark - ==============OpenSSL 方式=================
#pragma mark ---生成密钥对
+ (BOOL)generateRSAKeyPairWithKeySize:(int)keySize publicKey:(RSA **)publicKey privateKey:(RSA **)privateKey {
    
    if (keySize == 512 || keySize == 1024 || keySize == 2048) {
        
        /* 产生RSA密钥 */
        RSA *rsa = RSA_new();
        BIGNUM* e = BN_new();
        
        /* 设置随机数长度 */
        BN_set_word(e, 65537);
        
        /* 生成RSA密钥对 */
        RSA_generate_key_ex(rsa, keySize, e, NULL);
        
        if (rsa) {
            *publicKey = RSAPublicKey_dup(rsa);
            *privateKey = RSAPrivateKey_dup(rsa);
            return YES;
        }
    }
    return NO;
}

+ (NSString *)PEMFormatRSAKey:(RSA *)rsaKey isPublic:(BOOL)isPublickey
{
    if (!rsaKey) {
        return nil;
    }
    
    BIO *bio = BIO_new(BIO_s_mem());
    if (isPublickey)
        PEM_write_bio_RSA_PUBKEY(bio, rsaKey);
    
    else
    {
        //此方法生成的是pkcs1格式的,IOS中需要pkcs8格式的,因此通过PEM_write_bio_PrivateKey 方法生成
        // PEM_write_bio_RSAPrivateKey(bio, rsaKey, NULL, NULL, 0, NULL, NULL);
        
        EVP_PKEY* key = NULL;
        key = EVP_PKEY_new();
        EVP_PKEY_assign_RSA(key, rsaKey);
        PEM_write_bio_PrivateKey(bio, key, NULL, NULL, 0, NULL, NULL);
    }
    
    BUF_MEM *bptr;
    BIO_get_mem_ptr(bio, &bptr);
    BIO_set_close(bio, BIO_NOCLOSE); /* So BIO_free() leaves BUF_MEM alone */
    BIO_free(bio);
    return [NSString stringWithUTF8String:bptr->data];
    
}

#pragma mark ---加解密

+ (NSData *)decryptWithRSAKey:(RSA *)rsaKey cipherData:(NSData *)cipherData :(BOOL)isPubulic
{
    if ([cipherData length]) {
        int RSALenght = RSA_size(rsaKey);
        double totalLength = [cipherData length];
        int blockSize = RSALenght;
        int blockCount = ceil(totalLength / blockSize);
        NSMutableData *decrypeData = [NSMutableData data];
        for (int i = 0; i < blockCount; i++) {
            NSUInteger loc = i * blockSize;
            long dataSegmentRealSize = MIN(blockSize, totalLength - loc);
            NSData *dataSegment = [cipherData subdataWithRange:NSMakeRange(loc, dataSegmentRealSize)];
            const unsigned char *str = [dataSegment bytes];
            unsigned char *decrypt = malloc(RSALenght);
            memset(decrypt, 0, RSALenght);
            if (isPubulic) {
                if(RSA_public_decrypt(RSALenght,str,decrypt,rsaKey,RSA_PKCS1_PADDING)>=0){
                    NSInteger length =strlen((char *)decrypt);
                    NSData *data = [[NSData alloc] initWithBytes:decrypt length:length];
                    [decrypeData appendData:data];
                }
                
            }
            else
            {
                if(RSA_private_decrypt(RSALenght,str,decrypt,rsaKey,RSA_PKCS1_PADDING)>=0){
                    NSInteger length =strlen((char *)decrypt);
                    NSData *data = [[NSData alloc] initWithBytes:decrypt length:length];
                    [decrypeData appendData:data];
                }
            }
            free(decrypt);
        }
        
        return decrypeData;
    }
    
    return nil;
}

+ (NSString *)encryptWithRSAWithPlainData:(NSData *)plainData publicKey:(NSString*)publicKey
{
    
    BIO *bio = NULL;
    RSA *rsaKey = NULL;
    
    //从文件中读取公钥
    NSError *error;
    NSString *publicKeyPath = [[NSBundle mainBundle] pathForResource:@"server_public" ofType:@"pem"];
    NSString *textFileContents = [NSString
                                  stringWithContentsOfFile:publicKeyPath
                                  encoding:NSUTF8StringEncoding
                                  error:&error];
    if (textFileContents == nil) {
        return nil;
    }
    
//    char *pk = (char*)[publicKey UTF8String];
    if ((bio = BIO_new_mem_buf([textFileContents UTF8String], -1)) == NULL) {
        return nil;
    }
    
    rsaKey = PEM_read_bio_RSA_PUBKEY(bio, NULL, NULL, NULL);
    if (rsaKey == NULL) {
        BIO_free_all(bio);
        RSA_free(rsaKey);
        return nil;
    }
    
    //正常获取到RSA公钥对象后开始用公钥加密
    int rsaSize = RSA_size(rsaKey);
    NSInteger contentLen = [plainData length];
    NSInteger count = contentLen / rsaSize;
    NSInteger paddingSize = contentLen % rsaSize;
    if (paddingSize) {
        count++;
    }
    
    NSMutableData *encryptData = [NSMutableData data];
    for (int i = 0; i < count; i++) {
        NSInteger loc = i * rsaSize;
        NSInteger dataSegmentRealSize = MIN(rsaSize, contentLen - loc);
        NSData *dataSegment = [[plainData subdataWithRange:NSMakeRange(loc, dataSegmentRealSize)] mutableCopy];
        
        unsigned char *publicEncrypt = malloc(rsaSize);
        memset(publicEncrypt, 0, rsaSize);
        
        const unsigned char *str = [dataSegment bytes];
        if (dataSegmentRealSize < rsaSize) {
            NSMutableData *tempData = [[NSMutableData alloc]initWithLength:(rsaSize-dataSegmentRealSize)];
            [tempData resetBytesInRange:NSMakeRange(0, tempData.length)];
            NSMutableData *temp = [dataSegment mutableCopy];
            [temp appendData:tempData];
            str = [temp bytes];
            dataSegmentRealSize = rsaSize;
        }
 
        if(RSA_public_encrypt((int)dataSegmentRealSize, (const unsigned char *)str, (unsigned char*)publicEncrypt, rsaKey, RSA_NO_PADDING) >= 0) {
            NSData *tempEncryptData = [[NSData alloc] initWithBytes:publicEncrypt length:rsaSize];
            [encryptData appendData:tempEncryptData];
        }
        
        free(publicEncrypt);
    }
    BIO_free_all(bio);
    RSA_free(rsaKey);
    
    return [encryptData base64EncodedString];
}
@end
