//
//  FXHomePopView.m
//  zzl
//
//  Created by Mr_Du on 2017/11/23.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "FXHomePopView.h"

@interface FXHomePopView()

@property(nonatomic,strong) UIView * bgView;
@property(nonatomic,strong) UIImageView * bgImg;
@property (nonatomic,strong) UIButton * quit;
@property (nonatomic,strong) UIButton *game;
@property (nonatomic,strong) UIButton *know;
@end

@implementation FXHomePopView

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
        make.left.equalTo(@(Px(20)));
        make.right.equalTo(@(Px(-20)));
        make.height.equalTo(@(Py((kScreenWidth - 40) * 842.0/1001)));
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
        make.top.equalTo(self.bgView).offset(Py(20));
        make.right.equalTo(self.bgView).offset(Px(-20));
    }];
    
    [self.bgView addSubview:self.know];
    [self.know mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(Py(-80)));
        make.left.equalTo(@(Px(70)));
    }];
    
    [self.bgView addSubview:self.game];
    [self.game mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(Py(-80)));
        make.right.equalTo(@(Px(-50)));
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
        _bgImg.image = [UIImage imageNamed:@"home_popView"];
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

- (UIButton *)know{
    if (!_know) {
        _know = [UIButton buttonWithType:UIButtonTypeCustom];
        [_know setImage:[UIImage imageNamed:@"home_pop_left"] forState:UIControlStateNormal];
        [_know addTarget:self action:@selector(know:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _know;
}

- (UIButton *)game{
    if (!_game) {
        _game = [UIButton buttonWithType:UIButtonTypeCustom];
        [_game setImage:[UIImage imageNamed:@"home_pop_right"] forState:UIControlStateNormal];
        [_game addTarget:self action:@selector(game:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _game;
}

- (void)quit:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(dimiss)]) {
        [self.delegate dimiss];
    }
}
- (void)know:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(dimiss)]) {
        [self.delegate dimiss];
    }
}
- (void)game:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(gameNow)]) {
        [self.delegate gameNow];
    }
}
@end
