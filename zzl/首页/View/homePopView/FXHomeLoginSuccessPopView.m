//
//  FXHomeLoginSuccessPopView.m
//  zzl
//
//  Created by Mr_Du on 2017/11/24.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "FXHomeLoginSuccessPopView.h"

@interface FXHomeLoginSuccessPopView()
@property (weak, nonatomic) IBOutlet UILabel *detailL;
@property (weak, nonatomic) IBOutlet UIButton *diamoBtn;

@end

@implementation FXHomeLoginSuccessPopView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self.diamoBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.diamoBtn.imageView.bounds.size.width-5, 0, self.diamoBtn.imageView.bounds.size.width)];
    [self.diamoBtn setImageEdgeInsets:UIEdgeInsetsMake(0, self.diamoBtn.titleLabel.bounds.size.width, 0, -self.diamoBtn.titleLabel.bounds.size.width-5)];
}

- (IBAction)sureClick:(UIButton *)sender {
    [self removeFromSuperview];
}

- (void)setDay:(NSString *)day{
    _day = day;
    self.detailL.text = [NSString stringWithFormat:@"已连续成功登录%zd天",[day intValue] + 1];
}

- (void)setMoney:(NSString *)money{
    _money = money;
    NSString *diamostr = [NSString stringWithFormat:@"恭喜您，获得%@",money];
    [self.diamoBtn setTitle:diamostr forState:UIControlStateNormal];
}
@end
