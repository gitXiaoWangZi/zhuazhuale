//
//  MinePreferentialCell.m
//  zzl
//
//  Created by Mr_Du on 2018/2/24.
//  Copyright © 2018年 Mr.Du. All rights reserved.
//

#import "MinePreferentialCell.h"
#import "LSJPreferentialModel.h"

@interface MinePreferentialCell()

@property (nonatomic,strong) UIImageView *bgImgV;
@property (nonatomic,strong) UIImageView *icon;
@property (nonatomic,strong) UIImageView *desImgV;
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UILabel *timeL;
@property (nonatomic,strong) UIButton *useBtn;
@end


@implementation MinePreferentialCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = DYGColorFromHex(0xf7f7f7);
        [self addChildView];
    }
    return self;
}

- (void)addChildView{
    [self addSubview:self.bgImgV];
    [self.bgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Px(6)));
        make.right.equalTo(@(-Px(6)));
        make.top.bottom.equalTo(@(0));
    }];
    [self addSubview:self.icon];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgImgV.mas_left);
        make.top.equalTo(self.bgImgV.mas_top);
        make.bottom.equalTo(self.bgImgV.mas_bottom);
        make.width.equalTo(@(Px(111)));
    }];
    [self addSubview:self.titleL];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon.mas_right);
        make.top.equalTo(self.bgImgV.mas_top).offset(Py(27));
    }];
    [self addSubview:self.timeL];
    [self.timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon.mas_right);
        make.top.equalTo(self.titleL.mas_bottom).offset(Py(12));
    }];
    [self addSubview:self.useBtn];
    [self.useBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgImgV.mas_right).offset(-Px(18));
        make.centerY.equalTo(self.bgImgV.mas_centerY);
    }];
    self.useBtn.userInteractionEnabled = NO;
    self.useBtn.hidden = YES;
    [self addSubview:self.desImgV];
    [self.desImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgImgV.mas_right).offset(-Px(26));
        make.centerY.equalTo(self.bgImgV.mas_centerY);
    }];
    self.desImgV.hidden = YES;
}

- (void)setType:(preferentialType)type{
    switch (type) {
        case preferentialTypeNone:
        {
        }
            break;
        case preferentialTypeGo:
        {
            self.useBtn.hidden = NO;
        }
            break;
        case preferentialTypeUsed:
        {
            self.desImgV.hidden = NO;
            self.desImgV.image = [UIImage imageNamed:@"mine_youhui_used"];
        }
            break;
        case preferentialTypePass:
        {
            self.desImgV.hidden = NO;
            self.desImgV.image = [UIImage imageNamed:@"mine_youhui_pass"];
        }
            break;
        default:
            break;
    }
}

- (void)updateViewWithIcon:(NSString *)icon title:(NSString *)title time:(NSString *)time{
    [self.icon sd_setImageWithURL:[NSURL URLWithString:icon]];
    self.titleL.text = title;
    self.timeL.text = [NSString stringWithFormat:@"有效期至%@",time];
}

#pragma mark lazyload
- (UIImageView *)bgImgV{
    if (!_bgImgV) {
        _bgImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_rectangle_bg"]];
    }
    return _bgImgV;
}

- (UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
        _icon.image = [UIImage imageNamed:@"mine_youhui_pass"];
    }
    return _icon;
}
- (UIImageView *)desImgV{
    if (!_desImgV) {
        _desImgV = [[UIImageView alloc] init];
    }
    return _desImgV;
}
-(UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc] init];
        _titleL.textColor = DYGColor(108, 108, 108);
        _titleL.font = [UIFont systemFontOfSize:18];
        _titleL.text = @"充值折扣券";
    }
    return _titleL;
}
-(UILabel *)timeL{
    if (!_timeL) {
        _timeL = [[UILabel alloc] init];
        _timeL.textColor = DYGColor(255, 141, 66);
        _timeL.font = [UIFont systemFontOfSize:13];
        _timeL.text = @"有效期至2018.03.04";
    }
    return _timeL;
}
- (UIButton *)useBtn{
    if (!_useBtn) {
        _useBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_useBtn setBackgroundImage:[UIImage imageNamed:@"mine_youhui_button"] forState:UIControlStateNormal];
    }
    return _useBtn;
}
@end
