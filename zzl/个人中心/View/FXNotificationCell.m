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

@property (nonatomic,strong) UIImageView *icon;
@property (nonatomic,strong) UILabel *time;
@property (nonatomic,strong) UIView *line;
@property (nonatomic,strong) UILabel *message;
@property (nonatomic,strong) UIView * footer;
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
    [self addSubview:self.icon];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(Px(16));
        make.top.equalTo(self).offset(Py(15));
        make.size.mas_equalTo(CGSizeMake(Px(22), Py(23)));
    }];
    [self addSubview:self.title];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon.mas_right).offset(Px(8));
        make.centerY.equalTo(self.icon);
    }];
    [self addSubview:self.time];
    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.title);
        make.right.equalTo(self).offset(-Px(16));
    }];
    [self addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.icon.mas_bottom).offset(Py(15));
        make.left.equalTo(self.icon);
        make.right.equalTo(self);
        make.height.equalTo(@1);
    }];
    [self addSubview:self.footer];
    [self.footer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@(Py(10)));
    }];
    [self addSubview:self.message];
    [self.message mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.line);
        make.right.equalTo(self.time);
        make.top.equalTo(self.line.mas_bottom).offset(Py(10));
        make.bottom.equalTo(self.footer.mas_top).offset(Py(-10));
    }];
}

-(UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc]init];
        _icon.image = [UIImage imageNamed:@"customer"];
    }
    return _icon;
}

-(UILabel *)title{
    if (!_title) {
        _title = [UILabel labelWithMediumFont:14 WithTextColor:DYGColorFromHex(0x4c4c4)];
        _title.text =@"系统公告";
    }
    return _title;
}
-(UILabel *)time{
    if (!_time) {
        _time = [UILabel labelWithMediumFont:11 WithTextColor:DYGColorFromHex(0x999999)];
        _time.text =@"";
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
        _message = [UILabel labelWithFont:12 WithTextColor:DYGColorFromHex(0x666666)];
        NSString * str = @"您的注册奖励600钻石已到账";
        _message.numberOfLines = 0;
        NSMutableParagraphStyle *paraStyle01 = [[NSMutableParagraphStyle alloc] init];
        paraStyle01.alignment = NSTextAlignmentJustified;
        CGFloat emptylen = _message.font.pointSize * 2;
        paraStyle01.firstLineHeadIndent = emptylen;
        paraStyle01.lineSpacing = 2.0f;
        NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:str attributes:@{NSParagraphStyleAttributeName:paraStyle01}];
        _message.attributedText = attrText;
        [_message sizeToFit];
    }
    return _message;
}
-(UIView *)footer{
    if (!_footer) {
        _footer = [[UIView alloc]init];
        _footer.backgroundColor = BGColor;
    }
    return _footer;
}


@end



















