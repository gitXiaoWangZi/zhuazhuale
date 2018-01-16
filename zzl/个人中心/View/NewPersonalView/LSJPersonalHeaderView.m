//
//  LSJPersonalHeaderView.m
//  zzl
//
//  Created by Mr_Du on 2017/12/28.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "LSJPersonalHeaderView.h"
#import "AccountItem.h"

@interface LSJPersonalHeaderView()
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *IDL;
@property (weak, nonatomic) IBOutlet UILabel *zuanshiL;

@property (weak, nonatomic) IBOutlet UIView *zuanNumView;
@property (weak, nonatomic) IBOutlet UIView *rechargeView;
@property (weak, nonatomic) IBOutlet UIView *otherPayViewView;

@end

@implementation LSJPersonalHeaderView

+ (instancetype)shareInstance{
    return [[[NSBundle mainBundle] loadNibNamed:@"LSJPersonalHeaderView" owner:nil options:nil] firstObject];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.iconImgV.layer.cornerRadius = 75/2.0;
    self.iconImgV.layer.masksToBounds = YES;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:btn];
    [btn addTarget:self action:@selector(changeUserInfo:) forControlEvents:UIControlEventTouchUpInside];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.iconImgV);
        make.centerY.equalTo(self.iconImgV);
        make.width.equalTo(@(80));
        make.height.equalTo(@(80));
    }];
    
    
    UITapGestureRecognizer *tap0 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zuanshi:)];
    [self.zuanNumView addGestureRecognizer:tap0];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recharge:)];
    [self.rechargeView addGestureRecognizer:tap1];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(otherPay:)];
    [self.otherPayViewView addGestureRecognizer:tap2];
}

- (void)zuanshi:(UITapGestureRecognizer *)tap{
    if ([self.delegate respondsToSelector:@selector(doHeaderNavAction:)]) {
        [self.delegate doHeaderNavAction:personalHeaderZuanshi];
    }
}

- (void)recharge:(UITapGestureRecognizer *)tap{
    if ([self.delegate respondsToSelector:@selector(doHeaderNavAction:)]) {
        [self.delegate doHeaderNavAction:personalHeaderRecharge];
    }
}

- (void)otherPay:(UITapGestureRecognizer *)tap{
    if ([self.delegate respondsToSelector:@selector(doHeaderNavAction:)]) {
        [self.delegate doHeaderNavAction:personalHeaderOtherPay];
    }
}

- (void)changeUserInfo:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(doHeaderNavAction:)]) {
        [self.delegate doHeaderNavAction:personalHeaderIcon];
    }
}

- (IBAction)backAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(doHeaderNavAction:)]) {
        [self.delegate doHeaderNavAction:personalHeaderBack];
    }
}

- (IBAction)msgAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(doHeaderNavAction:)]) {
        [self.delegate doHeaderNavAction:personalHeaderMsg];
    }
}

- (IBAction)settingAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(doHeaderNavAction:)]) {
        [self.delegate doHeaderNavAction:personalHeaderSetting];
    }
}

- (void)setItem:(AccountItem *)item{
    _item = item;
    [_iconImgV sd_setImageWithURL:[NSURL URLWithString:item.img_path] placeholderImage:[UIImage imageNamed:@"default_icon"]];
    _nameL.text = item.username;
    _zuanshiL.text = [NSString stringWithFormat:@"剩余%@钻石",item.money];
    _IDL.text = [NSString stringWithFormat:@"ID:%@",item.ID];
}

@end
