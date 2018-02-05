//
//  LSJPayPopView.m
//  zzl
//
//  Created by Mr_Du on 2018/2/3.
//  Copyright © 2018年 Mr.Du. All rights reserved.
//

#import "LSJPayPopView.h"

@interface LSJPayPopView()

@end

@implementation LSJPayPopView

+ (instancetype)instance{
    return [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = DYGAColor(0, 0, 0, 0.4);
        [self addPostView];
    }
    return self;
}

- (void)addPostView{
//    UIView *bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    bgView.backgroundColor = DYGAColor(0, 0, 0, 0.4);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissSelf)];
    [self addGestureRecognizer:tap];
    
    UIView *centerV = [[UIView alloc] init];
    centerV.backgroundColor = [UIColor whiteColor];
    centerV.cornerRadius = 8;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doNothing)];
    [centerV addGestureRecognizer:tap1];
    [self addSubview:centerV];
    [centerV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.equalTo(@(Px(280)));
        make.height.equalTo(@(Py(180)));
    }];
    UIButton *dismissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [dismissBtn setImage:[UIImage imageNamed:@"mine_send_cross"] forState:UIControlStateNormal];
    [dismissBtn addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
    [centerV addSubview:dismissBtn];
    [dismissBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(centerV).offset(Py(10));
        make.right.equalTo(centerV).offset(-Px(10));
    }];
    UILabel *titleL = [[UILabel alloc] init];
    _titleL = titleL;
    titleL.textColor = DYGColor(77, 77, 77);
    titleL.font = kPingFangSC_Medium(24);
    titleL.numberOfLines = 2;
    titleL.textAlignment = NSTextAlignmentCenter;
    [centerV addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(centerV).offset(Py(50));
        make.left.equalTo(centerV.mas_left).offset(Px(20));
        make.right.equalTo(centerV.mas_right).offset(-Px(20));
    }];
    UIButton *zhifubaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [zhifubaoBtn setTitle:@"支付宝" forState:UIControlStateNormal];
    zhifubaoBtn.titleLabel.font = kPingFangSC_Semibold(15);
    [zhifubaoBtn setTitleColor:DYGColor(19, 130, 233) forState:UIControlStateNormal];
    [zhifubaoBtn addTarget:self action:@selector(zhifubaoPay:) forControlEvents:UIControlEventTouchUpInside];
    [centerV addSubview:zhifubaoBtn];
    [zhifubaoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(centerV);
        make.left.equalTo(centerV);
        make.width.equalTo(@((Px(280)-0.5)/2.0));
        make.height.equalTo(@(Py(52)));
    }];
    UIButton *wechatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [wechatBtn setTitle:@"微信" forState:UIControlStateNormal];
    wechatBtn.titleLabel.font = kPingFangSC_Semibold(15);
    [wechatBtn setTitleColor:DYGColor(35, 186, 0) forState:UIControlStateNormal];
    [wechatBtn addTarget:self action:@selector(wechatPay:) forControlEvents:UIControlEventTouchUpInside];
    [centerV addSubview:wechatBtn];
    [wechatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(centerV);
        make.right.equalTo(centerV);
        make.width.equalTo(@((Px(280)-0.5)/2.0));
        make.height.equalTo(@(Py(52)));
    }];
    UIView *line0 = [UIView new];
    line0.backgroundColor = DYGColor(204, 204, 204);
    [centerV addSubview:line0];
    [line0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(centerV);
        make.width.equalTo(@(0.5));
        make.centerX.equalTo(centerV);
        make.height.equalTo(@(Py(52)));
    }];
    UIView *line = [UIView new];
    line.backgroundColor = DYGColor(204, 204, 204);
    [centerV addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(line0.mas_top);
        make.height.equalTo(@(0.5));
        make.left.right.equalTo(centerV);
    }];
}

- (void)doNothing{
    
}
- (void)dismissSelf{
    self.hidden = YES;
}

- (void)zhifubaoPay:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(payForType:num:)]) {
        [self.delegate payForType:NO num:self.num];
    }
}

- (void)wechatPay:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(payForType:num:)]) {
        [self.delegate payForType:YES num:self.num];
    }
}
@end
