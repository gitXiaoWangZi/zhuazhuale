//
//  FXSpoilsCell.m
//  zzl
//
//  Created by Mr_Du on 2017/11/8.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "FXSpoilsCell.h"
#import "UIButton+Position.h"

@interface FXSpoilsCell()
@property(nonatomic,strong)UIImageView * photo;
@property (nonatomic,strong)UILabel *name;
@property (nonatomic,strong) UILabel *time;
@property (nonatomic,strong) UIButton *zuanshiBtn;
@property (nonatomic,strong) UIButton *desBtn;

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
        make.left.equalTo(self).offset(Px(17));
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self addSubview:self.photo];
    [self.photo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.isSelectBtn.mas_right).offset(Px(10));
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(Px(60), Px(60)));
    }];
    [self addSubview:self.name];
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(Py(22));
        make.left.equalTo(self.photo.mas_right).offset(Px(9));
        make.height.equalTo(@(Py(12)));
    }];
    [self addSubview:self.time];
    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.name);
        make.top.equalTo(self.name.mas_bottom).offset(Py(5));
        make.height.equalTo(@(Py(11)));
    }];
    [self addSubview:self.zuanshiBtn];
    [self.zuanshiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.time.mas_bottom).offset(Py(5));
        make.left.equalTo(self.time.mas_left);
        make.size.mas_equalTo(CGSizeMake(Px(43), Py(22)));
    }];
    [self addSubview:self.desBtn];
    [self.desBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.mas_right).offset(-Px(11));
    }];
}

-(void)setFrame:(CGRect)frame {
    frame.size.height-=Py(1);
    [super setFrame:frame];
}

-(UILabel *)name{
    if (!_name) {
        _name = [[UILabel alloc] init];
        _name.font = kPingFangSC_Semibold(12);
        _name.textColor = DYGColorFromHex(0x4d4d4d);
    }
    return _name;
}
-(UILabel *)time{
    if (!_time) {
        _time = [[UILabel alloc] init];
        _time.font = kPingFangSC_Regular(11);
        _time.textColor = DYGColorFromHex(0x797979);
        _time.hidden = YES;
    }
    return _time;
}
-(UIImageView *)photo{
    if (!_photo) {
        _photo = [[UIImageView alloc]init];
        _photo.image = [UIColor whiteColor].colorImage;
        _photo.cornerRadius = Px(10);
        _photo.layer.masksToBounds = YES;
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

- (UIButton *)zuanshiBtn{
    if (!_zuanshiBtn) {
        _zuanshiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_zuanshiBtn setImage:[UIImage imageNamed:@"mine_gameDetail_diamond"] forState:UIControlStateNormal];
        [_zuanshiBtn setTitle:@"x10" forState:UIControlStateNormal];
        [_zuanshiBtn setTitleColor:DYGColorFromHex(0x797979) forState:UIControlStateNormal];
        _zuanshiBtn.titleLabel.font = kPingFangSC_Regular(11);
        [_zuanshiBtn xm_setImagePosition:XMImagePositionLeft titleFont:[UIFont systemFontOfSize:11] spacing:5];
        _zuanshiBtn.enabled = NO;
    }
    return _zuanshiBtn;
}

- (UIButton *)desBtn{
    if (!_desBtn) {
        _desBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_desBtn setTitle:@"可寄存15天" forState:UIControlStateNormal];
        [_desBtn setTitleColor:DYGColorFromHex(0x4d4d4d) forState:UIControlStateNormal];
        _desBtn.titleLabel.font = kPingFangSC_Regular(12);
        [_desBtn addTarget:self action:@selector(desAction:) forControlEvents:UIControlEventTouchUpInside];
        _desBtn.enabled = NO;
    }
    return _desBtn;
}

- (void)desAction:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(checkTheLogistics:)]) {
        [self.delegate checkTheLogistics:self.indexPath];
    }
}

- (void)setCelltype:(WwWawaListType)celltype{
    _celltype = celltype;
    switch (celltype) {
        case WawaList_Deposit://寄存
        {
            self.isSelectBtn.hidden = NO;
        }
            break;
        case WawaList_Deliver://已发货
        {
            self.isSelectBtn.hidden = YES;
            self.zuanshiBtn.hidden = YES;
            [self.desBtn setTitle:@"查看物流" forState:UIControlStateNormal];
            [self.desBtn setTitleColor:DYGColorFromHex(0xd9b600) forState:UIControlStateNormal];
            self.desBtn.enabled = YES;
            [self.photo mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(Px(12));
                make.centerY.equalTo(self);
                make.size.mas_equalTo(CGSizeMake(Px(60), Py(60)));
            }];
            [self.name mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).offset(Py(32));
                make.left.equalTo(self.photo.mas_right).offset(Px(9));
                make.height.equalTo(@(Py(12)));
            }];
        }
            break;
        case WawaList_Exchange://已兑换
        {
            self.isSelectBtn.hidden = YES;
            self.zuanshiBtn.hidden = YES;
            self.desBtn.hidden = YES;
            [self.photo mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(Px(12));
                make.centerY.equalTo(self);
                make.size.mas_equalTo(CGSizeMake(Px(60), Py(60)));
            }];
            [self.name mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).offset(Py(32));
                make.left.equalTo(self.photo.mas_right).offset(Px(9));
                make.height.equalTo(@(Py(12)));
            }];
        }
            break;
        case WawaList_All://借用，指代寄存娃娃发货的页面
        {
            self.isSelectBtn.hidden = YES;
            [self.photo mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(Px(12));
                make.centerY.equalTo(self);
                make.size.mas_equalTo(CGSizeMake(Px(60), Py(60)));
            }];
        }
            break;
            
        default:
            break;
    }
}

- (void)setItem:(WwOrderItem *)item{
    _item = item;
    [_photo sd_setImageWithURL:[NSURL URLWithString:item.pic] placeholderImage:[UIImage imageNamed:@""]];
    _name.text = item.name;
    _time.text = @"待确定的时间";
}

- (void)setModel:(WwDepositItem *)model{
    _model = model;
    [_photo sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:[UIImage imageNamed:@""]];
    _name.text = model.name;
    _time.text = @"待确定的时间";
    [_desBtn setTitle:[NSString stringWithFormat:@"寄存剩余%zd天",model.expTime] forState:UIControlStateNormal];
    _isSelectBtn.selected = model.selected;
    [_zuanshiBtn setTitle:[NSString stringWithFormat:@"x%zd",model.coin] forState:UIControlStateNormal];
    [_zuanshiBtn xm_setImagePosition:XMImagePositionLeft titleFont:[UIFont systemFontOfSize:11] spacing:5];
}
@end
