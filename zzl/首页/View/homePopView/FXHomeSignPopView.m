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
    NSInteger continuity = [dataDic[@"continuity"] integerValue];
    for (NSInteger i = 0; i < continuity; i ++) {
        UIImageView *bgImgV = self.imgBgArray[i];
        bgImgV.image = [UIImage imageNamed:[NSString stringWithFormat:@"%zdClick",i+1]];
    }
    for (NSInteger i = continuity; i < 7; i ++) {
        UIImageView *bgImgV = self.imgBgArray[i];
        bgImgV.image = [UIImage imageNamed:[NSString stringWithFormat:@"%zdday",i+1]];
    }
    
    
    
}
@end
