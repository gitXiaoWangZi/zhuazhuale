//
//  FXOrdingListViewController.h
//  zzl
//
//  Created by Mr_Du on 2017/11/29.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FXOrdingListViewController : UITableViewController

@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,assign) BOOL isDifference;//是否补差价过来的
@end
