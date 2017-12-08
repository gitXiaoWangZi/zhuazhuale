//
//  FXSwitchCell.m
//  zzl
//
//  Created by Mr_Du on 2017/11/7.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "FXSwitchCell.h"

@interface FXSwitchCell()



@end



@implementation FXSwitchCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    [self addSubview:self.title];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(Px(16));
        make.centerY.equalTo(self);
    }];
    [self addSubview:self.open];
    [self.open mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-Px(16));
        make.centerY.equalTo(self.title);
        make.size.mas_equalTo(CGSizeMake(Px(50), Py(30)));
    }];
}

-(UILabel *)title{
    if (!_title) {
        _title = [UILabel labelWithMediumFont:16 WithTextColor:DYGColorFromHex(0x4c4c4c)];
        _title.text =@"设为默认";
    }
    return _title;
}
-(UISwitch *)open{
    if (!_open) {
        _open = [[UISwitch alloc]init];
        _open.on = NO;
        _open.onTintColor =systemColor;
        [_open addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _open;
}
-(void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        DYGLog(@"已设为默认");
    }else {
        DYGLog(@"取消默认");
    }
}


@end
