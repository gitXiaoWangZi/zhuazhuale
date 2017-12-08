//
//  UILabel+DYGAdd.m
//  test
//
//  Created by Mr_Du on 2017/10/29.
//  Copyright © 2017年 Mr_Du. All rights reserved.
//

#import "UILabel+DYGAdd.h"

@implementation UILabel (DYGAdd)
+(instancetype)labelWithFont:(CGFloat)font WithTextColor:(UIColor *)color{
    UILabel *lb = self.new;
    lb.font = [UIFont systemFontOfSize:font];
    lb.textColor = color;
    return lb;
}
+(instancetype)labelWithFont:(CGFloat)font WithTextColor:(UIColor *)color WithAlignMent:(NSTextAlignment)align{
    UILabel *lb = self.new;
    lb.font = [UIFont systemFontOfSize:font];
    lb.textColor = color;
    lb.textAlignment = align;
    return lb;
}
+(instancetype)labelWithBoldFont:(CGFloat)font WithTextColor:(UIColor *)color WithAlignMent:(NSTextAlignment)align{
    UILabel *lb = self.new;
    lb.font = [UIFont boldSystemFontOfSize:font];
    lb.textColor = color;
    lb.textAlignment = align;
    return lb;
}
+(instancetype)labelWithMediumFont:(CGFloat)font WithTextColor:(UIColor *)color{
    UILabel *lb = self.new;
    lb.font = [UIFont fontWithName:@"PingFangSC-Medium" size:font];
    lb.textColor = color;
    return lb;
}
@end
