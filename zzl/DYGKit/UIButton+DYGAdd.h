//
//  UIButton+DYGAdd.h
//  test
//
//  Created by Mr_Du on 2017/10/29.
//  Copyright © 2017年 Mr_Du. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (DYGAdd)

+(instancetype)buttonWithImage:(NSString *)imgName WithTitle:(NSString *)title WithColor:(UIColor *)color WithFont:(CGFloat)font;
+(instancetype)buttonWithImage:(NSString *)imgName WithHighlightedImage:(NSString *)highImg;
+(instancetype)buttonWithBgColor:(UIColor *)color WithHilightedBgColor:(UIColor *)hColor WithTille:(NSString *)title WithTitleColor:(UIColor *)titleColor WithFont:(CGFloat)font WithCornerRadius:(CGFloat)radius;
+(instancetype)buttonWithTitle:(NSString *)title titleColor:(UIColor *)color font:(CGFloat)font;
@end
