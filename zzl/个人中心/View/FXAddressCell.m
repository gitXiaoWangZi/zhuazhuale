//
//  FXAddressCell.m
//  zzl
//
//  Created by Mr_Du on 2017/11/7.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "FXAddressCell.h"

@interface FXAddressCell()

@property(nonatomic,strong)UILabel *name;
@property (nonatomic,strong) UILabel *phone;
@property (nonatomic,strong) UILabel *address;
@property (nonatomic,strong) UIView *line;
@property (nonatomic,strong) UIButton * defaultBtn;
@property (nonatomic,strong) UIButton *edit;
@property (nonatomic,strong) UIButton *delete;


@end

@implementation FXAddressCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self creatUI];
    }
    return self;
}


-(void)creatUI{
    [self addSubview:self.name];
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(Px(15));
        make.top.equalTo(self).offset(Py(23));
    }];
    [self addSubview:self.phone];
    [self.phone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.name);
        make.right.equalTo(self).offset(-Px(16));
    }];
    [self addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self);
        make.height.equalTo(@1);
        make.bottom.equalTo(self).offset(-Py(45));
    }];
    [self addSubview:self.address];
    [self.address mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.name);
        make.right.equalTo(self.phone);
        make.top.equalTo(self.name.mas_bottom).offset(Py(16));
        make.bottom.equalTo(self.line.mas_top).offset(-Py(12));
    }];
    [self addSubview:self.defaultBtn];
    [self.defaultBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line).offset(Py(15));
        make.bottom.equalTo(self).offset(-Py(15));
        make.left.equalTo(self.address);
    }];
    [self addSubview:self.delete];
    [self.delete mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.address);
        make.top.bottom.equalTo(self.defaultBtn);
    }];
    [self addSubview:self.edit];
    [self.edit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.delete);
        make.right.equalTo(self.delete.mas_left).offset(-Px(20));
    }];
    [self addSubview:self.botoomV];
    [self.botoomV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.defaultBtn.mas_bottom).offset(15);
        make.left.right.equalTo(self);
        make.height.equalTo(@(10));
    }];
}

#pragma mark lazy load

-(UILabel *)name{
    if (!_name) {
        _name = [[UILabel alloc] init];
        _name.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:18];
        _name.textColor = DYGColorFromHex(0x333333);
        _name.text = @"";
    }
    return _name;
}

-(UILabel *)phone{
    if (!_phone) {
        _phone = [[UILabel alloc] init];
        _phone.font = [UIFont systemFontOfSize:15];
        _phone.textColor = DYGColorFromHex(0x333333);
        _phone.text =@"";
    }
    return _phone;
}
-(UILabel *)address{
    if (!_address) {
        _address = [UILabel labelWithMediumFont:14 WithTextColor:DYGColorFromHex(0x797979)];
        _address.text = @"";
        _address.numberOfLines = 0;
    }
    return _address;
}
-(UIView *)line{
    if (!_line) {
        _line = [UIView viewWithFrame:CGRectZero WithBackGroundColor:DYGColorFromHex(0xe6e6e6)];
    }
    return _line;
}
-(UIButton *)defaultBtn{
    if (!_defaultBtn) {
        _defaultBtn = [UIButton buttonWithTitle:@"默认地址" titleColor:DYGColorFromHex(0x797979) font:12];
        [_defaultBtn setTitleColor:DYGColorFromHex(0xfed811) forState:UIControlStateSelected];
        [_defaultBtn setImage:[UIImage imageNamed:@"address_selected"] forState:UIControlStateSelected];
        [_defaultBtn setImage:[UIImage imageNamed:@"address_normal"] forState:UIControlStateNormal];
        _defaultBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -Px(6), 0, 0);
    }
    return _defaultBtn;
}
-(UIButton *)edit{
    if (!_edit) {
        _edit = [UIButton buttonWithImage:@"edite" WithTitle:@"编辑" WithColor:DYGColorFromHex(0x797979) WithFont:12];
        _edit.imageEdgeInsets = UIEdgeInsetsMake(0, -Px(6), 0, 0);
        [_edit addTarget:self action:@selector(editClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _edit;
}
-(UIButton *)delete{
    if (!_delete) {
        _delete = [UIButton buttonWithImage:@"delete" WithTitle:@"删除" WithColor:DYGColorFromHex(0x797979) WithFont:12];
        _delete.imageEdgeInsets = UIEdgeInsetsMake(0, -Px(6), 0, 0);
        [_delete addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _delete;
}

- (UIView *)botoomV{
    if (!_botoomV) {
        _botoomV = [UIView new];
        _botoomV.backgroundColor = DYGColorFromHex(0xf7f7f7);
    }
    return _botoomV;
}

- (void)editClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(editAction:)]) {
        [self.delegate editAction:self.indexPath];
    }
}

- (void)deleteClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(deleteAction:)]) {
        [self.delegate deleteAction:self.indexPath];
    }
}

- (void)setModel:(WwAddress *)model{
    _model = model;
    _name.text = model.name;
    _phone.text = model.phone;
    _address.text = [NSString stringWithFormat:@"%@%@%@%@",model.province,model.city,model.district,model.address];
    _defaultBtn.selected = model.isDefault;
}


@end



















