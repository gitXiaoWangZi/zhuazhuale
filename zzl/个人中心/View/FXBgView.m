//
//  FXBgView.m
//  zzl
//
//  Created by Mr_Du on 2017/11/6.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "FXBgView.h"

@implementation FXBgView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setUpUI];
    }
    return self;
}
-(void)setUpUI{
    [self addSubview:self.bgImg];
    [self.bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(Py(115));
    }];
    [self addSubview:self.msgLb];
    [self.msgLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.bgImg.mas_bottom).offset(Py(20));
    }];
}
-(UIImageView *)bgImg{
    if (!_bgImg) {
        _bgImg = [UIImageView new];
        _bgImg.image = [UIImage imageNamed:@"sp"];
    }
    return _bgImg;
}
-(UILabel *)msgLb{
    if (!_msgLb) {
        _msgLb = [UILabel labelWithFont:16 WithTextColor:DYGColorFromHex(0x808080) WithAlignMent:NSTextAlignmentCenter];
        _msgLb.text = @"小主,您还没有收货地址哦!";
    }
    return _msgLb;
}

@end
