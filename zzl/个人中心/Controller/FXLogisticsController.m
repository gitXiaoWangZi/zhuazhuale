//
//  FXLogisticsController.m
//  zzl
//
//  Created by Mr_Du on 2017/11/14.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "FXLogisticsController.h"

@interface FXLogisticsController ()

@property(nonatomic,strong) UIImageView *icon;
@property (nonatomic,strong) UILabel * company;
@property (nonatomic,strong) UILabel *companyTitle;
@property (nonatomic,strong) UILabel * num;
@property (nonatomic,strong) UILabel *numTitle;
@property (nonatomic,strong) UILabel * phone;
@property (nonatomic,strong) UILabel *phoneTitle;
@property (nonatomic,strong) UIButton *btnCopy;
@property (nonatomic,strong) UIView * line;
@property (nonatomic,strong) UIButton * sure;

@end

@implementation FXLogisticsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查看物流";
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatUI];
}
-(void)creatUI{
    [self.view addSubview:self.icon];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(Px(16));
        make.top.equalTo(self.view).offset(Py(15));
        make.size.mas_equalTo(CGSizeMake(Px(70), Py(70)));
    }];
    [self.view addSubview:self.companyTitle];
    [self.companyTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.icon);
        make.left.equalTo(self.icon.mas_right).offset(Px(10));
    }];
    [self.view addSubview:self.company];
    [self.company mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.companyTitle);
        make.left.equalTo(self.companyTitle.mas_right);
    }];
    [self.view addSubview:self.numTitle];
    [self.numTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.companyTitle);
        make.centerY.equalTo(self.icon);
    }];
    [self.view addSubview:self.num];
    [self.num mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.numTitle);
        make.left.equalTo(self.numTitle.mas_right);
    }];
    [self.view addSubview:self.phoneTitle];
    [self.phoneTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.numTitle);
        make.bottom.equalTo(self.icon);
    }];
    [self.view addSubview:self.phone];
    [self.phone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.phoneTitle);
        make.left.equalTo(self.phoneTitle.mas_right);
    }];
    [self.view addSubview:self.btnCopy];
    [self.btnCopy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.icon);
        make.right.equalTo(self.view).offset(-Px(15));
        make.size.mas_equalTo(CGSizeMake(Px(47), Py(21)));
    }];
    [self.view addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.icon.mas_bottom).offset(Py(15));
        make.width.equalTo(self.view);
        make.height.equalTo(@1);
    }];
    [self.view addSubview:self.sure];
    [self.sure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line.mas_bottom).offset(Py(15));
        make.right.equalTo(self.line).offset(-Px(16));
        make.size.mas_equalTo(CGSizeMake(Px(80), Py(30)));
    }];
}


#pragma mark  lazy load
-(UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc]init];
        _icon.image = [UIColor whiteColor].colorImage;
        _icon.cornerRadius = Px(35);
        _icon.layer.masksToBounds = YES;
        _icon.borderColor = systemColor;
        _icon.borderWidth =1;
    }
    return _icon;
}

-(UILabel *)companyTitle{
    if (!_companyTitle) {
        _companyTitle = [UILabel labelWithFont:14 WithTextColor:DYGColorFromHex(0x4c4c4c)];
        _companyTitle.text = @"物流公司:";
    }
    return _companyTitle;
}

-(UILabel *)company{
    if (!_company) {
        _company = [UILabel labelWithFont:14 WithTextColor:DYGColorFromHex(0x4c4c4c)];
        _company.text = @"韵达快递";
    }
    return _company;
}
-(UILabel *)numTitle{
    if (!_numTitle) {
        _numTitle = [UILabel labelWithFont:14 WithTextColor:DYGColorFromHex(0x4c4c4c)];
        _numTitle.text =@"运单编号:";
    }
    return _numTitle;
}
-(UILabel *)num{
    if (!_num) {
        _num = [UILabel labelWithFont:14 WithTextColor:DYGColorFromHex(0x4c4c4c)];
        _num.text = @"1562827383832";
    }
    return _num;
}
-(UILabel *)phoneTitle{
    if (!_phoneTitle) {
        _phoneTitle = [UILabel labelWithFont:14 WithTextColor:DYGColorFromHex(0x4c4c4c)];
        _phoneTitle.text = @"物流电话:";
    }
    return _phoneTitle;
}
-(UILabel *)phone{
    if (!_phone) {
        _phone = [UILabel labelWithFont:14 WithTextColor:DYGColorFromHex(0x6ce0ff)];
        _phone.text = @"95311";
    }
    return _phone;
}

-(UIButton *)btnCopy{
    if (!_btnCopy) {
        _btnCopy = [UIButton buttonWithTitle:@"复制" titleColor:DYGColorFromHex(0x4c4c4c) font:14];
        _btnCopy.cornerRadius = 5;
        _btnCopy.layer.masksToBounds = YES;
        _btnCopy.borderColor = DYGColorFromHex(0x4c4c4c);
        _btnCopy.borderWidth = 1;
    }
    return _btnCopy;
}

-(UIView *)line{
    if (!_line) {
        _line = [UIView new];
        _line.backgroundColor = DYGColorFromHex(0xe6e6e6);
    }
    return _line;
}

-(UIButton *)sure{
    if (!_sure) {
        _sure = [UIButton buttonWithTitle:@"确认收货" titleColor:systemColor font:14];
        _sure.cornerRadius = 15;
        _sure.layer.masksToBounds = YES;
        _sure.borderColor = systemColor;
        _sure.borderWidth = 1;
    }
    return _sure;
}



@end

















