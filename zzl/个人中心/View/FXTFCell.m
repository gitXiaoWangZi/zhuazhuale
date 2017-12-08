//
//  FXTFCell.m
//  zzl
//
//  Created by Mr_Du on 2017/11/7.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "FXTFCell.h"

@interface FXTFCell()


@end

@implementation FXTFCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    [self addSubview:self.leftLabel];
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(Px(16));
        make.centerY.equalTo(self);
    }];
    [self addSubview:self.inputTF];
    [self.inputTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftLabel.mas_right).offset(Px(20));
        make.width.equalTo(@(Px(230)));
        make.height.equalTo(self);
    }];
}

-(UITextField *)inputTF{
    if (!_inputTF) {
        _inputTF = [[UITextField alloc]init];
        _inputTF.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        _inputTF.textColor = DYGColorFromHex(0x4c4c4c);
        _inputTF.tintColor = systemColor;
    }
    return _inputTF;
}

-(UILabel *)leftLabel{
    if (!_leftLabel) {
        _leftLabel = [UILabel labelWithMediumFont:16 WithTextColor:DYGColorFromHex(0x4c4c4c)];
        _leftLabel.text =@"Test";
    }
    return _leftLabel;
}

@end
