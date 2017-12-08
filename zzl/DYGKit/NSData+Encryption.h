//
//  NSData+Encryption.h
//  BocGuest
//
//  Created by 余小雨 on 15/10/19.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Encryption)

- (NSData *)AES256EncryptWithKey:(NSString *)key;   //加密
- (NSData *)AES256DecryptWithKey:(NSString *)key;   //解密

- (NSString *)newStringInBase64FromData;

+ (NSData*)stringToByte:(NSString*)string;

+ (NSString*)byteToString:(NSData*)data;




@end
