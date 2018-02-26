//
//  MinePreferentialViewController.h
//  zzl
//
//  Created by Mr_Du on 2018/2/24.
//  Copyright © 2018年 Mr.Du. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LSJPreferentialModel;
@interface MinePreferentialViewController : UITableViewController

@property (nonatomic,copy) void(^usePreferTialBlock)(LSJPreferentialModel *model);
@end
