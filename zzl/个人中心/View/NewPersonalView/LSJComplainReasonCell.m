//
//  LSJComplainReasonCell.m
//  zzl
//
//  Created by Mr_Du on 2018/1/15.
//  Copyright © 2018年 Mr.Du. All rights reserved.
//

#import "LSJComplainReasonCell.h"

@implementation LSJComplainReasonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addChildView];
    }
    return self;
}

- (void)addChildView{
    [self.contentView addSubview:self.iconBtn];
    [self.iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(Px(16));
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.height.equalTo(@(Px(16)));
    }];
    [self.contentView addSubview:self.titleL];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconBtn.mas_right).offset(Px(11));
        make.right.equalTo(self.contentView.mas_right).offset(Px(-15));
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
}

#pragma mark lazyload
- (UIButton *)iconBtn{
    if (!_iconBtn) {
        _iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_iconBtn setImage:[UIImage imageNamed:@"mine_ss_notclicked"] forState:UIControlStateNormal];
        [_iconBtn setImage:[UIImage imageNamed:@"mine_ss_checkmark"] forState:UIControlStateSelected];
    }
    return _iconBtn;
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc] init];
        _titleL.textColor = DYGColorFromHex(0x3b3b3b);
        _titleL.font = [UIFont systemFontOfSize:15];
    }
    return _titleL;
}
@end
