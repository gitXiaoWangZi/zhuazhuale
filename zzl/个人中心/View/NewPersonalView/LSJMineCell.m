//
//  LSJMineCell.m
//  zzl
//
//  Created by Mr_Du on 2017/12/29.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "LSJMineCell.h"

@interface LSJMineCell()

@end

@implementation LSJMineCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpChildView];
    }
    return self;
}

- (void)setUpChildView{
    [self addSubview:self.iconImgV];
    [self.iconImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(Px(20));
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.nameL];
    [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgV.mas_right).offset(Px(10));
        make.centerY.equalTo(self.iconImgV);
    }];
    
    [self addSubview:self.arrowImgV];
    [self.arrowImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(Px(-20));
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.warnImgV];
    [self.warnImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.arrowImgV.mas_left).offset(Px(-5));
        make.centerY.equalTo(self);
    }];
    self.warnImgV.hidden = YES;
    
    [self addSubview:self.hotImgV];
    [self.hotImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameL.mas_right).offset(Px(10));
        make.centerY.equalTo(self);
    }];
    self.hotImgV.hidden = YES;
    
    [self addSubview:self.desL];
    [self.desL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameL.mas_right).offset(Px(10));
        make.centerY.equalTo(self);
    }];
    self.desL.hidden = YES;
    
    UIView *line = [UIView new];
    line.backgroundColor = DYGColorFromHex(0xEDF2F6);
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(Px(10));
        make.right.equalTo(self.mas_right).offset(Px(-10));
        make.bottom.equalTo(self.mas_bottom).offset(Py(0));
        make.height.equalTo(@(1));
    }];
}

#pragma mark lazyload
- (UIImageView *)iconImgV{
    if (!_iconImgV) {
        _iconImgV = [UIImageView new];
    }
    return _iconImgV;
}

- (UILabel *)nameL{
    if (!_nameL) {
        _nameL = [UILabel new];
        _nameL.textColor = DYGColorFromHex(0x494848);
        _nameL.font = [UIFont systemFontOfSize:14];
    }
    return _nameL;
}

- (UIImageView *)arrowImgV{
    if (!_arrowImgV) {
        _arrowImgV = [UIImageView new];
        _arrowImgV.image = [UIImage imageNamed:@"mine_cell_arrow"];
        _arrowImgV.contentMode = UIViewContentModeCenter;
    }
    return _arrowImgV;
}

- (UIImageView *)hotImgV{
    if (!_hotImgV) {
        _hotImgV = [UIImageView new];
        _hotImgV.image = [UIImage imageNamed:@"mine_cell_hot"];
    }
    return _hotImgV;
}

- (UIImageView *)warnImgV{
    if (!_warnImgV) {
        _warnImgV = [UIImageView new];
        _warnImgV.image = [UIImage imageNamed:@"mine_cell_point"];
    }
    return _warnImgV;
}

- (UILabel *)desL{
    if (!_desL) {
        _desL = [UILabel new];
        _desL.textColor = DYGColorFromHex(0xb6b6b6);
        _desL.font = [UIFont systemFontOfSize:12];
        _desL.text = @"客服在线时间 周一至周五10:00-19:00";
    }
    return _desL;
}
@end
