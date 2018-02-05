//
//  LSJRechargeCell.h
//  zzl
//
//  Created by Mr_Du on 2018/1/5.
//  Copyright © 2018年 Mr.Du. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RechargeModel;
@interface LSJRechargeCell : UITableViewCell

@property (nonatomic,strong) UIImageView *iconImgV;
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UILabel *desL;
@property (nonatomic,strong) UILabel *songL;
@property (nonatomic,strong) UIButton *btn;
@property (nonatomic,strong) UIImageView *selectImgV;
@property (nonatomic,strong) UIImageView *hotImgV;

- (void)fillPageWithData:(RechargeModel *)model isFirst:(BOOL)isFirst;
@end
