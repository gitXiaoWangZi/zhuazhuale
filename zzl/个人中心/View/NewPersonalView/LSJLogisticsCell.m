//
//  LSJLogisticsCell.m
//  zzl
//
//  Created by Mr_Du on 2018/1/17.
//  Copyright © 2018年 Mr.Du. All rights reserved.
//

#import "LSJLogisticsCell.h"

@interface LSJLogisticsCell()

@property (nonatomic,strong) UIImageView *icon;
@end

@implementation LSJLogisticsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addChildView];
    }
    return self;
}

- (void)addChildView{
    [self addSubview:self.icon];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Px(38)));
        make.top.equalTo(@(Py(8)));
        make.width.equalTo(@(Px(12)));
        make.height.equalTo(@(Px(12)));
    }];
    [self addSubview:self.time];
    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon.mas_right).offset(3);
        make.centerY.equalTo(self.icon.mas_centerY);
    }];
    [self addSubview:self.content];
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.time.mas_left);
        make.right.equalTo(self.mas_right).offset(-Px(22));
        make.top.equalTo(self.time.mas_bottom).offset(Py(6));
        make.bottom.equalTo(self.mas_bottom).offset(-Py(9));
    }];
}

#pragma mark lazyload
- (UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_logistics_time"]];
    }
    return _icon;
}
- (UILabel *)time{
    if (!_time) {
        _time = [[UILabel alloc] init];
        _time.textColor = DYGColorFromHex(0xff5a00);
        _time.font = kPingFangSC_Regular(16);
    }
    return _time;
}
- (UILabel *)content{
    if (!_content) {
        _content = [[UILabel alloc] init];
        _content.textColor = DYGColor(76, 76, 76);
        _content.font = kPingFangSC_Regular(12);
        _content.numberOfLines = 0;
    }
    return _content;
}
@end
