//
//  LSJOperationNormalView.m
//  zzl
//
//  Created by Mr_Du on 2017/12/30.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "LSJOperationNormalView.h"

@interface LSJOperationNormalView()
@property (nonatomic,strong) UIImageView *bgImgV;
@property (nonatomic,strong) UIButton *perspectiveBtn;
@property (nonatomic,strong) UIButton *msgBtn;
@end

@implementation LSJOperationNormalView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addChildView];
    }
    return self;
}

- (void)addChildView{
    [self addSubview:self.bgImgV];
    [self.bgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(0);
        make.top.equalTo(self.mas_top).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
    }];
    [self addSubview:self.perspectiveBtn];
    [self.perspectiveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.bottom.equalTo(self.mas_bottom).offset(-40);
    }];
    [self addSubview:self.gameBtn];
    [self.gameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.mas_bottom).offset(-30);
    }];
    [self addSubview:self.msgBtn];
    [self.msgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-20);
        make.bottom.equalTo(self.mas_bottom).offset(-40);
    }];
}

#pragma mark lazyload
- (UIImageView *)bgImgV{
    if (!_bgImgV) {
        _bgImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"game_bottom_normal"]];
    }
    return _bgImgV;
}
- (UIButton *)perspectiveBtn{
    if (!_perspectiveBtn) {
        _perspectiveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_perspectiveBtn setBackgroundImage:[UIImage imageNamed:@"game_normal_view_normal"] forState:UIControlStateNormal];
        [_perspectiveBtn setBackgroundImage:[UIImage imageNamed:@"game_normal_view_select"] forState:UIControlStateHighlighted];
        [_perspectiveBtn setBackgroundImage:[UIImage imageNamed:@"game_normal_view_normal"] forState:UIControlStateSelected];
        _perspectiveBtn.backgroundColor = [UIColor clearColor];
        [_perspectiveBtn addTarget:self action:@selector(perspectiveAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _perspectiveBtn;
}
- (UIButton *)gameBtn{
    if (!_gameBtn) {
        _gameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_gameBtn setBackgroundImage:[UIImage imageNamed:@"game_normal_game_normal"] forState:UIControlStateNormal];
        [_gameBtn setBackgroundImage:[UIImage imageNamed:@"game_normal_game_select"] forState:UIControlStateHighlighted];
        [_gameBtn addTarget:self action:@selector(gameAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _gameBtn;
}
- (UIButton *)msgBtn{
    if (!_msgBtn) {
        _msgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_msgBtn setBackgroundImage:[UIImage imageNamed:@"game_normal_msg_normal"] forState:UIControlStateNormal];
        [_msgBtn setBackgroundImage:[UIImage imageNamed:@"game_normal_msg_select"] forState:UIControlStateHighlighted];
        [_msgBtn addTarget:self action:@selector(msgAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _msgBtn;
}
- (void)perspectiveAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(dealWithbottomViewBy:button:)]) {
        [self.delegate dealWithbottomViewBy:OperationNormalViewView button:sender];
    }
}
- (void)gameAction:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(dealWithbottomViewBy:button:)]) {
        [self.delegate dealWithbottomViewBy:OperationNormalViewGame button:sender];
    }
}
- (void)msgAction:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(dealWithbottomViewBy:button:)]) {
        [self.delegate dealWithbottomViewBy:OperationNormalViewMsg button:sender];
    }
}
@end
