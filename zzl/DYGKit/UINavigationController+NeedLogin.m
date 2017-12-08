//
//  UINavigationController+NeedLogin.m
//  test
//
//  Created by Mr_Du on 2017/10/29.
//  Copyright © 2017年 Mr_Du. All rights reserved.
//

#import "UINavigationController+NeedLogin.h"
#import "DYGUserInfoManger.h"
@implementation UINavigationController (NeedLogin)
-(void)pushViewControllerNeedLogin:(UIViewController *)viewController animated:(BOOL)animated{
    UIViewController *pushVc = viewController;
    if (![[DYGUserInfoManger shareManager] isLogin]) {
//        DYGLoginController *loginVc = [DYGLoginController new];
//        [loginVc addLoginSuccessHandler:^{
//            if (viewController){
//                [self pushViewController:viewController animated:animated];
//            }
//        }];
//        pushVc = loginVc;
    }
    if (pushVc) {
        [self pushViewController:pushVc animated:animated];
    }
}
@end
