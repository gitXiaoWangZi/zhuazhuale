//
//  LSJRechargeCell.m
//  zzl
//
//  Created by Mr_Du on 2018/1/5.
//  Copyright © 2018年 Mr.Du. All rights reserved.
//

#import "LSJRechargeCell.h"
#import "RechargeModel.h"

@interface LSJRechargeCell()

@end

@implementation LSJRechargeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpChildView];
    }
    return self;
}

- (void)setUpChildView{
    [self addSubview:self.iconImgV];
    [self.iconImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [self addSubview:self.titleL];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgV.mas_right).offset(5);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [self addSubview:self.desL];
    [self.desL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleL.mas_right).offset(10);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [self addSubview:self.songL];
    [self.songL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.desL.mas_right).offset(10);
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(@(Py(20)));
    }];
    self.songL.layer.cornerRadius = Py(10);
    self.songL.layer.masksToBounds = YES;
    [self addSubview:self.hotImgV];
    [self.hotImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.songL.mas_right).offset(5);
        make.bottom.equalTo(self.songL.mas_top).offset(5);
    }];
    [self addSubview:self.btn];
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@(Px(68)));
        make.height.equalTo(@(Py(27)));
    }];
    self.btn.layer.borderColor = DYGColorFromHex(0x999999).CGColor;
    self.btn.layer.borderWidth = 1;
    self.btn.layer.cornerRadius = Py(13.5);
    self.btn.layer.masksToBounds = YES;
    [self addSubview:self.selectImgV];
    [self.selectImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.btn.mas_right).offset(3);
        make.top.equalTo(self.btn.mas_top).offset(-5);
    }];
    self.selectImgV.hidden = YES;
}

- (void)fillPageWithData:(RechargeModel *)model isFirst:(BOOL)isFirst{
    _titleL.text = model.arrival;
    if (model.give.length == 0) {
        _desL.hidden = YES;
        _songL.hidden = YES;
    }else{
        _desL.hidden = NO;
        _songL.hidden = NO;
        _desL.text = model.give;
        _songL.text = [NSString stringWithFormat:@" %@   ",model.Percentage];
        if ([model.hot intValue] == 0) {//不火
            self.hotImgV.hidden = YES;
        }else{//火
            self.hotImgV.hidden = NO;
        }
    }
    NSString *num = [NSString stringWithFormat:@"¥%@",model.money];
    [_btn setTitle:num forState:UIControlStateNormal];
}

#pragma mark lazyload
- (UIImageView *)iconImgV{
    if (!_iconImgV) {
        _iconImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_diamo"]];
    }
    return _iconImgV;
}
- (UIImageView *)hotImgV{
    if (!_hotImgV) {
        _hotImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_charge_hot"]];
    }
    return _hotImgV;
}
- (UIImageView *)selectImgV{
    if (!_selectImgV) {
        _selectImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"address_selected"]];
    }
    return _selectImgV;
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc] init];
        _titleL.textColor = DYGColorFromHex(0x494848);
        _titleL.font = [UIFont systemFontOfSize:14];
    }
    return _titleL;
}
- (UILabel *)desL{
    if (!_desL) {
        _desL = [[UILabel alloc] init];
        _desL.textColor = DYGColorFromHex(0xff638b);
        _desL.font = [UIFont systemFontOfSize:14];
    }
    return _desL;
}
- (UILabel *)songL{
    if (!_songL) {
        _songL = [[UILabel alloc] init];
        _songL.textColor = DYGColorFromHex(0xff638b);
        _songL.font = [UIFont systemFontOfSize:10];
        _songL.backgroundColor = DYGColorFromHex(0xFEF1F4);
        _songL.textAlignment = NSTextAlignmentCenter;
    }
    return _songL;
}
- (UIButton *)btn{
    if (!_btn) {
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn setTitleColor:DYGColorFromHex(0x9b7000) forState:UIControlStateNormal];
        _btn.titleLabel.font = [UIFont systemFontOfSize:12];
        _btn.userInteractionEnabled = NO;
    }
    return _btn;
}
@end
