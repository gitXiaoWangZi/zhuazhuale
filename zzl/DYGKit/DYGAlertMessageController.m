//
//  DYGAlertMessageController.m
//  test
//
//  Created by Mr_Du on 2017/10/29.
//  Copyright © 2017年 Mr_Du. All rights reserved.
//

#import "DYGAlertMessageController.h"

@interface DYGAlertMessageController ()

@end

@implementation DYGAlertMessageController

+(instancetype)showMessageWithTitle:(NSString *)title WithMessage:(NSString *)message FromViewController:(UIViewController *)vc{
    DYGAlertMessageController *msgVc = [DYGAlertMessageController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [vc presentViewController:msgVc animated:NO completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [msgVc dismissViewControllerAnimated:NO completion:nil];
        });
    }];
    return msgVc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
