//
//  LSJKoulingPopView.m
//  zzl
//
//  Created by Mr_Du on 2018/1/5.
//  Copyright © 2018年 Mr.Du. All rights reserved.
//

#import "LSJKoulingPopView.h"

@interface LSJKoulingPopView()
@property (weak, nonatomic) IBOutlet UIView *centerView;
@property (weak, nonatomic) IBOutlet UIView *tfView;
@property (weak, nonatomic) IBOutlet UITextField *msgTF;

@end

@implementation LSJKoulingPopView

+(instancetype)shareInstance {
    return [[[NSBundle mainBundle] loadNibNamed:@"LSJKoulingPopView" owner:nil options:nil] firstObject];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.centerView.layer.cornerRadius = 10;
    self.centerView.layer.masksToBounds = YES;
    self.tfView.layer.cornerRadius = 18.5f;
    self.tfView.layer.masksToBounds = YES;
    
}

- (IBAction)bringAction:(UIButton *)sender {
    if (self.sendKoulingClock) {
        self.sendKoulingClock(self.msgTF.text);
    }
}

- (IBAction)removeAction:(UIButton *)sender {
    [self removeFromSuperview];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}
@end
