//
//  LSJTaskPopView.m
//  zzl
//
//  Created by Mr_Du on 2018/1/12.
//  Copyright © 2018年 Mr.Du. All rights reserved.
//

#import "LSJTaskPopView.h"

@interface LSJTaskPopView()

@property (nonatomic,strong) UIImageView *imgV;
@property (nonatomic,strong) UIView *bgV;
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UILabel *desL;
@property (nonatomic,strong) UIButton *sureBtn;
@end

@implementation LSJTaskPopView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = DYGAColor(0, 0, 0, 0.6);
        [self setUpView];
    }
    return self;
}

- (void)setUpView{
    [self addSubview:self.imgV];
    [self.imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
    }];
    [self addSubview:self.bgV];
    [self.bgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.imgV);
    }];
    [self.bgV addSubview:self.titleL];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgV.mas_top).offset(Py(40));
        make.left.right.equalTo(self.bgV);
    }];
    [self.bgV addSubview:self.desL];
    [self.desL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleL.mas_bottom).offset(Py(5));
        make.left.right.equalTo(self.bgV);
    }];
    [self.bgV addSubview:self.sureBtn];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgV.mas_bottom).offset(Py(-20));
        make.centerX.equalTo(self.bgV.mas_centerX);
    }];
}

- (void)sureAction:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(sureBringActionWithNum:award_num:)]) {
        [self.delegate sureBringActionWithNum:self.num award_num:self.award_num];
    }
}

- (void)refreshViewWithNum:(NSInteger)num award_num:(NSString *)award_num{
    self.num = num;
    self.award_num = award_num;
    self.titleL.text = [NSString stringWithFormat:@"恭喜完成%zd个任务",num];
    self.desL.text = [NSString stringWithFormat:@"请收下我们为您准备的%@钻奖励",award_num];
}

#pragma mark lazyload
- (UIImageView *)imgV{
    if (!_imgV) {
        _imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_task_bgImgV"]];
    }
    return _imgV;
}
- (UIView *)bgV{
    if (!_bgV) {
        _bgV = [UIView new];
        _bgV.backgroundColor = [UIColor clearColor];
    }
    return _bgV;
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc] init];
        _titleL.textColor = DYGColorFromHex(0x9b7000);
        _titleL.font = [UIFont fontWithName:@"PingFangSC-Bold" size:12];
        _titleL.textAlignment = NSTextAlignmentCenter;
    }
    return _titleL;
}
- (UILabel *)desL{
    if (!_desL) {
        _desL = [[UILabel alloc] init];
        _desL.textColor = DYGColorFromHex(0x9b7000);
        _desL.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _desL.textAlignment = NSTextAlignmentCenter;
    }
    return _desL;
}
- (UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureBtn setBackgroundImage:[UIImage imageNamed:@"mine_task_sure"] forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
        _sureBtn.adjustsImageWhenHighlighted = NO;
    }
    return _sureBtn;
}
@end
