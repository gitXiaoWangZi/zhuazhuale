//
//  UIImage+DYGAdd.m
//  test
//
//  Created by Mr_Du on 2017/10/29.
//  Copyright © 2017年 Mr_Du. All rights reserved.
//

#import "UIImage+DYGAdd.h"

@implementation UIImage (DYGAdd)
+(instancetype)rendModeOriginalWithName:(NSString *)name{
    UIImage *image = [UIImage imageNamed:name];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return image;
}

+ (instancetype)getLaunchImage {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    NSString *orientation = @"Portrait";
    NSString *launchImageName = nil;
    NSArray *imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary *dic in imagesDict) {
        CGSize imageSize = CGSizeFromString(dic[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(screenSize, imageSize) && [dic[@"UILaunchImageOrientation"] isEqualToString:orientation]) {
            launchImageName = dic[@"UILaunchImageName"];
            break;
        }
    }
    return [UIImage imageNamed:launchImageName];
}
@end
