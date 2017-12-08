//
//  DYGAlertHandleController.m
//  test
//
//  Created by Mr_Du on 2017/10/29.
//  Copyright © 2017年 Mr_Du. All rights reserved.
//

#import "DYGAlertHandleController.h"

@interface DYGAlertHandleController ()

@end

@implementation DYGAlertHandleController

+(instancetype)showMessageWithTitle:(NSString *)title WithMessage:(NSString *)message WithActionTitle:(NSString *)action FromViewController:(UIViewController *)vc WithActionHandle:(void(^)(void))handle{
    DYGAlertHandleController *alertVc = [DYGAlertHandleController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alertVc addAction:[UIAlertAction actionWithTitle:action style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        handle();
    }]];
    [vc presentViewController:alertVc animated:YES completion:nil];
    return alertVc;
}
@end
