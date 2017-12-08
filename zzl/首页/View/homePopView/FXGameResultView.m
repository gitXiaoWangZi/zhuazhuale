//
//  FXGameResultView.m
//  zzl
//
//  Created by Mr_Du on 2017/11/24.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "FXGameResultView.h"

@interface FXGameResultView()

@property(nonatomic,strong) UIView * bgView;
@property(nonatomic,strong) UIImageView * bgImg;
@property (nonatomic,strong) UIButton * quit;
@property (nonatomic,strong) UIButton *game;
@property (nonatomic,strong) UIButton *cancel;
@property(nonatomic,strong) UIImageView * cornerImgV;
@end

@implementation FXGameResultView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
        make.left.equalTo(@(Px(40)));
        make.right.equalTo(@(Px(-40)));
        make.height.equalTo(@(Py((kScreenWidth - 80) * 523.0/518)));
    }];
    
    [self.bgView addSubview:self.bgImg];
    [self.bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(0));
        make.right.equalTo(@(0));
        make.top.equalTo(@(0));
        make.bottom.equalTo(@(0));
    }];
    
    [self.bgView addSubview:self.quit];
    [self.quit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(Py(10));
        make.right.equalTo(self.bgView).offset(Px(-10));
    }];
    
    [self.bgView addSubview:self.cancel];
    [self.cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(Py(-40)));
        make.left.equalTo(@(Px(30)));
    }];
    
    [self.bgView addSubview:self.game];
    [self.game mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(Py(-40)));
        make.right.equalTo(@(Px(-30)));
    }];
    
    [self.bgView addSubview:self.cornerImgV];
    [self.cornerImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.game.mas_right);
        make.bottom.equalTo(self.game.mas_top).offset(5);
    }];
    
    [self.bgView addSubview:self.cornerL];
    [self.cornerL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.game.mas_right);
        make.bottom.equalTo(self.game.mas_top).offset(5);
        make.width.equalTo(self.cornerImgV.mas_width);
        make.height.equalTo(self.cornerImgV.mas_height);
    }];
    
}

#pragma mark lazyload
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
    }
    return _bgView;
}

- (UIImageView *)bgImg{
    if (!_bgImg) {
        _bgImg = [UIImageView new];
        _bgImg.image = [UIImage imageNamed:@"home_game_no"];
    }
    return _bgImg;
}

- (UIButton *)quit{
    if (!_quit) {
        _quit = [UIButton buttonWithType:UIButtonTypeCustom];
        [_quit setImage:[UIImage imageNamed:@"home_pop_delete"] forState:UIControlStateNormal];
        [_quit addTarget:self action:@selector(quit:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _quit;
}

- (UIButton *)cancel{
    if (!_cancel) {
        _cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancel setImage:[UIImage imageNamed:@"home_game_bring"] forState:UIControlStateNormal];
        [_cancel addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancel;
}

- (UIButton *)game{
    if (!_game) {
        _game = [UIButton buttonWithType:UIButtonTypeCustom];
        [_game setImage:[UIImage imageNamed:@"home_game_again"] forState:UIControlStateNormal];
        [_game addTarget:self action:@selector(game:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _game;
}

- (UIImageView *)cornerImgV{
    if (!_cornerImgV) {
        _cornerImgV = [UIImageView new];
        _cornerImgV.image = [UIImage imageNamed:@"home_game_yuan"];
    }
    return _cornerImgV;
}

- (UILabel *)cornerL{
    if (!_cornerL) {
        _cornerL = [[UILabel alloc] init];
        _cornerL.textColor = [UIColor whiteColor];
        _cornerL.textAlignment = NSTextAlignmentCenter;
        _cornerL.font = [UIFont systemFontOfSize:12];
        _cornerL.text = @"5";
    }
    return _cornerL;
}

- (void)quit:(UIButton *)sender{
    [self removeFromSuperview];
}
- (void)cancel:(UIButton *)sender{
    if (self.isSuccess) {
        if ([self.delegate respondsToSelector:@selector(receiveWawaAction)]) {
            [self.delegate receiveWawaAction];
        }
    }else{
        [self removeFromSuperview];
    }
}
- (void)game:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(gameAgainAction)]) {
        [self.delegate gameAgainAction];
    }
}

- (void)setIsSuccess:(BOOL)isSuccess{
    _isSuccess = isSuccess;
    if (isSuccess) {//抓中
        self.bgImg.image = [UIImage imageNamed:@"home_game_no"];
        [self.cancel setImage:[UIImage imageNamed:@"home_game_bring"] forState:UIControlStateNormal];
    }else{//未抓中
        self.bgImg.image = [UIImage imageNamed:@"home_game_yes"];
        [self.cancel setImage:[UIImage imageNamed:@"home_game_quit"] forState:UIControlStateNormal];
    }
    
}

@end
