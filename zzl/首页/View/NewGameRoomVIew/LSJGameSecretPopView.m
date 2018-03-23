//
//  LSJGameSecretPopView.m
//  zzl
//
//  Created by Mr_Du on 2018/3/22.
//  Copyright © 2018年 Mr.Du. All rights reserved.
//

#import "LSJGameSecretPopView.h"

@interface LSJGameSecretPopView()
@property (weak, nonatomic) IBOutlet UILabel *showL1;
@property (weak, nonatomic) IBOutlet UILabel *showL2;
@property (weak, nonatomic) IBOutlet UILabel *showL3;
@property (weak, nonatomic) IBOutlet UILabel *showL4;
@property (weak, nonatomic) IBOutlet UILabel *getWaWaL;

@end

@implementation LSJGameSecretPopView

+ (instancetype)shareInstance{
    return [[[NSBundle mainBundle] loadNibNamed:@"LSJGameSecretPopView" owner:nil options:nil] firstObject];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
}

- (IBAction)dimissAction:(UIButton *)sender {
    [self removeFromSuperview];
}

- (void)refreshViewWithDic:(NSDictionary *)dictionary{
    self.showL1.text = dictionary[@"one"];
    self.showL2.text = dictionary[@"two"];
    self.showL3.text = dictionary[@"three"];
    self.showL4.text = dictionary[@"four"];
    NSString *average = dictionary[@"average"];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:average];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:22] range:NSMakeRange(4, average.length-9)];
    self.getWaWaL.attributedText = attrString;
}
@end
