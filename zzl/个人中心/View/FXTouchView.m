//
//  FXTouchView.m
//  zzl
//
//  Created by Mr_Du on 2017/11/6.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "FXTouchView.h"
#import "DYGTapGestureRecognizer.h"
@interface FXTouchView()



@end

@implementation FXTouchView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.num];
        [self addSubview:self.title];
        [self.num mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(Py(3));
            make.centerX.equalTo(self);
        }];
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-Py(3));
            make.centerX.equalTo(self);
        }];
    }
    return self;
}

-(UILabel *)num{
    if (!_num) {
        _num = [UILabel labelWithMediumFont:16 WithTextColor:TextColor];
        _num.textAlignment = NSTextAlignmentCenter;
        _num.text = @"0";
    }
    return _num;
}

-(UILabel *)title{
    if (!_title) {
        _title = [UILabel labelWithMediumFont:12 WithTextColor:DYGColorFromHex(0x4d4d4d)];
        _title.text = @"战绩";
        _title.textAlignment = NSTextAlignmentCenter;
    }
    return _title;
}


@end
