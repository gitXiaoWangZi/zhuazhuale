//
//  LSJRechargeViewController.h
//  zzl
//
//  Created by Mr_Du on 2018/1/5.
//  Copyright © 2018年 Mr.Du. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AccountItem;
@interface LSJRechargeViewController : UITableViewController

@property (nonatomic,strong) AccountItem *item;
@property (nonatomic,copy) NSString *firstpunch;
@end
