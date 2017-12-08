//
//  UIImage+ScaledSize.m
//  TJProperty
//
//  Created by BOC on 15/7/25.
//  Copyright (c) 2015年 bocweb. All rights reserved.
//

#import "UIImage+ScaledSize.h"

@implementation UIImage (ScaledSize)



- (UIImage *)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
