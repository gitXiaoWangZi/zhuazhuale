//
//  FXHomeLoginSuccessPopView.m
//  zzl
//
//  Created by Mr_Du on 2017/11/24.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "FXHomeLoginSuccessPopView.h"
#import "UIButton+Position.h"

@interface FXHomeLoginSuccessPopView()
@property (weak, nonatomic) IBOutlet UILabel *detailL;
@property (weak, nonatomic) IBOutlet UIButton *diamoBtn;

@end

@implementation FXHomeLoginSuccessPopView

- (void)awakeFromNib{
    [super awakeFromNib];
}

- (IBAction)sureClick:(UIButton *)sender {
    [self removeFromSuperview];
}

- (void)setDay:(NSString *)day{
    _day = day;
    self.detailL.text = [NSString stringWithFormat:@"本周积累签到%zd天",[day intValue] + 1];
}

- (void)setMoney:(NSString *)money{
    _money = money;
    [self.diamoBtn setTitle:money forState:UIControlStateNormal];
}
@end
