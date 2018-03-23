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
@property (weak, nonatomic) IBOutlet UILabel *huodeL;

@property (weak, nonatomic) IBOutlet UIButton *zuanNumbtn;
@property (weak, nonatomic) IBOutlet UIImageView *bgIcon;
@end

@implementation FXHomeLoginSuccessPopView

- (void)awakeFromNib{
    [super awakeFromNib];
}

- (IBAction)sureClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(dealThingAfterSuccess)]) {
        [self.delegate dealThingAfterSuccess];
    }
    [self removeFromSuperview];
}

- (void)isSign:(BOOL)status{
    if (status) {//签到
        self.detailL.hidden = NO;
        self.diamoBtn.hidden = NO;
        self.huodeL.hidden = NO;
        self.zuanNumbtn.hidden = YES;
        self.bgIcon.image = [UIImage imageNamed:@"sign_PopView"];
    }else{//周卡月卡
        self.detailL.hidden = YES;
        self.diamoBtn.hidden = YES;
        self.huodeL.hidden = YES;
        self.zuanNumbtn.hidden = NO;
        self.bgIcon.image = [UIImage imageNamed:@"home_card_Popups"];
    }
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
