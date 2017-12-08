//
//  FXLabelCollectionCell.m
//  zzl
//
//  Created by Mr_Du on 2017/11/3.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "FXLabelCollectionCell.h"

@interface FXLabelCollectionCell()


@end

@implementation FXLabelCollectionCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.label];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.height.equalTo(@(Py(22)));
            make.width.equalTo(self.contentView);
        }];
    }
    return self;
}

-(UILabel *)label{
    if (!_label) {
        _label = [UILabel labelWithFont:13 WithTextColor:TextColor WithAlignMent:NSTextAlignmentCenter];
    }
    return _label;
}


@end
