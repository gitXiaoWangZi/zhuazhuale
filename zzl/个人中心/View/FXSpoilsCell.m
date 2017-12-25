//
//  FXSpoilsCell.m
//  zzl
//
//  Created by Mr_Du on 2017/11/8.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "FXSpoilsCell.h"

@interface FXSpoilsCell()
@property(nonatomic,strong)UIImageView * photo;
@property (nonatomic,strong)UILabel *name;
@property (nonatomic,strong) UILabel *time;
//@property (nonatomic,strong) UIButton *applyBtn;

@end

@implementation FXSpoilsCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self creatUI];
    }
    return self;
}
-(void)creatUI{
    [self addSubview:self.isSelectBtn];
    [self.isSelectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(Px(10));
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self addSubview:self.photo];
    [self.photo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.isSelectBtn.mas_right).offset(Px(10));
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(Px(50), Py(50)));
    }];
    [self addSubview:self.name];
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(Py(20));
        make.left.equalTo(self.photo.mas_right).offset(Px(15));
    }];
    [self addSubview:self.time];
    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.name);
        make.top.equalTo(self.name.mas_bottom).offset(Py(8));
    }];
//    [self addSubview:self.applyBtn];
//    [self.applyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self);
//        make.right.equalTo(self).offset(-Px(16));
//        make.size.mas_equalTo(CGSizeMake(Px(80), Py(30)));
//    }];
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
//-(UIButton *)applyBtn{
//    if (!_applyBtn) {
//        _applyBtn = [UIButton buttonWithTitle:@"申请发货" titleColor:systemColor font:14];
//        _applyBtn.borderColor = systemColor;
//        _applyBtn.borderWidth =1;
//        _applyBtn.cornerRadius =Py(15);
//        _applyBtn.layer.masksToBounds = YES;
//    }
//    return _applyBtn;
//}
-(UIImageView *)photo{
    if (!_photo) {
        _photo = [[UIImageView alloc]init];
        _photo.image = [UIColor whiteColor].colorImage;
        _photo.cornerRadius = Px(25);
        _photo.layer.masksToBounds = YES;
        _photo.borderColor = systemColor;
        _photo.borderWidth =1;
    }
    return _photo;
}

- (UIButton *)isSelectBtn{
    if (!_isSelectBtn) {
        _isSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_isSelectBtn setImage:[UIImage imageNamed:@"address_normal"] forState:UIControlStateNormal];
        [_isSelectBtn setImage:[UIImage imageNamed:@"address_selected"] forState:UIControlStateSelected];
        _isSelectBtn.userInteractionEnabled = NO;
    }
    return _isSelectBtn;
}

- (void)setIsShow:(BOOL)isShow{
    _isShow = isShow;
    
    if (!isShow) {
        self.isSelectBtn.hidden = YES;
        [self.photo mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(Px(10));
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(Px(50), Py(50)));
        }];
    }
}

- (void)setItem:(WwOrderItem *)item{
    _item = item;
    [_photo sd_setImageWithURL:[NSURL URLWithString:item.pic] placeholderImage:[UIImage imageNamed:@""]];
    _name.text = item.name;
    _time.hidden = YES;
}

- (void)setModel:(WwDepositItem *)model{
    _model = model;
    [_photo sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:[UIImage imageNamed:@""]];
    _name.text = model.name;
    _time.text = [NSString stringWithFormat:@"寄存剩余%zd天",model.expTime];
    _isSelectBtn.selected = model.selected;
}
@end
