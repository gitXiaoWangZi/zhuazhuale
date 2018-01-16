//
//  FXGameDetailContentView.m
//  zzl
//
//  Created by Mr_Du on 2017/12/22.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "FXGameDetailContentView.h"

@interface FXGameDetailContentView()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *wawaname;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *num;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *gameNo;
@property (weak, nonatomic) IBOutlet UIButton *shensuBtn;
@property (weak, nonatomic) IBOutlet UIImageView *bigImg;

@end

@implementation FXGameDetailContentView

+ (instancetype)shareInstance{
    return [[[NSBundle mainBundle] loadNibNamed:@"FXGameDetailContentView" owner:nil options:nil] firstObject];
}
- (void)awakeFromNib{
    [super awakeFromNib];
    _shensuBtn.layer.cornerRadius = 17.5f;
    _shensuBtn.layer.masksToBounds = YES;
    
}
- (void)reloadDataWithModel:(WwGameHistory*)model {
    [self.bigImg sd_setImageWithURL:[NSURL URLWithString:model.wawa.pic]];
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.wawa.pic]];
    self.wawaname.text = model.wawa.name;
    self.date.text = model.dateline;
    self.num.text = [NSString stringWithFormat:@"x%ld",model.coin];
    self.gameNo.text = model.orderId;
    if (model.status == 2) {
        _status.text = @"成功";
        [_status setTextColor:DYGColorFromHex(0xfed811)];
    }
    else if (model.status == 1) {
        _status.text = @"失败";
        [_status setTextColor:DYGColorFromHex(0x797979)];
    }
    else if (model.status == 0) {
        // 故障
        _status.text = @"失败";
        [_status setTextColor:DYGColorFromHex(0x797979)];
    }
}
- (void)updataComplainState:(BOOL)complain {
    if (complain) {
        [_shensuBtn setTitle:@"申诉" forState:UIControlStateNormal];
        _shensuBtn.enabled = YES;
    }
    else {
        [_shensuBtn setTitle:@"已申诉" forState:UIControlStateNormal];
        _shensuBtn.enabled = NO;
    }
}


- (IBAction)playAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(jumpPageWithStatus:)]) {
        [self.delegate jumpPageWithStatus:1];
    }
    
}
- (IBAction)shensuAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(jumpPageWithStatus:)]) {
        [self.delegate jumpPageWithStatus:2];
    }
}
@end
