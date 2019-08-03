/*
 http://www.imcore.net | hosihito@gmail.com
 Developer. Kyoungbin Lee
 2012.05.25

 AES256 EnCrypt / DeCrypt
*/

#import <Foundation/Foundation.h>

@interface NSData (AESAdditions)
- (NSData*)AES128NoPaddingCBCEncryptWithKey:(NSString*)key;
- (NSData*)AES128PKCS7PaddingECBEncryptWithKey:(NSString*)key;

- (NSData*)AES256EncryptWithKey:(NSString*)key;
- (NSData*)AES256DecryptWithKey:(NSString*)key;

@end
