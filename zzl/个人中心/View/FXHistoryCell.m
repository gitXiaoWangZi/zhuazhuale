//
//  FXHistoryCell.m
//  zzl
//
//  Created by Mr_Du on 2017/11/8.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "FXHistoryCell.h"
#import "FXRechargeRecordModel.h"

@interface FXHistoryCell()

@property (nonatomic,strong)UILabel *name;
@property (nonatomic,strong) UILabel *time;
@property (nonatomic,strong) UILabel * money;

@end


@implementation FXHistoryCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self creatUI];
    }
    return self;
}
-(void)creatUI{;
    [self addSubview:self.name];
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(Py(15));
        make.left.equalTo(self).offset(Px(16));
    }];
    [self addSubview:self.time];
    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.name);
        make.top.equalTo(self.name.mas_bottom).offset(Py(8));
    }];
    [self addSubview:self.money];
    [self.money mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-Px(16));
        make.centerY.equalTo(self);
    }];
}

-(void)setFrame:(CGRect)frame {
    frame.size.height-=Py(1);
    [super setFrame:frame];
}
-(UILabel *)name{
    if (!_name) {
        _name = [UILabel labelWithMediumFont:14 WithTextColor:DYGColorFromHex(0x4c4c4c)];
        _name.text = @"口袋熊";
    }
    return _name;
}
-(UILabel *)time{
    if (!_time) {
        _time = [UILabel labelWithMediumFont:11 WithTextColor:DYGColorFromHex(0x999999)];
        _time.text =@"2017-11-08 11:16";
    }
    return _time;
}
-(UILabel *)money{
    if (!_money) {
        _money = [UILabel labelWithMediumFont:16 WithTextColor:DYGColorFromHex(0xed1111)];
//        6ce0ff Add
        _money.text = @"-19";
    }
    return _money;
}

- (void)setModel:(FXRechargeRecordModel *)model{
    _model = model;
    _name.text = model.name;
    _money.text = [NSString stringWithFormat:@"%@%@ 钻石",model.symbol,model.money];
    _time.text = [self dataStrWithTimesp:model.time];
}

- (NSString *)dataStrWithTimesp:(NSString *)timeSp{
    NSTimeInterval time = [timeSp doubleValue];
    NSDate *detailDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [dateFormatter stringFromDate:detailDate];
}
@end
