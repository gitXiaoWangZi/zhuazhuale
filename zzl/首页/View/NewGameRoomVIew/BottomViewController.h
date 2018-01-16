//
//  BottomViewController.h
//  MyTabbar
//
//  Created by Mr_Du on 2017/12/28.
//  Copyright © 2017年 Mr.Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LSJGameViewController;

@interface BottomViewController : UIViewController

@property (nonatomic,strong) LSJGameViewController *ganeViewC;
@property (nonatomic,strong) UIScrollView *bgScroV;
@property (nonatomic,strong) UITableView *leftTableV;
@property (nonatomic,strong) UITableView *rightTableV;
@property (nonatomic,copy) void(^diselectBlock)();

- (void)refrshCatchHistoryWithArr:(NSArray *)array;
- (void)refrshWaWaDetailsWithModel:(WwRoom *)model;
@end
