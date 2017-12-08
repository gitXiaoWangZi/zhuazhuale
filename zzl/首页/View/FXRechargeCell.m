//
//  FXRechargeCell.m
//  zzl
//
//  Created by Mr_Du on 2017/11/3.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "FXRechargeCell.h"
#import "FXPriceCell.h"

static NSString * reuserId = @"priceCell";

@interface FXRechargeCell()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSArray *diamoNumArr;
@property (nonatomic,strong) NSArray *moneyArr;

@end


@implementation FXRechargeCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        if ([reuseIdentifier isEqualToString:@"selectCell"]) {
            [self creatUI];
        }else{
            self.selectionStyle = UITableViewCellSelectionStyleNone;
            [self addSubview:self.collectionView];
            [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.equalTo(self);
                make.bottom.equalTo(self).offset(Py(0));
                make.height.equalTo(@(178));
            }];
        }
    }
    return self;
}

-(void)creatUI{
    [self addSubview:self.icon];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(Px(16));
        make.centerY.equalTo(self);
//        make.size.mas_equalTo(CGSizeMake(Px(26), Py(26)));
    }];
//    [self addSubview:self.firstIcon];
//    [self.firstIcon mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.icon.mas_right).offset(Px(12));
//        make.centerY.equalTo(self);
//    }];
    [self addSubview:self.payType];
    [self.payType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.icon.mas_right).offset(Px(16));
    }];
    [self addSubview:self.seletBtn];
    [self.seletBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-Px(16));
        make.size.mas_equalTo(CGSizeMake(Px(23), Py(23)));
    }];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 6;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FXPriceCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuserId forIndexPath:indexPath];
    cell.money.text = self.diamoNumArr[indexPath.row];
    [cell.pay setTitle:self.moneyArr[indexPath.row] forState:UIControlStateNormal];
    if ([self.firstpunch intValue] == 1) {//首冲
        cell.firstIcon.hidden = NO;
        cell.isFirst = @"YES";
    }else{
        cell.firstIcon.hidden = YES;
        cell.isFirst = @"NO";
    }
    return  cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kScreenWidth/2,Py(59));
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *visibleCells = [collectionView visibleCells];
    for (FXPriceCell *cell in visibleCells) {
        [cell.pay setTitleColor:systemColor forState:UIControlStateNormal];
        cell.pay.borderColor = systemColor;
        [cell.pay setBackgroundColor:[UIColor whiteColor]];
        cell.pay.borderWidth = 1;
    }
    FXPriceCell *cell = (FXPriceCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell.pay setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cell.pay setBackgroundColor:systemColor];
    cell.pay.borderColor = systemColor;
    cell.pay.borderWidth = 1;
    
    if ([self.delegate respondsToSelector:@selector(payActionWithMoney:)]) {
        [self.delegate payActionWithMoney:cell.money.text];
    }
}

#pragma mark lazy load

-(UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wechat"]];
    }
    return _icon;
}

-(UIButton *)seletBtn{
    if (!_seletBtn) {
        _seletBtn = [UIButton new];
        [_seletBtn setBackgroundImage:[UIImage imageNamed:@"select_no"] forState:UIControlStateNormal];
        [_seletBtn setBackgroundImage:[UIImage imageNamed:@"select"] forState:UIControlStateSelected];
        _seletBtn.userInteractionEnabled = NO;
    }
    return _seletBtn;
}
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = DYGColorFromHex(0xffffff);
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:[FXPriceCell class] forCellWithReuseIdentifier:reuserId];
    }
    return _collectionView;
}

-(UILabel *)payType{
    if (!_payType) {
        _payType=[UILabel labelWithMediumFont:14 WithTextColor:DYGColorFromHex(0x4c4c4c)];
        _payType.text = @"支付宝";
    }
    return _payType;
}

//-(void)setIsSelect:(NSInteger)isSelect{
//    _isSelect = isSelect;
//    self.seletBtn.selected = !self.seletBtn.selected;
////    if (_isSelect==1) {
////        self.seletBtn.selected = YES;
////    }else{
////        self.seletBtn.selected = NO;
////    }
//}

#pragma mark lazyload
- (NSArray *)diamoNumArr{
    if (!_diamoNumArr) {
        _diamoNumArr = @[@"1000",@"2000",@"5000",@"10000",@"30000",@"50000"];
    }
    return _diamoNumArr;
}

- (NSArray *)moneyArr{
    if (!_moneyArr) {
        _moneyArr = @[@"¥10",@"¥20",@"¥50",@"¥100",@"¥300",@"¥500"];
    }
    return _moneyArr;
}
@end
