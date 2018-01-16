//
//  WawaInfoHeaderView.m
//  MyTabbar
//
//  Created by Mr_Du on 2017/12/26.
//  Copyright © 2017年 Mr.Liu. All rights reserved.
//

#import "WawaInfoHeaderView.h"
#import "UIButton+Position.h"

@interface WawaInfoHeaderView()
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *wawasizeL;
@property (weak, nonatomic) IBOutlet UILabel *fabricL;
@property (weak, nonatomic) IBOutlet UILabel *innerL;
@property (weak, nonatomic) IBOutlet UIButton *priceBtn;

@end

@implementation WawaInfoHeaderView

+ (instancetype)shareInstance{
    return [[[NSBundle mainBundle] loadNibNamed:@"WawaInfoHeaderView" owner:nil options:nil] firstObject];
}

- (void)refreshHeaderWithmodel:(WwWaWaDetail *)model{
    self.nameL.text = model.name;
    self.wawasizeL.text = model.size;
    self.fabricL.text = model.material;
    self.innerL.text = model.filler;
    NSString *price = [NSString stringWithFormat:@"%zd",model.coin];
    [self.priceBtn setTitle:price forState:UIControlStateNormal];
    [self.priceBtn setImage:[UIImage imageNamed:@"dia_small"] forState:UIControlStateNormal];
    [self.priceBtn xm_setImagePosition:XMImagePositionRight titleFont:[UIFont systemFontOfSize:12] spacing:8];
}
@end
