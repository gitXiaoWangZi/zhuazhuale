//
//  UILabel+DYGAdd.h
//  test
//
//  Created by Mr_Du on 2017/10/29.
//  Copyright © 2017年 Mr_Du. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (DYGAdd)
+(instancetype)labelWithFont:(CGFloat)font WithTextColor:(UIColor *)color;
+(instancetype)labelWithFont:(CGFloat)font WithTextColor:(UIColor *)color WithAlignMent:(NSTextAlignment)align;
+(instancetype)labelWithBoldFont:(CGFloat)font WithTextColor:(UIColor *)color WithAlignMent:(NSTextAlignment)align;
+(instancetype)labelWithMediumFont:(CGFloat)font WithTextColor:(UIColor *)color;
@end
