//
//  FXHomeSignPopView.h
//  zzl
//
//  Created by Mr_Du on 2017/11/23.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FXHomeSignPopView : UIView
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *monthBtn;
@property (weak, nonatomic) IBOutlet UIButton *weekBtn;

@property (nonatomic,strong) NSDictionary *dataDic;

@property (nonatomic,copy) void(^signActionBlock)(NSString *day);
@property (nonatomic,copy) void(^jumpWeekH5ActionBlock)(void);
@property (nonatomic,copy) void(^jumpMonthH5ActionBlock)(void);
@property (nonatomic,copy) void(^dismissAction)(void);
@end
