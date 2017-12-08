//
//  FXCommentView.m
//  zzl
//
//  Created by Mr_Du on 2017/11/2.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "FXCommentView.h"
#import "FXLabelCollectionCell.h"
static  NSString * reuserId = @"labelCell";

@interface FXCommentView()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong)UIImageView * mesImg;

@property(nonatomic,strong)UIButton * sendBtn;
@property(nonatomic,strong)UICollectionView * collectionView;
@property (nonatomic,strong) UIView *line;
@property (nonatomic,strong) NSArray *dataArr;
@end

@implementation FXCommentView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    
    [self addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(self.mas_width);
        make.height.mas_equalTo(1);
    }];
    [self addSubview:self.sendBtn];
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self);
        make.width.equalTo(@(Px(63)));
        make.bottom.equalTo(self.line.mas_top);
    }];
    [self addSubview:self.mesImg];
    [self.mesImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(Px(16));
        make.centerY.equalTo(self.sendBtn.mas_centerY);
    }];
    [self addSubview:self.commentTF];
    [self.commentTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.width.equalTo(@(Px(262)));
        make.right.equalTo(self.sendBtn.mas_left);
        make.bottom.equalTo(self.line.mas_top);
    }];
    [self addSubview:self.collectionView];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FXLabelCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuserId forIndexPath:indexPath];
    cell.label.text =self.dataArr[indexPath.row];
    return  cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(Px(50),Py(40));
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    FXLabelCollectionCell * cell = (FXLabelCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    self.commentTF.text =cell.label.text;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0,Px(10),0,Px(10));
}

#pragma mark lazy load
-(UIImageView *)mesImg{
    if (!_mesImg) {
        _mesImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"talk_nor"]];
        [_mesImg sizeToFit];
    }
    return _mesImg;
}
-(UITextField *)commentTF{
    if (!_commentTF) {
        _commentTF = [[UITextField alloc]init];
        _commentTF.backgroundColor = DYGColorFromHex(0xffffff);
        _commentTF.textColor = DYGColorFromHex(0x555555);
        _commentTF.font = [UIFont systemFontOfSize:13];
        _commentTF.tintColor = systemColor;
        _commentTF.placeholder = @"吐槽点什么吧";
        _commentTF.rightViewMode = UITextFieldViewModeAlways;
        _commentTF.rightView = [UIView viewWithFrame:CGRectMake(0, 0, 1, Py(20)) WithBackGroundColor:DYGColorFromHex(0xdbdbdb)];
    }
    return _commentTF;
}
-(UIButton *)sendBtn{
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithTitle:@"发送" titleColor:TextColor font:17];
        _sendBtn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:17];
        [_sendBtn addTarget:self action:@selector(sendClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, Py(40), kScreenWidth,Py(40)) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = DYGColorFromHex(0xffffff);
        [_collectionView registerClass:[FXLabelCollectionCell class] forCellWithReuseIdentifier:reuserId];
    }
    return _collectionView;
}
-(UIView *)line{
    if (!_line) {
        _line = [[UIView alloc]init];
        _line.backgroundColor = DYGColorFromHex(0xdbdbdb);
    }
    return _line;
}
-(NSArray *)dataArr{
    if (!_dataArr) {
        _dataArr =@[@"让位置",@"666",@"辣眼睛",@"神操作",@"抓抓抓",@"什么鬼"];
    }
    return _dataArr;
}

- (void)sendClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(sendClick)]) {
        [self.delegate sendClick];
    }
}

@end
