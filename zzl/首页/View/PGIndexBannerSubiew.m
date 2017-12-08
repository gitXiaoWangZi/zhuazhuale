//
//  PGIndexBannerSubiew.m
//  NewPagedFlowViewDemo
//
//  Created by Mars on 16/6/18.
//  Copyright © 2016年 Mars. All rights reserved.
//  Designed By PageGuo,
//  QQ:799573715
//  github:https://github.com/PageGuo/NewPagedFlowView

#import "PGIndexBannerSubiew.h"
#import "DYGStarRateView.h"
#import "UIButton+Position.h"
@interface PGIndexBannerSubiew()

@property(nonatomic,strong)UILabel *gameState;
@property (nonatomic,strong) UILabel *toolsName;
@property (nonatomic,strong) UILabel *hotValue;
@property (nonatomic,strong) UILabel *money;
@property (nonatomic,strong) UIImageView * diamond;
@property (nonatomic,strong) UIImageView *stars;
@property (nonatomic,strong) UIButton * moreBtn;
@property (nonatomic,strong) DYGStarRateView *starView;

@end

@implementation PGIndexBannerSubiew

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.mainImageView];
        [self addSubview:self.coverView];
        [self creatUI];
    }
    
    return self;
}


-(void)creatUI{
    [self addSubview:self.gameState];
    [self.gameState mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-Px(15));
        make.top.equalTo(self).offset(Py(15));
    }];
    [self addSubview:self.toolsName];
    [self.toolsName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(Px(15));
        make.bottom.equalTo(self).offset(-Py(47));
    }];
    [self addSubview:self.money];
    [self.money mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.toolsName.mas_right).offset(4);
        make.centerY.equalTo(self.toolsName.mas_centerY);
    }];
    [self addSubview:self.diamond];
    [self.diamond mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.money.mas_right).offset(4);
        make.centerY.equalTo(self.money.mas_centerY);
    }];
    [self addSubview:self.hotValue];
    [self.hotValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.toolsName.mas_left);
        make.bottom.equalTo(self.mas_bottom).offset(-Py(20));
    }];
    [self addSubview:self.starView];
    [self.starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hotValue.mas_right).offset(Px(5));
        make.centerY.equalTo(self.hotValue.mas_centerY);
        make.width.equalTo(@100);
        make.height.equalTo(@30);
    }];
    [self addSubview:self.moreBtn];
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.bottom.equalTo(self.starView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(Px(56), Py(30)));
    }];
}

-(void)moreBtnClick{
    if ([self.delegate respondsToSelector:@selector(moreBtnDidClick)]) {
        [self.delegate moreBtnDidClick];
    }
}


#pragma lazy load
- (UIImageView *)mainImageView {
    
    if (_mainImageView == nil) {
        _mainImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _mainImageView.userInteractionEnabled = YES;
        _mainImageView.contentMode = UIViewContentModeScaleAspectFill;
        _mainImageView.backgroundColor = [UIColor whiteColor];
    }
    return _mainImageView;
}

- (UIView *)coverView {
    if (_coverView == nil) {
        _coverView = [[UIView alloc] initWithFrame:self.bounds];
        _coverView.backgroundColor = [UIColor blackColor];
    }
    return _coverView;
}
-(UILabel *)gameState{
    if (!_gameState) {
        _gameState = [[UILabel alloc] init];
        _gameState.font = [UIFont boldSystemFontOfSize:14];
        _gameState.textColor = systemColor;
        _gameState.text = @"游戏中";
//        空闲中 6ce0ff
    }
    return _gameState;
}
-(UILabel *)toolsName{
    if (!_toolsName) {
        _toolsName = [UILabel labelWithFont:16 WithTextColor:TextColor];
        _toolsName.text = @"监狱兔";
    }
    return _toolsName;
}
-(UILabel *)money{
    if (!_money) {
        _money = [UILabel labelWithFont:16 WithTextColor:systemColor];
        _money.text = @"30";
    }
    return _money;
}
-(UILabel *)hotValue{
    if (!_hotValue) {
        _hotValue = [UILabel labelWithFont:13 WithTextColor:DYGColorFromHex(0x808080)];
        _hotValue.text = @"人气:";
    }
    return _hotValue;
}
-(UIImageView *)diamond{
    if (!_diamond) {
        _diamond = [[UIImageView alloc]init];
        _diamond.image = [UIImage imageNamed:@"price"];
    }
    return _diamond;
}
-(DYGStarRateView *)starView{
    if (!_starView) {
        _starView = [[DYGStarRateView alloc]initWithFrame:CGRectMake(0, 0, 100, 30) finish:^(CGFloat currentScore) {
            DYGLog(@"%f",currentScore);
        }];
        _starView.userInteractionEnabled = NO;
        _starView.currentScore = 4;
    }
    return _starView;
}

-(UIButton *)moreBtn{
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithTitle:@"  更多" titleColor:DYGColorFromHex(0xffffff) font:15];
        UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, Px(56), Py(30))
                                                        byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerBottomLeft)
                                                              cornerRadii:CGSizeMake(20,20)];
        CAShapeLayer * maskLayer = [CAShapeLayer layer];
        maskLayer.frame  = CGRectMake(0, 0, Px(56), Py(30));
        maskLayer.path   = maskPath.CGPath;
        _moreBtn.layer.mask  = maskLayer;
        [_moreBtn setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
        [_moreBtn.titleLabel sizeToFit];
        [_moreBtn setBackgroundColor:systemColor];
        [_moreBtn addTarget:self action:@selector(moreBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_moreBtn xm_setImagePosition:XMImagePositionRight titleFont:[UIFont systemFontOfSize:15] spacing:5];
    }
    return _moreBtn;
}

- (void)setModel:(WwRoomModel *)model{
    _model = model;
    if (model.state<1) {//**< 房间状态: 小于1:故障 1：补货 2:空闲 大于2:游戏中*/
        _gameState.text = @"故障";
    }else if (model.state==1){
        _gameState.text = @"补货";
    }else if (model.state==2){
        _gameState.text = @"空闲";
    }else{
        _gameState.text = @"游戏中";
    }
    _toolsName.text = model.wawa.name;
    _money.text = [self getCostDescribeByWawaInfo:model.wawa];
    
}

#pragma mark - Helper
- (NSString *)getCostDescribeByWawaInfo:(WwWawaItem *)item {
    NSString * des = nil;
    if (item.coin > 0) {
        des = [NSString stringWithFormat:@"%zi", item.coin];
    }
    else if (item.fishball > 0) {
        des = [NSString stringWithFormat:@"%zi", item.fishball];
    }
    else if (item.coupon > 0){
        des = [NSString stringWithFormat:@"%zi", item.coupon];
    }
    return des;
}

- (void)setCurrentScore:(CGFloat)currentScore{
    _starView.currentScore = currentScore;
}
@end
