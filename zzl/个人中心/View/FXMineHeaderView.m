//
//  FXSelfHeaderView.m
//  zzl
//
//  Created by Mr_Du on 2017/11/6.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "FXMineHeaderView.h"
#import "DYGTapGestureRecognizer.h"
#import "AccountItem.h"
#import "UIButton+Position.h"
@interface FXMineHeaderView()

@property(nonatomic,strong)UILabel * name;
@property (nonatomic,strong) UIImageView * bgImg;
@property (nonatomic,strong) UIImageView * iconImg;
@property (nonatomic,strong) UIButton *zjBtn;
@property (nonatomic,strong) UIButton *zsBtn;
@property (nonatomic,strong) UIButton *zlpBtn;

@property (nonatomic,strong) NSArray *titleArr;



@end;

@implementation FXMineHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.bgImg];
        [self.bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(self);
        }];
        
        [self addSubview:self.iconImg];
        [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self.mas_centerY).offset(Py(-10));
            make.size.mas_equalTo(CGSizeMake(Px(71), Py(71)));
        }];
        
        [self addSubview:self.name];
        [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.iconImg.mas_bottom).offset(Py(5));
        }];
        
        [self addSubview:self.zjBtn];
        [self.zjBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.bottom.equalTo(self);
            make.width.equalTo(@((kScreenWidth-2)/3.0));
            make.height.equalTo(@(50));
        }];
        UIView *line0 = [[UIView alloc] init];
        line0.backgroundColor = BGColor;
        line0.frame = CGRectMake((kScreenWidth-2)/3.0, self.height - 40, 1, 30);
        [self addSubview:line0];
        
        [self addSubview:self.zsBtn];
        [self.zsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.zjBtn.mas_right).offset(1);
            make.bottom.equalTo(self);
            make.width.equalTo(@((kScreenWidth-2)/3.0));
            make.height.equalTo(@(50));
        }];
        UIView *line1 = [[UIView alloc] init];
        line1.backgroundColor = BGColor;
        line1.frame = CGRectMake((kScreenWidth-2)*2/3.0+1, self.height - 40, 1, 30);
        [self addSubview:line1];
        
        [self addSubview:self.zlpBtn];
        [self.zlpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self);
            make.bottom.equalTo(self);
            make.width.equalTo(@((kScreenWidth-2)/3.0));
            make.height.equalTo(@(50));
        }];
        
        self.iconImg.cornerRadius = Px(71/2);
        self.iconImg.layer.masksToBounds = YES;
        self.iconImg.borderColor = systemColor;
        self.iconImg.borderWidth = 1;
    }
    return self;
}

- (void)changeInfo:(UITapGestureRecognizer *)tap{
    if ([self.delegate respondsToSelector:@selector(editBtnDidClick)]) {
        [self.delegate editBtnDidClick];
    }
}

- (UIImageView *)bgImg{
    if (!_bgImg) {
        _bgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pic"]];
    }
    return _bgImg;
}

-(UILabel *)name{
    if (!_name) {
        _name = [UILabel labelWithBoldFont:16 WithTextColor:systemColor WithAlignMent:NSTextAlignmentLeft];
    }
    return _name;
}
-(UIImageView *)iconImg{
    if (!_iconImg) {
        _iconImg = [[UIImageView alloc]init];
        _iconImg.backgroundColor = systemColor;
        _iconImg.userInteractionEnabled = YES;
        _iconImg.image = [UIImage imageNamed:@"鱿鱼center"];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeInfo:)];
        [_iconImg addGestureRecognizer:tap];
    }
    return _iconImg;
}

- (UIButton *)zjBtn{
    if (!_zjBtn) {
        _zjBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_zjBtn setTitle:@"战绩" forState:UIControlStateNormal];
        [_zjBtn setTitleColor:TextColor forState:UIControlStateNormal];
        _zjBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_zjBtn addTarget:self action:@selector(zjAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _zjBtn;
}

- (void)zjAction:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(viewTouchWithTag:)]) {
        [self.delegate viewTouchWithTag:0];
    }
}
- (void)zsAction:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(viewTouchWithTag:)]) {
        [self.delegate viewTouchWithTag:1];
    }
}
- (void)zlpAction:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(viewTouchWithTag:)]) {
        [self.delegate viewTouchWithTag:2];
    }
}

- (UIButton *)zsBtn{
    if (!_zsBtn) {
        _zsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_zsBtn setTitle:@"钻石" forState:UIControlStateNormal];
        [_zsBtn setTitleColor:TextColor forState:UIControlStateNormal];
        _zsBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_zsBtn addTarget:self action:@selector(zsAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _zsBtn;
}

- (UIButton *)zlpBtn{
    if (!_zlpBtn) {
        _zlpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_zlpBtn setTitle:@"战利品" forState:UIControlStateNormal];
        [_zlpBtn setTitleColor:TextColor forState:UIControlStateNormal];
        _zlpBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_zlpBtn addTarget:self action:@selector(zlpAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _zlpBtn;
}

- (void)setItem:(AccountItem *)item {
    _item = item;
    [_iconImg sd_setImageWithURL:[NSURL URLWithString:item.img_path] placeholderImage:nil];
    _name.text = item.username;
    [_zsBtn setTitle:item.money forState:UIControlStateNormal];
    [_zsBtn setImage:[UIImage imageNamed:@"price"] forState:UIControlStateNormal];
    [_zsBtn xm_setImagePosition:XMImagePositionLeft titleFont:[UIFont systemFontOfSize:16] spacing:10];
}

@end









