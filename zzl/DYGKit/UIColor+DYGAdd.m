//
//  UIColor+DYGAdd.m
//  test
//
//  Created by Mr_Du on 2017/10/29.
//  Copyright © 2017年 Mr_Du. All rights reserved.
//

#import "UIColor+DYGAdd.h"

@implementation UIColor (DYGAdd)
-(const CGFloat *)getComponents{
    CGColorRef ref = self.CGColor;
    //是一个cgfloat数组 RGB颜色空间数组
    const CGFloat *compenets = CGColorGetComponents(ref);
    return compenets;
}
-(CGFloat)red
{
    const CGFloat *compenets = [self getComponents];
    return compenets[0];
}
-(CGFloat)green{
    const CGFloat *compenets = [self getComponents];
    return compenets[1];
}
-(CGFloat)blue{
    const CGFloat *compenets = [self getComponents];
    return compenets[2];
}
-(CGFloat)alpha{
    const CGFloat *compenets = [self getComponents];
    return compenets[3];
}
-(DYGColorSpaceComponents)colorSpaceComponents{
    const CGFloat *compenets = [self getComponents];
    DYGColorSpaceComponents colorCom;
    colorCom.red = compenets[0];
    colorCom.green = compenets[1];
    colorCom.blue = compenets[2];
    colorCom.alpha = compenets[3];
    return colorCom;
}
-(UIImage *)colorImage{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(1, 1), NO, [UIScreen mainScreen].scale);
    [self set];
    UIRectFill(CGRectMake(0, 0, 1, 1));
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha
{
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

@end
