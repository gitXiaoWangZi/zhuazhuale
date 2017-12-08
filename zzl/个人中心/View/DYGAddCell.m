//
//  DYGAddCell.m
//  CS2.1
//
//  Created by Mr_Du on 2017/8/10.
//  Copyright © 2017年 Mr_Du. All rights reserved.
//

#import "DYGAddCell.h"

@interface DYGAddCell()

@property (nonatomic,strong) UIImageView * addImg;
@property (nonatomic,strong) UILabel *addLabel;

@end

@implementation DYGAddCell
-(UIImageView *)addImg{
    if (!_addImg) {
        _addImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"addImg"]];
        [_addImg sizeToFit];
    }
    return _addImg;
}

-(UILabel *)addLabel{
    if (!_addLabel) {
        _addLabel = [[UILabel alloc]init];
        _addLabel.text =@"添加照片";
        _addLabel.textColor = [UIColor colorWithHexString:@"c6c6c6" alpha:1];
        _addLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _addLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _addLabel;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self creatAddCell];
    }
    return self;
}
-(void)creatAddCell{
    [self.contentView addSubview:self.addImg];
    [self.addImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.centerY.equalTo(self.contentView.mas_centerY).offset(-5);
//        make.width.height.equalTo(@21);
    }];
    [self.contentView addSubview:self.addLabel];
    [self.addLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.top.equalTo(self.addImg.mas_bottom).offset(6);
    }];
}
@end
