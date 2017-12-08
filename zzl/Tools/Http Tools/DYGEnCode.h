//
//  DYGEnCode.h
//  加密txt
//
//  Created by Mr_Du on 2017/8/16.
//  Copyright © 2017年 Mr_Du. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DYGEnCode : NSObject


/**
  加密方法

 @param string 传入原始字符串
 @return 返回 加密后的字符串
 */
+(NSString *)EncodeWithString:(NSString *)string;

/**
 解密方法

 @param string 传入加密后的字符串
 @return 返回解密后的字符串
 */
+(NSString *)DecodeWithEncodeString:(NSString *)string;

@end
