//
//  DYGCustomTabbar.h
//  UD
//
//  Created by Mr_Du on 2017/6/26.
//  Copyright © 2017年 FanXing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DYGCustomTabbar;

@protocol DYGCustomTabbarDelegate <NSObject>

- (void)addButtonClick:(DYGCustomTabbar *)tabBar;

@end

@interface DYGCustomTabbar : UITabBar

@property (nonatomic,weak) id<DYGCustomTabbarDelegate> myTabBarDelegate;

@end
