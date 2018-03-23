//
//  FXHomeSignPopView.m
//  zzl
//
//  Created by Mr_Du on 2017/11/23.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "FXHomeSignPopView.h"
#import "UIButton+Position.h"

@interface FXHomeSignPopView()
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imgBgArray;
@property (weak, nonatomic) IBOutlet UILabel *monthDayNumL;
@property (weak, nonatomic) IBOutlet UILabel *weekDayNumL;


@end

@implementation FXHomeSignPopView

- (void)awakeFromNib{
    [super awakeFromNib];
}

- (IBAction)dismissClick:(UIButton *)sender {
    [self removeFromSuperview];
}

- (IBAction)loginClick:(UIButton *)sender {
    if (self.signActionBlock) {
        self.signActionBlock(_dataDic[@"continuity"]);
    }
}

- (void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    NSInteger continuity = [dataDic[@"continuity"] integerValue];
    for (NSInteger i = 0; i < continuity; i ++) {
        UIImageView *bgImgV = self.imgBgArray[i];
        bgImgV.image = [UIImage imageNamed:[NSString stringWithFormat:@"%zdClick",i+1]];
    }
    for (NSInteger i = continuity; i < 7; i ++) {
        UIImageView *bgImgV = self.imgBgArray[i];
        bgImgV.image = [UIImage imageNamed:[NSString stringWithFormat:@"%zdday",i+1]];
    }
    
    self.monthDayNumL.text = [NSString stringWithFormat:@"月卡剩余%@天",dataDic[@"card"][@"month_time"]];
    self.weekDayNumL.text = [NSString stringWithFormat:@"周卡剩余%@天",dataDic[@"card"][@"week_time"]];
    
}

- (IBAction)monthCardAction:(UIButton *)sender {
    if (self.jumpMonthH5ActionBlock) {
        self.jumpMonthH5ActionBlock();
    }
}

- (IBAction)weekCardAction:(UIButton *)sender {
    if (self.jumpWeekH5ActionBlock) {
        self.jumpWeekH5ActionBlock();
    }
}
@end
