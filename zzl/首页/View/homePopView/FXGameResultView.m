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
@property(nonatomic,strong) UIImageView * resultImg;
@property (nonatomic,strong) UIButton *game;
@property (nonatomic,strong) UIButton *cancel;
@property (nonatomic,strong) UIButton *dismiss;
@property (nonatomic,strong) UILabel *titleL;
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
        make.top.left.right.bottom.equalTo(self);
    }];
    [self.bgView addSubview:self.bgImg];
    [self.bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
        make.width.equalTo(@(Px(375)));
        make.height.equalTo(@(Px(466.5)));
    }];
    
    [self.bgView addSubview:self.resultImg];
    [self.resultImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
        make.width.equalTo(@(Px(264)));
        make.height.equalTo(@(Px(355.5)));
    }];
    [self.bgView addSubview:self.dismiss];
    [self.dismiss mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.resultImg.mas_top).offset(Py(95));
        make.right.equalTo(self.resultImg.mas_right).offset(-5);
    }];
    self.dismiss.hidden = YES;
    [self.bgView addSubview:self.titleL];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.resultImg.mas_top).offset(Py(115));
        make.centerX.equalTo(self.bgView);
        make.height.equalTo(@(Py(21)));
    }];
    [self.bgView addSubview:self.desL];
    [self.desL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.top.equalTo(self.titleL.mas_bottom).offset(Py(5));
        make.height.equalTo(@(Py(21)));
    }];
    [self.bgView addSubview:self.cancel];
    [self.cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.desL.mas_bottom).offset(Py(20));
        make.centerX.equalTo(self.bgView);
    }];
    [self.bgView addSubview:self.game];
    [self.game mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cancel.mas_bottom).offset(Py(20));
        make.centerX.equalTo(self.bgView);
    }];
}

- (void)showStatusView:(BOOL)isSuccess{
    if (isSuccess) {
        self.bgImg.hidden = NO;
        self.dismiss.hidden = NO;
        self.resultImg.image = [UIImage imageNamed:@"game_result_success_bg"];
        [self.cancel setImage:[UIImage imageNamed:@"game_result_share"] forState:UIControlStateNormal];
        [self.game setImage:[UIImage imageNamed:@"game_result_bring"] forState:UIControlStateNormal];
        self.titleL.text = @"天呀你是抓娃娃之神吗";
    }else{
        self.bgImg.hidden = YES;
        self.resultImg.image = [UIImage imageNamed:@"game_result_fail_bg"];
        self.titleL.text = @"失败是成功滴妈咪";
    }
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
        _bgImg.image = [UIImage imageNamed:@"game_result_guang"];
    }
    return _bgImg;
}

- (UIButton *)cancel{
    if (!_cancel) {
        _cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancel setImage:[UIImage imageNamed:@"game_result_quit"] forState:UIControlStateNormal];
        [_cancel addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        _cancel.adjustsImageWhenHighlighted = NO;
    }
    return _cancel;
}

- (UIButton *)game{
    if (!_game) {
        _game = [UIButton buttonWithType:UIButtonTypeCustom];
        [_game setImage:[UIImage imageNamed:@"game_result_game"] forState:UIControlStateNormal];
        [_game addTarget:self action:@selector(game:) forControlEvents:UIControlEventTouchUpInside];
        _game.adjustsImageWhenHighlighted = NO;
    }
    return _game;
}

- (UIButton *)dismiss{
    if (!_dismiss) {
        _dismiss = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dismiss setImage:[UIImage imageNamed:@"game_result_error"] forState:UIControlStateNormal];
        [_dismiss addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
        _dismiss.adjustsImageWhenHighlighted = NO;
    }
    return _dismiss;
}

- (UIImageView *)resultImg{
    if (!_resultImg) {
        _resultImg = [UIImageView new];
        _resultImg.image = [UIImage imageNamed:@"game_result_success_bg"];
    }
    return _resultImg;
}

- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc] init];
        _titleL.textColor = DYGColorFromHex(0x976A00);
        _titleL.textAlignment = NSTextAlignmentCenter;
        _titleL.font = [UIFont boldSystemFontOfSize:14];
        _titleL.text = @"天呀你是抓娃娃之神吗";
    }
    return _titleL;
}
- (UILabel *)desL{
    if (!_desL) {
        _desL = [[UILabel alloc] init];
        _desL.textColor = DYGColorFromHex(0x976A00);
        _desL.textAlignment = NSTextAlignmentCenter;
        _desL.font = [UIFont systemFontOfSize:12];
        _desL.text = @"10s内投币继续";
    }
    return _desL;
}
- (void)cancel:(UIButton *)sender{
    [self removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(cancelOrShareAction)]) {
        [self.delegate cancelOrShareAction];
    }
}
- (void)game:(UIButton *)sender{
    [self removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(gameAgainOrBringAction)]) {
        [self.delegate gameAgainOrBringAction];
    }
}
- (void)dismiss:(UIButton *)sender{
    [self removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(dismissAction)]) {
        [self.delegate dismissAction];
    }
}

@end
