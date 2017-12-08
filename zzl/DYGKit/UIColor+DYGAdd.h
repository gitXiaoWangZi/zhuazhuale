//
//  UIColor+DYGAdd.h
//  test
//
//  Created by Mr_Du on 2017/10/29.
//  Copyright © 2017年 Mr_Du. All rights reserved.
//

#import <UIKit/UIKit.h>
//匿名结构体 结构体的使用
typedef struct{
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alpha;
}DYGColorSpaceComponents;
@interface UIColor (DYGAdd)
-(CGFloat)red;
-(CGFloat)green;
-(CGFloat)blue;
-(CGFloat)alpha;
-(DYGColorSpaceComponents)colorSpaceComponents;
-(UIImage *)colorImage;
/**
 *  将16进制字符串转换成UIColor
 */
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;
@end
