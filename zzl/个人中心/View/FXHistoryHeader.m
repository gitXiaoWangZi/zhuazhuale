//
//  FXHistoryHeader.m
//  zzl
//
//  Created by Mr_Du on 2017/11/8.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "FXHistoryHeader.h"
@interface FXHistoryHeader()
@property (nonatomic,strong) UIView *centerV;
@property (nonatomic,strong) UILabel *titleL;
@end

@implementation FXHistoryHeader

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    self.backgroundColor = DYGColorFromHex(0xf7f7f7);
    [self addSubview:self.centerV];
    [self.centerV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(Py(14));
        make.left.equalTo(self.mas_left).offset(Px(12));
        make.right.equalTo(self.mas_right).offset(-Px(12));
        make.height.equalTo(@(Py(98)));
    }];
    [self.centerV addSubview:self.money];
    [self.money mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerV.mas_centerX);
        make.top.equalTo(self.centerV.mas_top).offset(Py(24));
    }];
    [self.centerV addSubview:self.titleL];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerV.mas_centerX);
        make.top.equalTo(self.money.mas_bottom).offset(Py(0));
    }];
    [self addSubview:self.imgView];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(Py(62));
    }];
}

-(UIView *)centerV{
    if (!_centerV) {
        _centerV = [[UIView alloc] init];
        _centerV.backgroundColor = DYGColorFromHex(0xffffff);
        _centerV.layer.cornerRadius = 10;
        _centerV.layer.shadowColor = DYGColorFromHex(0xececec).CGColor;
        _centerV.layer.shadowOffset = CGSizeMake(0, 0);
        _centerV.layer.shadowOpacity = 0.3;
        _centerV.layer.shadowRadius = 1;
    }
    return _centerV;
}

-(UILabel *)money{
    if (!_money) {
        _money = [[UILabel alloc] init];
        _money.font = kPingFangSC_Semibold(24);
        _money.textColor = DYGColorFromHex(0x3b3b3b);
        _money.textAlignment = NSTextAlignmentCenter;
    }
    return _money;
}

-(UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc] init];
        _titleL.font = [UIFont systemFontOfSize:14];
        _titleL.textColor = DYGColorFromHex(0x9e9e9e);
        _titleL.textAlignment = NSTextAlignmentCenter;
        _titleL.text = @"钻石";
    }
    return _titleL;
}

-(UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mine_pay_octopus"]];
    }
    return _imgView;
}

@end
