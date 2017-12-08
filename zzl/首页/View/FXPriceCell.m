//
//  FXPriceCell.m
//  zzl
//
//  Created by Mr_Du on 2017/11/3.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "FXPriceCell.h"

@interface FXPriceCell()

@property (nonatomic,strong) UIImageView * diamo;
@property (nonatomic,strong) UIView *line0;
@property (nonatomic,strong) UIView *line1;

@end

@implementation FXPriceCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    [self addSubview:self.firstIcon];
    [self.firstIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(Px(16));
        make.top.equalTo(self).offset(Py(10));
    }];
    [self addSubview:self.diamo];
    [self.diamo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.firstIcon);
        make.top.equalTo(self.firstIcon.mas_bottom).offset(Py(7));
    }];
    [self addSubview:self.money];
    [self.money mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.diamo.mas_right).offset(Px(7));
        make.centerY.equalTo(self.diamo);
    }];
    [self addSubview:self.pay];
    [self.pay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-Px(8));
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(Px(58), Py(24)));
    }];
    [self addSubview:self.line0];
    [self.line0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(Py(0));
        make.left.equalTo(self).offset(Py(0));
        make.right.equalTo(self).offset(Py(0));
        make.height.equalTo(@(1));
    }];
    [self addSubview:self.line1];
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(Py(0));
        make.bottom.equalTo(self).offset(Py(0));
        make.right.equalTo(self).offset(Py(0));
        make.width.equalTo(@(1));
    }];
}

-(UIButton *)pay{
    if (!_pay) {
        _pay = [UIButton buttonWithTitle:@"10" titleColor:systemColor font:16];
        [_pay setBackgroundColor:DYGColorFromHex(0xffffff)];
        _pay.cornerRadius = 2;
        _pay.layer.masksToBounds = YES;
        _pay.borderColor = systemColor;
        _pay.borderWidth = 1;
        _pay.userInteractionEnabled = NO;
    }
    return _pay;
}

-(UIImageView *)diamo{
    if (!_diamo) {
        _diamo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"price"]];
    }
    return _diamo;
}
-(UILabel *)money{
    if (!_money) {
        _money = [UILabel labelWithMediumFont:18 WithTextColor:systemColor];
        _money.text = @"100";
    }
    return _money;
}
-(UIImageView *)firstIcon{
    if (!_firstIcon) {
        _firstIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"firstPay"]];
    }
    return _firstIcon;
}

- (UIView *)line0{
    if (!_line0) {
        _line0 = [[UIView alloc] init];
        _line0.backgroundColor = BGColor;
    }
    return _line0;
}

- (UIView *)line1{
    if (!_line1) {
        _line1 = [[UIView alloc] init];
        _line1.backgroundColor = BGColor;
    }
    return _line1;
}

- (void)setIsFirst:(NSString *)isFirst{
    _isFirst = isFirst;
    if ([isFirst isEqualToString:@"YES"]) {
        [self.diamo mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.firstIcon);
            make.top.equalTo(self.firstIcon.mas_bottom).offset(Py(7));
        }];
        [self.money mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.diamo.mas_right).offset(Px(7));
            make.centerY.equalTo(self.diamo);
        }];
        [self.pay mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-Px(8));
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(Px(58), Py(24)));
        }];
    }else{
        [self.diamo mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.firstIcon);
            make.centerY.equalTo(self);
        }];
        [self.money mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.diamo.mas_right).offset(Px(7));
            make.centerY.equalTo(self.diamo);
        }];
        [self.pay mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-Px(8));
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(Px(58), Py(24)));
        }];
    }
}
@end
