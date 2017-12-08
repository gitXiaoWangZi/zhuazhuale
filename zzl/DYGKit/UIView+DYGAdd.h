//
//  UIView+DYGAdd.h
//  zzl
//
//  Created by Mr_Du on 2017/10/30.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface UIView (DYGAdd)
@property (nonatomic, assign)CGFloat x;
@property (nonatomic, assign)CGFloat y;
@property (nonatomic, assign)CGFloat width;
@property (nonatomic, assign)CGFloat height;
@property (nonatomic, assign)CGFloat centerX;
@property (nonatomic, assign)CGFloat centerY;
@property (nonatomic, assign)CGSize size;
@property(nonatomic, assign) IBInspectable CGFloat borderWidth;
@property(nonatomic, assign) IBInspectable UIColor *borderColor;
@property(nonatomic, assign) IBInspectable CGFloat cornerRadius;

/**
 *  水平居中
 */
- (void)alignHorizontal;
/**
 *  垂直居中
 */
- (void)alignVertical;
/**
 *  判断是否显示在主窗口上面
 *
 *  @return 是否
 */
- (BOOL)isShowOnWindow;

- (UIViewController *)parentController;
-(void)removeAllSubViews; //移除所有子控件

+(instancetype)viewWithFrame:(CGRect)frame;
+(instancetype)viewWithFrame:(CGRect)frame WithBackGroundColor:(UIColor *)color;
-(UIImage *)snapshotImage;
+(instancetype)viewWithColor:(UIColor *)color;
@end
