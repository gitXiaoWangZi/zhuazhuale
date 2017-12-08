//
//  FXTaskCell.h
//  zzl
//
//  Created by Mr_Du on 2017/11/14.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FXTaskModel;
@interface FXTaskCell : UITableViewCell

@property(nonatomic,strong)UIImageView * icon;
@property (nonatomic,strong) UILabel *title;
@property (nonatomic,strong) UIButton *btn;

@property (nonatomic,strong) FXTaskModel *model;

@end
