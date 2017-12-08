//
//  DYGAlertMessageController.h
//  test
//
//  Created by Mr_Du on 2017/10/29.
//  Copyright © 2017年 Mr_Du. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DYGAlertMessageController : UIAlertController
+(instancetype)showMessageWithTitle:(NSString *)title WithMessage:(NSString *)message  FromViewController:(UIViewController *)vc;
@end
