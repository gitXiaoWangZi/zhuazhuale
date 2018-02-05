//
//  LSJGameYuEPopView.m
//  zzl
//
//  Created by Mr_Du on 2018/2/5.
//  Copyright © 2018年 Mr.Du. All rights reserved.
//

#import "LSJGameYuEPopView.h"

@interface LSJGameYuEPopView()
@property (nonatomic,strong) UIImageView *centerImgV;
@property (nonatomic,strong) UIButton *otherPayBtn;
@property (nonatomic,strong) UIButton *selfPayBtn;
@property (nonatomic,strong) UIButton *popBtn;
@end

@implementation LSJGameYuEPopView

+ (instancetype)shareInstance{
    return [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = DYGAColor(0, 0, 0, 0.5);
        [self addChildView];
    }
    return self;
}

- (void)addChildView{
    [self addSubview:self.centerImgV];
    [self.centerImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    [self addSubview:self.otherPayBtn];
    [self.otherPayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.centerImgV.mas_left).offset(28);
        make.bottom.equalTo(self.centerImgV.mas_bottom).offset(-16);
    }];
    [self addSubview:self.selfPayBtn];
    [self.selfPayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.centerImgV.mas_right).offset(-28);
        make.bottom.equalTo(self.centerImgV.mas_bottom).offset(-16);
    }];
    [self addSubview:self.popBtn];
    [self.popBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.centerImgV.mas_bottom).offset(60);
    }];
}

- (void)otherPay{
    if ([self.delegate respondsToSelector:@selector(clickPayBy:)]) {
        [self.delegate clickPayBy:gameYuEPopViewTypeOtherPay];
    }
}

- (void)selfPay{
    if ([self.delegate respondsToSelector:@selector(clickPayBy:)]) {
        [self.delegate clickPayBy:gameYuEPopViewTypeSelfPay];
    }
}

- (void)pop{
    self.hidden = YES;
}

#pragma mark lazyload
- (UIImageView *)centerImgV{
    if (!_centerImgV) {
        _centerImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"game_yue_center"]];
    }
    return _centerImgV;
}

- (UIButton *)otherPayBtn{
    if (!_otherPayBtn) {
        _otherPayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_otherPayBtn setBackgroundImage:[UIImage imageNamed:@"game_yue_other"] forState:UIControlStateNormal];
        [_otherPayBtn addTarget:self action:@selector(otherPay) forControlEvents:UIControlEventTouchUpInside];
    }
    return _otherPayBtn;
}
- (UIButton *)selfPayBtn{
    if (!_selfPayBtn) {
        _selfPayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selfPayBtn setBackgroundImage:[UIImage imageNamed:@"game_yue_self"] forState:UIControlStateNormal];
        [_selfPayBtn addTarget:self action:@selector(selfPay) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selfPayBtn;
}
- (UIButton *)popBtn{
    if (!_popBtn) {
        _popBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_popBtn setBackgroundImage:[UIImage imageNamed:@"game_yue_pop"] forState:UIControlStateNormal];
        [_popBtn addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    }
    return _popBtn;
}
@end
