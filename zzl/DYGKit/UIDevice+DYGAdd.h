//
//  UIDevice+DYGAdd.h
//  test
//
//  Created by Mr_Du on 2017/10/29.
//  Copyright © 2017年 Mr_Du. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (DYGAdd)
+(CGFloat)systermVersionNum;
+(BOOL)versionLater:(CGFloat)vNum;
@end
