//
//  DYGCustomTabbar.m
//  UD
//
//  Created by Mr_Du on 2017/6/26.
//  Copyright © 2017年 FanXing. All rights reserved.
//

#import "DYGCustomTabbar.h"
#import "UIView+DYGAdd.h"
#import "UIImage+DYGAdd.h"
#import "FXGameWaitController.h"
@interface DYGCustomTabbar()

@property(nonatomic,weak)UIButton * rechangeBtn;

@end

@implementation DYGCustomTabbar

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
//        [self setShadowImage:[UIImage imageWithColor:DYGColorFromHex(0x1da)];
        UIButton * rechangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rechangeBtn setBackgroundImage:[UIImage imageNamed:@"logo_center"] forState:UIControlStateNormal];
        [rechangeBtn setBackgroundImage:[UIImage imageNamed:@"logo_center"] forState:UIControlStateHighlighted];
        rechangeBtn.size = rechangeBtn.currentBackgroundImage.size;
        rechangeBtn.titleEdgeInsets = UIEdgeInsetsMake(67, 0, 0, 0);
        [self addSubview:rechangeBtn];
        [rechangeBtn addTarget:self action:@selector(rechangeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        self.rechangeBtn = rechangeBtn;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.rechangeBtn.centerX = self.width * 0.5;
    self.rechangeBtn.y = -self.rechangeBtn.height*0.4;
    NSInteger count = self.subviews.count;
    CGFloat btnWidth = self.width/3;
    NSInteger index = 0 ;
    for (int i = 0; i<count; i++) {
        UIView * childView = self.subviews[i];
        if ([childView isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            childView.width = btnWidth;
            childView.x = btnWidth * index;
            index ++;
            if (index==1) {
                index++;
            }
        }
        }
}
-(void)rechangeBtnClick{
    
    if ([self.myTabBarDelegate respondsToSelector:@selector(addButtonClick:)]) {
        [self.myTabBarDelegate addButtonClick:self];
    }

}

//重写hitTest方法，去监听发布按钮的点击，目的是为了让凸出的部分点击也有反应
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    //这一个判断是关键，不判断的话push到其他页面，点击发布按钮的位置也是会有反应的，这样就不好了
    //self.isHidden == NO 说明当前页面是有tabbar的，那么肯定是在导航控制器的根控制器页面
    //在导航控制器根控制器页面，那么我们就需要判断手指点击的位置是否在发布按钮身上
    //是的话让发布按钮自己处理点击事件，不是的话让系统去处理点击事件就可以了
        if (self.isHidden == NO) {
    
            //将当前tabbar的触摸点转换坐标系，转换到发布按钮的身上，生成一个新的点
            CGPoint newP = [self convertPoint:point toView:self.rechangeBtn];
            
            //判断如果这个新的点是在发布按钮身上，那么处理点击事件最合适的view就是发布按钮
            if ( [self.rechangeBtn pointInside:newP withEvent:event]) {
                return self.rechangeBtn;
            }else{//如果点不在发布按钮身上，直接让系统处理就可以了
                
                return [super hitTest:point withEvent:event];
            }
        }else {//tabbar隐藏了，那么说明已经push到其他的页面了，这个时候还是让系统去判断最合适的view处理就好了
            return [super hitTest:point withEvent:event];
        }
}

@end
