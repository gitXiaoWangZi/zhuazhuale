//
//  DYGAlertHandleController.h
//  test
//
//  Created by Mr_Du on 2017/10/29.
//  Copyright © 2017年 Mr_Du. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DYGAlertHandleController : UIAlertController
+(instancetype)showMessageWithTitle:(NSString *)title WithMessage:(NSString *)message WithActionTitle:(NSString *)action FromViewController:(UIViewController *)vc WithActionHandle:(void(^)(void))handle;
@end
