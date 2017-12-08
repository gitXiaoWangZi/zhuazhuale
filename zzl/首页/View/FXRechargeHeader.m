//
//  FXRechargeHeader.m
//  zzl
//
//  Created by Mr_Du on 2017/11/3.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "FXRechargeHeader.h"

@interface FXRechargeHeader()
@property(nonatomic,strong)UIImageView * bgImg;
@property (nonatomic,strong) UILabel *title;

@end

@implementation FXRechargeHeader

-(instancetype)initWithFrame:(CGRect)frame{
    if (self= [super initWithFrame:frame]) {
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    [self addSubview:self.bgImg];
    [self.bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.centerX.equalTo(self);
        make.width.equalTo(@(Px(342)));
    }];
    [self.bgImg addSubview:self.money];
    [self.money mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(Py(50));
        make.size.mas_equalTo(CGSizeMake(Px(108), Py(32)));
    }];
    [self.bgImg addSubview:self.title];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-Py(16));
    }];
}

-(UILabel *)title{
    if (!_title) {
        _title = [UILabel labelWithFont:18 WithTextColor:DYGColorFromHex(0xffffff)];
        _title.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
        _title.text =@"我的钻石";
        _title.textAlignment = NSTextAlignmentCenter;
    }
    return _title;
}
-(UILabel *)money{
    if (!_money) {
        _money = [UILabel new];
        _money.font = [UIFont fontWithName:@"PingFangSC-Medium" size:30];
        _money.textAlignment = NSTextAlignmentCenter;
        _money.textColor = DYGColorFromHex(0xffffff);
    }
    return _money;
}
-(UIImageView *)bgImg{
    if (!_bgImg) {
        _bgImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rechargeBg"]];
    }
    return _bgImg;
}

@end
