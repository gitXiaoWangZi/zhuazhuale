//
//  FXSpoilsCell.h
//  zzl
//
//  Created by Mr_Du on 2017/11/8.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FXSpoilsCell : UITableViewCell

@property (nonatomic,assign) BOOL isShow;
@property (nonatomic,strong) WwWawaDepositModel *model;
@property (nonatomic,strong) WwWawaOrderItem *item;
@property (nonatomic,strong) UIButton *isSelectBtn;
@end
