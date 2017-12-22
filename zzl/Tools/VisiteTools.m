//
//  VisiteTools.m
//  zzl
//
//  Created by Mr_Du on 2017/12/21.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "VisiteTools.h"
#import "FXNavigationController.h"
#import "FXLoginHomeController.h"

@implementation VisiteTools

+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    static VisiteTools *tools = nil;
    dispatch_once(&onceToken, ^{
        tools = [[VisiteTools alloc] init];
    });
    return tools;
}

- (BOOL)isVisite {
    if ([KUID integerValue] == 5) {
        return YES;
    }else{
        return NO;
    }
}

- (void)outLogin{
    
    UIAlertController *alterC = [UIAlertController alertControllerWithTitle:@"请登录后使用" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [[WwUserInfoManager UserInfoMgrInstance] logout];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:KLoginStatus];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KUser_ID];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"KWAWAUSER"];
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        FXNavigationController *nav = [[FXNavigationController alloc] initWithRootViewController:[[FXLoginHomeController alloc] init]];
        window.rootViewController = nav;
    }];
    [alterC addAction:cancelAction];
    [alterC addAction:okAction];
    UIViewController *topRootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    [topRootViewController presentViewController:alterC animated:YES completion:nil];
}
@end
