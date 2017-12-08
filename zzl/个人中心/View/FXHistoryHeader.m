//
//  FXHistoryHeader.m
//  zzl
//
//  Created by Mr_Du on 2017/11/8.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "FXHistoryHeader.h"

@implementation FXHistoryHeader

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    self.backgroundColor = systemColor;
    [self addSubview:self.money];
    [self.money mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(Py(15));
    }];
    [self addSubview:self.imgView];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-Py(15));
    }];
}

-(UILabel *)money{
    if (!_money) {
        _money = [UILabel labelWithMediumFont:30 WithTextColor:[UIColor whiteColor]];
        _money.text = @"1000";
    }
    return _money;
}

-(UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jewel"]];
    }
    return _imgView;
}

@end
