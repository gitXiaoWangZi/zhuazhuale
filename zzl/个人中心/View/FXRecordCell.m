//
//  FXRecordCell.m
//  zzl
//
//  Created by Mr_Du on 2017/11/8.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "FXRecordCell.h"

@interface FXRecordCell()

@property(nonatomic,strong)UIImageView * photo;
@property (nonatomic,strong)UILabel *name;
@property (nonatomic,strong) UILabel *time;
@property (nonatomic,strong) UILabel *staue;
@property (nonatomic,strong) UILabel * money;

@end


@implementation FXRecordCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    [self addSubview:self.photo];
    [self.photo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(Px(16));
        make.top.equalTo(self).offset(Py(16));
        make.size.mas_equalTo(CGSizeMake(Px(50), Px(50)));
    }];
    [self addSubview:self.name];
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(Py(22));
        make.left.equalTo(self.photo.mas_right).offset(Px(15));
    }];
    [self addSubview:self.time];
    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.name);
        make.top.equalTo(self.name.mas_bottom).offset(Py(10));
    }];
    [self addSubview:self.staue];
    [self.staue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.name);
        make.right.equalTo(self).offset(-Px(16));
    }];
    [self addSubview:self.money];
    [self.money mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.staue);
        make.bottom.equalTo(self.time);
    }];
}
-(void)setFrame:(CGRect)frame {
    frame.size.height-=Py(1);
    [super setFrame:frame];
}
-(UIImageView *)photo{
    if (!_photo) {
        _photo = [[UIImageView alloc]init];
        _photo.image = [UIColor whiteColor].colorImage;
        _photo.cornerRadius = Px(25);
        _photo.layer.masksToBounds = YES;
        _photo.borderColor = systemColor;
        _photo.borderWidth =1;
    }
    return _photo;
}

-(UILabel *)name{
    if (!_name) {
        _name = [UILabel labelWithMediumFont:14 WithTextColor:DYGColorFromHex(0x4c4c4c)];
        _name.text = @"口袋熊";
    }
    return _name;
}
-(UILabel *)time{
    if (!_time) {
        _time = [UILabel labelWithMediumFont:12 WithTextColor:DYGColorFromHex(0x999999)];
        _time.text =@"2017-11-08 11:16";
    }
    return _time;
}
-(UILabel *)staue{
    if (!_staue) {
        _staue = [UILabel labelWithMediumFont:14 WithTextColor:systemColor];
        _staue.text = @"成功";
    }
    return _staue;
}
-(UILabel *)money{
    if (!_money) {
        _money = [UILabel labelWithMediumFont:12 WithTextColor:DYGColorFromHex(0x999999)];
        _money.text = @"-19";
    }
    return _money;
}

- (void)setModel:(WwGameHistory *)model{
    _model = model;
    [self.photo sd_setImageWithURL:[NSURL URLWithString:model.wawa.pic] placeholderImage:nil];
    self.name.text = model.wawa.name;
    self.time.text = model.dateline;
    switch (model.status) {
        case 0:
            self.staue.text = @"游戏失败";
            break;
        case 1:
            self.staue.text = @"未抓中";
            break;
        case 2:
            self.staue.text = @"抓中";
            break;
        default:
            break;
    }
    self.money.text = [NSString stringWithFormat:@"%zd",model.coin];
}
@end











