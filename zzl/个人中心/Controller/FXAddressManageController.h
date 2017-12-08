//
//  FXAddressManageController.h
//  zzl
//
//  Created by Mr_Du on 2017/11/6.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FXAddressManageController : UIViewController

@property (nonatomic,copy) NSString *isMine;
@property (nonatomic,copy) void(^getAddressModelBlock)(WwAddressModel *model);
@end
