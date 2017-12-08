//
//  NSString+DYGAdd.h
//  test
//
//  Created by Mr_Du on 2017/10/29.
//  Copyright © 2017年 Mr_Du. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (DYGAdd)
//是否纯数字
-(BOOL)isPureNum;
-(instancetype)translateToMandarinLatin;//转换成汉语拼音 不带音调
-(instancetype)firstLetter; //首字母
//手机号判断
-(BOOL)isValidMobile;
//字体size
-(CGSize)sizeForFont:(UIFont *)font size:(CGSize)size;
//字体高度
-(CGFloat)heightWithFont:(UIFont *)font;
//字体宽度
-(CGFloat)widthWithFont:(UIFont *)font;
/**
  获得当前时间并且转为字符串
 @return string
 */
-(NSString *)dateTransformToTimeString;
/**
 获取当前时间转为时间戳
 @return string
 */
- (NSString *)dateTransformToTimeSp;
-(NSString *)dataNowYear;

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;
@end
