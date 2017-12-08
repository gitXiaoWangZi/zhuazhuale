//
//  UIButton+Position.h
//  beautyC
//
//  Created by 象萌cc002 on 2017/6/23.
//  Copyright © 2017年 象萌cc002. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XMImagePosition) {
    XMImagePositionLeft = 0,              //图片在左，文字在右
    XMImagePositionRight = 1,             //图片在右，文字在左
    XMImagePositionTop = 2,               //图片在上，文字在下
    XMImagePositionBottom = 3,            //图片在下，文字在上
};

@interface UIButton (Position)

/** 需要按钮设置好字体和frame,font后再调用该方法,不然方法无效 */
- (void)xm_setImagePosition:(XMImagePosition)postion titleFont:(UIFont *)font spacing:(CGFloat)spacing;
@end
