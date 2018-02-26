//
//  LSJRechargeFooterV.m
//  zzl
//
//  Created by Mr_Du on 2018/1/11.
//  Copyright © 2018年 Mr.Du. All rights reserved.
//

#import "LSJRechargeFooterV.h"

@interface LSJRechargeFooterV()
@property (weak, nonatomic) IBOutlet UIImageView *wechatIcon;
@property (weak, nonatomic) IBOutlet UIImageView *zhifubaoIcon;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;

@end

@implementation LSJRechargeFooterV

- (void)awakeFromNib{
    [super awakeFromNib];
    self.payBtn.layer.cornerRadius = 24.5f;
    self.payBtn.layer.borderColor = DYGColorFromHex(0xD0D0D0).CGColor;
    self.payBtn.layer.borderWidth = 1.f;
    self.payBtn.layer.masksToBounds = YES;
    
    self.wechatIcon.hidden = YES;
    self.zhifubaoIcon.hidden = YES;
    self.paytype = RechargePayTypeNil;
}

- (IBAction)wechatPayAction:(UIButton *)sender {
    self.wechatIcon.hidden = NO;
    self.zhifubaoIcon.hidden = YES;
    self.paytype = RechargePayTypeWechat;
}

- (IBAction)zhufubaoPayAction:(UIButton *)sender {
    self.wechatIcon.hidden = YES;
    self.zhifubaoIcon.hidden = NO;
    self.paytype = RechargePayTypeZhifubao;
}

- (IBAction)payAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(payActionWithType:)]) {
        [self.delegate payActionWithType:self.paytype];
    }
}

- (IBAction)preferentialAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(preferential)]) {
        [self.delegate preferential];
    }
}
@end
