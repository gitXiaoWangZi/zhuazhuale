//
//  DYGCollectionViewCell.m
//  CS2.1
//
//  Created by Mr_Du on 2017/8/10.
//  Copyright © 2017年 Mr_Du. All rights reserved.
//

#import "DYGCollectionViewCell.h"

@interface DYGCollectionViewCell()

@property (nonatomic,strong) UIButton *delect;


@end
@implementation DYGCollectionViewCell

-(UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc]init];
    }
    return _imgView;
}
-(UIButton *)delect{
    if (!_delect) {
        _delect = [[UIButton alloc]init];
        [_delect setBackgroundImage:[UIImage imageNamed:@"deleteimg"] forState:UIControlStateNormal];
    }
    return _delect;
}



-(instancetype)initWithFrame:(CGRect)frame{
    self= [super initWithFrame:frame];
    if (self) {
        [self creatDelectCell];
    }
    return self;
}

-(void)creatDelectCell{
    [self.contentView addSubview:self.imgView];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.left.right.top.bottom.equalTo(self);
    }];
    [self.contentView addSubview:self.delect];
    [self.delect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(-3);
        make.right.equalTo(self.contentView.mas_right).offset(5);
        make.height.width.equalTo(@22);
    }];
    [self.delect addTarget:self action:@selector(delectBtnClick) forControlEvents:UIControlEventTouchUpInside];
}
-(void)delectBtnClick{
    if ([self.delegate respondsToSelector:@selector(delectImgWithTag:)]) {
        [self.delegate delectImgWithTag:self.tag];
    }
}

//-(void)setImgArray:(NSMutableArray *)imgArray{
//    _imgArray = imgArray;
//    
//}



@end
