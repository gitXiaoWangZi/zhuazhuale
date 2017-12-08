//
//  UIButton+DYGAdd.m
//  test
//
//  Created by Mr_Du on 2017/10/29.
//  Copyright © 2017年 Mr_Du. All rights reserved.
//

#import "UIButton+DYGAdd.h"
#import "UIColor+DYGAdd.h"

@implementation UIButton (DYGAdd)
+(instancetype)buttonWithImage:(NSString *)imgName WithTitle:(NSString *)title WithColor:(UIColor *)color WithFont:(CGFloat)font{
    UIButton *btn = self.new;
    [btn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:font];
    [btn setTitleColor:color forState:UIControlStateNormal];
    return  btn;
}
+(instancetype)buttonWithImage:(NSString *)imgName WithHighlightedImage:(NSString *)highImg{
    UIButton *btn = self.new;
    [btn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highImg] forState:UIControlStateHighlighted];
    return  btn;
}
+(instancetype)buttonWithBgColor:(UIColor *)color WithHilightedBgColor:(UIColor *)hColor WithTille:(NSString *)title WithTitleColor:(UIColor *)titleColor WithFont:(CGFloat)font WithCornerRadius:(CGFloat)radius{
    UIButton *btn = self.new;
    [btn setBackgroundImage:[color colorImage] forState:UIControlStateNormal];
    [btn setBackgroundImage:[hColor colorImage] forState:UIControlStateHighlighted];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    btn.layer.cornerRadius = radius;
    btn.layer.masksToBounds = YES;
    btn.titleLabel.font = [UIFont systemFontOfSize:font];
    return btn;
}
+(instancetype)buttonWithTitle:(NSString *)title titleColor:(UIColor *)color font:(CGFloat)font{
    UIButton *btn = self.new;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:font];
    return btn;
}
@end
