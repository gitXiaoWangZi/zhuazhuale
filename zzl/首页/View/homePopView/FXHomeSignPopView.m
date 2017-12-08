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
@property (weak, nonatomic) IBOutlet UILabel *diamoNumL;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imgBgArray;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *diamoLArray;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;


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
    NSArray *dataArr = dataDic[@"data"];
    for (NSInteger i = 0; i < dataArr.count; i ++) {
        NSDictionary *dic = dataArr[i];
        UILabel *label = self.diamoLArray[i];
        label.text = [NSString stringWithFormat:@"%@",dic[@"money"]];
        if ([dataDic[@"continuity"] integerValue] == i) {
            self.diamoNumL.text = [NSString stringWithFormat:@"%@",dic[@"money"]];
            [self.loginBtn setTitle:[NSString stringWithFormat:@"今日登录获得%@",dic[@"money"]] forState:UIControlStateNormal];
            [self.loginBtn xm_setImagePosition:XMImagePositionRight titleFont:[UIFont systemFontOfSize:16] spacing:10];
        }
    }
    
    NSInteger continuity = [dataDic[@"continuity"] integerValue];
    for (NSInteger i = 0; i < continuity; i ++) {
        UIImageView *bgImgV = self.imgBgArray[i];
        bgImgV.image = [UIImage imageNamed:@"home_signed"];
        UILabel *label = self.diamoLArray[i];
        label.textColor = [UIColor whiteColor];
    }
    for (NSInteger i = continuity; i < dataArr.count; i ++) {
        UIImageView *bgImgV = self.imgBgArray[i];
        bgImgV.image = [UIImage imageNamed:@"home_circle"];
        UILabel *label = self.diamoLArray[i];
        label.textColor = DYGColorFromHex(0xEABE29);
    }
    
    
    
}
@end
