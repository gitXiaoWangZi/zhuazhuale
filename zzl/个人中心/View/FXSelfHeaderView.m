//
//  FXSelfHeaderView.m
//  zzl
//
//  Created by Mr_Du on 2017/11/6.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "FXSelfHeaderView.h"
#import "FXTouchView.h"
#import "DYGTapGestureRecognizer.h"
#import "AccountItem.h"
@interface FXSelfHeaderView()

@property(nonatomic,strong)UILabel * name;
@property (nonatomic,strong) UILabel *ID;
@property (nonatomic,strong) UIImageView *editBtn;
@property (nonatomic,strong) UIImageView * iconImg;
@property (nonatomic,strong) FXTouchView * touchView;

@property (nonatomic,strong) NSArray *titleArr;



@end;

@implementation FXSelfHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.titleArr =@[@"战绩",@"战利品",@"钻石"];
        for (int i = 0; i<3; i++) {
            self.touchView = [[FXTouchView alloc]initWithFrame:CGRectMake(Px(125)*i, Py(169), Px(125), Py(53))];
            self.touchView.tag = i;
            self.touchView.title.text = self.titleArr[i];
            DYGTapGestureRecognizer * tap = [[DYGTapGestureRecognizer alloc]initWithTarget:self action:@selector(viewDidClick:)];
            [self.touchView addGestureRecognizer:tap];
            [self addSubview:self.touchView];
        }
        [self addSubview:self.name];
        [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(Px(39));
            make.top.equalTo(self).offset(Py(62));
        }];
        [self addSubview:self.ID];
        [self.ID mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.name);
            make.top.equalTo(self.name.mas_bottom).offset(Py(10));
        }];
        [self addSubview:self.editBtn];
        [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.ID);
            make.top.equalTo(self.ID.mas_bottom).offset(Py(10));
        }];
        [self addSubview:self.iconImg];
        [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-Px(39));
            make.top.equalTo(self).offset(Py(66));
            make.size.mas_equalTo(CGSizeMake(Px(71), Py(71)));
        }];
        self.iconImg.cornerRadius = Px(71/2);
        self.iconImg.layer.masksToBounds = YES;
        self.iconImg.borderColor = systemColor;
        self.iconImg.borderWidth = 1;
    }
    return self;
}

-(void)viewDidClick:(DYGTapGestureRecognizer *)tap{
    if ([self.delegate respondsToSelector:@selector(viewTouchWithTag:)]) {
        [self.delegate viewTouchWithTag:tap.view.tag];
    }
    
}

-(void)editBtnClick{
    if ([self.delegate respondsToSelector:@selector(editBtnDidClick)]) {
        [self.delegate editBtnDidClick];
    }
}


-(UILabel *)name{
    if (!_name) {
        _name = [UILabel labelWithBoldFont:33 WithTextColor:systemColor WithAlignMent:NSTextAlignmentLeft];
        _name.text = @"";
    }
    return _name;
}
-(UILabel *)ID{
    if (!_ID) {
        _ID = [UILabel labelWithMediumFont:14 WithTextColor:DYGColorFromHex(0x777777)];
        _ID.text = @"我的ID:1";
    }
    return _ID;
}

-(UIImageView *)editBtn{
    if (!_editBtn) {
        _editBtn = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"edit"]];
        _editBtn.userInteractionEnabled = YES;
        [_editBtn sizeToFit];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(editBtnClick)];
        [_editBtn addGestureRecognizer:tap];
    }
    return _editBtn;
}
-(UIImageView *)iconImg{
    if (!_iconImg) {
        _iconImg = [[UIImageView alloc]init];
        _iconImg.backgroundColor = systemColor;
    }
    return _iconImg;
}

- (void)setItem:(AccountItem *)item {
    _item = item;
    [_iconImg sd_setImageWithURL:[NSURL URLWithString:item.img_path] placeholderImage:nil];
    _name.text = item.username;
    _ID.text = [NSString stringWithFormat:@"我的ID:%@",item.ID];
    FXTouchView *touchV = [self viewWithTag:2];
    touchV.num.text = item.money;
}

@end








