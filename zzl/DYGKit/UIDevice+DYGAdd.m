//
//  UIDevice+DYGAdd.m
//  test
//
//  Created by Mr_Du on 2017/10/29.
//  Copyright © 2017年 Mr_Du. All rights reserved.
//

#import "UIDevice+DYGAdd.h"

@implementation UIDevice (DYGAdd)
+(CGFloat)systermVersionNum{
    return [[UIDevice currentDevice].systemVersion floatValue];
}
//判断系统版本号是否大于或等于指定版本
+(BOOL)versionLater:(CGFloat)vNum{
    CGFloat currentVNum = [self systermVersionNum];
    return currentVNum >= vNum;
}
@end
