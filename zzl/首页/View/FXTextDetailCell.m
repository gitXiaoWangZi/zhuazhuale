//
//  FXTextDetailCell.m
//  zzl
//
//  Created by Mr_Du on 2017/11/2.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "FXTextDetailCell.h"

@interface FXTextDetailCell()

@end


@implementation FXTextDetailCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatUI];
    }
    return self;
}
-(void)creatUI{
    [self.contentView addSubview:self.title];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(Px(13));
        make.centerY.equalTo(self.contentView);
    }];
    [self.contentView addSubview:self.subLabel];
    [self.subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(Px(100));
        make.centerY.equalTo(self.contentView);
    }];
}

-(UILabel *)title{
    if (!_title) {
        _title = [UILabel labelWithFont:13 WithTextColor:DYGColorFromHex(0x999999)];
    }
    return _title;
}

-(UILabel *)subLabel{
    if (!_subLabel) {
        _subLabel = [UILabel labelWithFont:14 WithTextColor:TextColor];
        _subLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    }
    return _subLabel;
}


@end
