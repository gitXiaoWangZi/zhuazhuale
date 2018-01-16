//
//  FXTaskCell.m
//  zzl
//
//  Created by Mr_Du on 2017/11/14.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "FXTaskCell.h"
#import "FXTaskModel.h"
#import "UIButton+Position.h"               

@interface FXTaskCell()


@end

@implementation FXTaskCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    [self addSubview:self.icon];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(Px(16));
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(Px(40), Py(40)));
    }];
    [self addSubview:self.title];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.icon.mas_right).offset(Px(5));
    }];
    [self addSubview:self.btn];
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-Px(16));
        make.size.mas_equalTo(CGSizeMake(Px(68), Py(27)));
    }];
}

#pragma mark lazyload

-(UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc]init];
        _icon.contentMode = UIViewContentModeCenter;
        [_icon sizeToFit];
    }
    return _icon;
}

-(UILabel *)title{
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _title.textColor = DYGColorFromHex(0x494848);
    }
    return _title;
}

-(UIButton *)btn{
    if (!_btn) {
        _btn = [[UIButton alloc]init];
        [_btn setTitleColor:DYGColorFromHex(0x9b7000) forState:UIControlStateNormal];
        [_btn setBackgroundColor:[UIColor whiteColor]];
        _btn.borderColor = DYGColorFromHex(0xcccccc);
        _btn.borderWidth = 1;
        _btn.cornerRadius = Py(13.5);
        _btn.layer.masksToBounds = YES;
        [_btn setTitle:@"15" forState:UIControlStateNormal];
        _btn.titleLabel.font = [UIFont fontWithName:@"STYuanti-SC-Regular" size:13];
        [_btn setImage:[UIImage imageNamed:@"jewel_task"] forState:UIControlStateNormal];
        _btn.userInteractionEnabled = NO;
    }
    return _btn;
}


- (void)setModel:(FXTaskModel *)model{
    _model = model;
//    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.img]];
    self.title.text = model.sign_name;
    if ([model.status isEqualToString:@"0"]) {//不可领取
        self.btn.selected = NO;
        NSString *award_num = [NSString stringWithFormat:@"+%@",model.award_num];
        [_btn setTitle:award_num forState:UIControlStateNormal];
        [_btn setImage:[UIImage imageNamed:@"jewel_task"] forState:UIControlStateNormal];
        [_btn xm_setImagePosition:XMImagePositionRight titleFont:[UIFont systemFontOfSize:13] spacing:3];
        self.btn.borderWidth = 1;
        _btn.borderColor = DYGColorFromHex(0xcccccc);
    }else if ([model.status isEqualToString:@"1"]) {//可领取
        self.btn.selected = YES;
        self.btn.backgroundColor = DYGColorFromHex(0xffbc43);
        [self.btn setImage:nil forState:UIControlStateNormal];
        [self.btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0,0)];
        [self.btn setTitle:@"领取" forState:UIControlStateSelected];
        [self.btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.btn.borderWidth = 0;
        _btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    }else{//已领取
        self.btn.selected = NO;
        [_btn setTitle:@"已领取" forState:UIControlStateNormal];
        [self.btn setImage:nil forState:UIControlStateNormal];
        _btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        [self.btn setTitleColor:DYGColorFromHex(0xaaaaaa) forState:UIControlStateNormal];
        self.btn.backgroundColor = DYGColorFromHex(0xf0f0f0);
        self.btn.borderWidth = 1;
        _btn.borderColor = DYGColorFromHex(0xcccccc);
    }
}








@end
