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
    [self addSubview:self.icon];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(Px(14));
        make.centerY.equalTo(self);
    }];
    [self addSubview:self.title];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon.mas_right).offset(Px(10));
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
        _title = [[UILabel alloc] init];
        _title.font = [UIFont systemFontOfSize:15];
        _title.textColor = DYGColorFromHex(0x3b3b3b);
        _title.text =@"设为默认";
    }
    return _title;
}
-(UISwitch *)open{
    if (!_open) {
        _open = [[UISwitch alloc]init];
        _open.on = NO;
        _open.onTintColor =DYGColorFromHex(0xfed811);
        [_open addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _open;
}
-(UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
    }
    return _icon;
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
