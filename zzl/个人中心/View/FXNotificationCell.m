//
//  FXNotificationCell.m
//  zzl
//
//  Created by Mr_Du on 2017/11/8.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "FXNotificationCell.h"

@interface FXNotificationCell()

@property(nonatomic,strong)UILabel * title;
@property (nonatomic,strong) UIImageView *warn;
@property (nonatomic,strong) UIImageView *icon;
@property (nonatomic,strong) UILabel *time;
@property (nonatomic,strong) UILabel *message;
@property (nonatomic,strong) UIView *line;
@end

@implementation FXNotificationCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.warn];
    [self.warn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(Px(12));
        make.top.equalTo(self.mas_top).offset(Py(30));
    }];
    [self addSubview:self.icon];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(Px(23));
        make.top.equalTo(self.mas_top).offset(Py(11));
        make.size.mas_equalTo(CGSizeMake(Px(44), Px(44)));
    }];
    [self addSubview:self.title];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon.mas_right).offset(Px(11));
        make.top.equalTo(self.icon.mas_top).offset(Py(5));
        make.height.equalTo(@(Py(15)));
    }];
    [self addSubview:self.time];
    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.title);
        make.right.equalTo(self).offset(-Px(12));
    }];
    [self addSubview:self.message];
    [self.message mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.title.mas_left);
        make.right.equalTo(self.time);
        make.top.equalTo(self.title.mas_bottom).offset(Py(6));
    }];
    [self addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.message.mas_bottom).offset(Py(15));
        make.left.equalTo(self.warn);
        make.right.equalTo(self.time.mas_right);
        make.height.equalTo(@1);
        make.bottom.equalTo(self.mas_bottom);
    }];
}

-(UIImageView *)warn{
    if (!_warn) {
        _warn = [[UIImageView alloc]init];
        _warn.image = [UIImage imageNamed:@"mine_cell_point"];
    }
    return _warn;
}

-(UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
        _icon.image = [UIImage imageNamed:@"aboutLogo"];
    }
    return _icon;
}

-(UILabel *)title{
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.textColor = DYGColorFromHex(0x3b3b3b);
        _title.font = kPingFangSC_Semibold(15);
        _title.text =@"系统";
    }
    return _title;
}
-(UILabel *)time{
    if (!_time) {
        _time = [UILabel labelWithMediumFont:12 WithTextColor:DYGColorFromHex(0x787878)];
        _time.text =@"2017-11-11";
    }
    return _time;
}
-(UIView *)line{
    if (!_line) {
        _line = [[UIView alloc]init];
        _line.backgroundColor = DYGColorFromHex(0xe6e6e6);
    }
    return _line;
}

-(UILabel *)message{
    if (!_message) {
        _message = [UILabel labelWithFont:12 WithTextColor:DYGColorFromHex(0x787878)];
        _message.text = @"您的新人奖励已到账，请注意查收";
        _message.numberOfLines = 0;
    }
    return _message;
}

@end



















