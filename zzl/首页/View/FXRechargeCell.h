//
//  FXRechargeCell.h
//  zzl
//
//  Created by Mr_Du on 2017/11/3.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FXRechargeCellDelegate<NSObject>

- (void)payActionWithMoney:(NSString *)num;
@end

@interface FXRechargeCell : UITableViewCell

@property (nonatomic,strong) UILabel *payType;
@property(nonatomic,strong)UIImageView * icon;
@property (nonatomic,strong) UIButton*seletBtn;
//@property (nonatomic,assign) BOOL isSelect;
@property (nonatomic,copy) NSString *firstpunch;

@property (nonatomic,weak) id<FXRechargeCellDelegate> delegate;
@end
