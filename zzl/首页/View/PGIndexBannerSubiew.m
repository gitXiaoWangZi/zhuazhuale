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
#import "UIButton+Position.h"
@interface PGIndexBannerSubiew()

@property(nonatomic,strong) UIButton *gameState;

@end

@implementation PGIndexBannerSubiew

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.layer.cornerRadius = 15;
        self.layer.borderWidth = 4;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.masksToBounds = YES;
        [self creatUI];
    }
    
    return self;
}


-(void)creatUI{
    [self addSubview:self.mainImageView];
    [self.mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
    }];
    [self addSubview:self.gameState];
    [self.gameState mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-Px(15));
        make.top.equalTo(self).offset(Py(15));
        make.width.equalTo(@(63.5));
        make.height.equalTo(@(32));
    }];
    
    [self addSubview:self.diamond];
    [self.diamond mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(Px(5));
        make.height.equalTo(@(51));
        make.width.equalTo(@(86));
        make.bottom.equalTo(self).offset(-Py(24));
    }];
    [self addSubview:self.toolsName];
    [self.toolsName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(Px(5));
        make.bottom.equalTo(self.diamond.mas_top).offset(Py(15));
    }];
}


#pragma lazy load
- (UIImageView *)mainImageView {
    
    if (_mainImageView == nil) {
        _mainImageView = [[UIImageView alloc] init];
        _mainImageView.userInteractionEnabled = YES;
        _mainImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _mainImageView;
}

- (UIButton *)gameState{
    if (!_gameState) {
        _gameState = [UIButton buttonWithType:UIButtonTypeCustom];
        [_gameState setTitleColor:DYGColorFromHex(0xffffff) forState:UIControlStateNormal];
        _gameState.titleLabel.font = kPingFangSC_Medium(13);
        _gameState.enabled = NO;
    }
    return _gameState;
}

- (UIButton *)toolsName{
    if (!_toolsName) {
        _toolsName = [UIButton buttonWithType:UIButtonTypeCustom];
        [_toolsName setTitleColor:DYGColorFromHex(0xaf4e00) forState:UIControlStateNormal];
        _toolsName.titleLabel.font = kPingFangSC_Medium(14);
        UIImage *img = [UIImage imageNamed:@"home_name_bgImgV"];
        img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(10, 40, 10, 40) resizingMode:UIImageResizingModeStretch];
        [_toolsName setBackgroundImage:img forState:UIControlStateNormal];
        _toolsName.enabled = NO;
        _toolsName.alpha = 1.0;
    }
    return _toolsName;
}

- (UIButton *)diamond{
    if (!_diamond) {
        _diamond = [UIButton buttonWithType:UIButtonTypeCustom];
        [_diamond setTitleColor:DYGColorFromHex(0xaf4e00) forState:UIControlStateNormal];
        _diamond.titleLabel.font = kPingFangSC_Medium(14);
        [_diamond setImage:[UIImage imageNamed:@"home_diamo"] forState:UIControlStateNormal];
        [_diamond xm_setImagePosition:XMImagePositionLeft titleFont:[UIFont systemFontOfSize:14] spacing:5];
        [_diamond setBackgroundImage:[UIImage imageNamed:@"home_price_bgImgV"] forState:UIControlStateNormal];
        _diamond.enabled = NO;
    }
    return _diamond;
}

- (UIView *)coverView{
    if (!_coverView) {
        _coverView  = [[UIView alloc] init];
        _coverView.backgroundColor = [UIColor blackColor];
    }
    return _coverView;
}

- (void)setModel:(WwRoom *)model{
    _model = model;
    if (model.state<1) {//**< 房间状态: 小于1:故障home_room_weixiu 1：补货 2:空闲home_room_kongxian 大于2:游戏中home_room_status*/
        [_gameState setTitle:@"故障" forState:UIControlStateNormal];
        [_gameState setBackgroundImage:[UIImage imageNamed:@"home_room_weixiu"] forState:UIControlStateNormal];
    }else if (model.state==1){
        [_gameState setTitle:@"补货" forState:UIControlStateNormal];
        [_gameState setBackgroundImage:[UIImage imageNamed:@"home_room_weixiu"] forState:UIControlStateNormal];
    }else if (model.state==2){
        [_gameState setTitle:@"空闲" forState:UIControlStateNormal];
        [_gameState setBackgroundImage:[UIImage imageNamed:@"home_room_kongxian"] forState:UIControlStateNormal];
    }else{
        [_gameState setTitle:@"游戏中" forState:UIControlStateNormal];
        [_gameState setBackgroundImage:[UIImage imageNamed:@"home_room_status"] forState:UIControlStateNormal];
    }
    [_diamond setTitle:[self getCostDescribeByWawaInfo:model.wawa] forState:UIControlStateNormal];
    [_diamond xm_setImagePosition:XMImagePositionLeft titleFont:[UIFont systemFontOfSize:14] spacing:5];
    
}

#pragma mark - Helper
- (NSString *)getCostDescribeByWawaInfo:(WwWawa *)item {
    NSString * des = nil;
    if (item.coin > 0) {
        des = [NSString stringWithFormat:@"%zi", item.coin];
    }
    return des;
}
@end
