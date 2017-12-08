//
//  FXOnlineView.m
//  zzl
//
//  Created by Mr_Du on 2017/11/2.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "FXOnlineView.h"
#import "UIColor+DYGAdd.h"
#import "FXOnlineIconCell.h"
#import "UIButton+Position.h"

@interface FXOnlineView()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UIButton *backBtn;

@property (nonatomic,strong) UIButton *cameraBtn;
@property (nonatomic,strong) UIButton *switchBtn;
@property (nonatomic,strong) UIButton *bgMusicBtn;
@property (nonatomic,strong) UIView *videoView;

@property (nonatomic,strong) UIImageView *testImg;

#pragma mark bottomView
@property (nonatomic,strong) UIButton *commentBtn;
@property (nonatomic,strong) UIButton *recharge;
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UIImageView *bgImg;

#pragma mark userView
@property (nonatomic,strong) UIView *userView;
@property (nonatomic,strong) UILabel *nameL;
@property (nonatomic,strong) UIImageView *iconImgV;


@end

@implementation FXOnlineView
static NSString * reuserId= @"roomCell";
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self creatUI];
        [self creatBottomView];
        [[WwGameManager GameMgrInstance] enablePing:YES];
    }
    return self;
}

-(void)creatUI{
    
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.top.equalTo(@0);
        make.height.equalTo(@(kScreenHeight * 0.77 + 80));
    }];
    
    [self.bgView addSubview:self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(25));
        make.left.equalTo(@(25));
        make.width.height.equalTo(@(25));
    }];
    
    [self.bgView addSubview:self.defaultPlayView];
    [self.defaultPlayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(10));
        make.right.equalTo(@(-10));
        make.top.equalTo(@(60));
        make.height.equalTo(@(kScreenHeight * 0.77 - 60));
    }];
    self.defaultPlayView.layer.cornerRadius = 10;
    self.defaultPlayView.layer.masksToBounds = YES;
    
    [self.bgView addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.bgView);
        make.top.equalTo(@(kScreenHeight * 0.77));
        make.height.equalTo(@(80));
    }];
    
    [self.bgView addSubview:self.collectionView];
    [self.bgView addSubview:self.peopleNum];
    [self.peopleNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView).offset(Px(-20));
        make.top.equalTo(@(70));
        make.size.mas_equalTo(CGSizeMake(Px(78), Py(20)));
    }];
    [self.bgView addSubview:self.pingBtn];
    [self.pingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.peopleNum);
        make.top.equalTo(self.peopleNum.mas_bottom).offset(Py(8));
        make.size.mas_equalTo(CGSizeMake(Px(78), Py(20)));
    }];
    
    [self.bgView addSubview:self.cameraBtn];
    [self.cameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView);
        make.centerY.equalTo(self.bgView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(Px(30), Py(52)));
    }];
    [self.bgView addSubview:self.bgMusicBtn];
    [self.bgMusicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.mas_right).offset(-Px(25));
        make.bottom.equalTo(self.bottomView.mas_top).offset(-10);
    }];

    [self.bgView addSubview:self.switchBtn];
    [self.switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgMusicBtn);
        make.size.equalTo(self.bgMusicBtn);
        make.right.equalTo(self.bgMusicBtn.mas_left).offset(-Px(5));
    }];
    
    [self.bgView addSubview:self.userView];
    [self.userView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(10));
        make.top.equalTo(@(60));
        make.width.equalTo(@(87));
        make.height.equalTo(@(115));
    }];
    
    self.nameL.frame = CGRectMake(0, 0, 87, 30);
    [self.userView addSubview:self.nameL];
    
    [self.userView addSubview:self.iconImgV];
    [self.iconImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userView).offset(2);
        make.right.equalTo(@(-2));
        make.bottom.equalTo(@(-2));
        make.top.equalTo(@(30));
    }];
    
}
-(void)creatBottomView{
    [self.bottomView addSubview:self.commentBtn];
    [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomView);
        make.size.mas_equalTo(CGSizeMake(Px(43), Py(44)));
        make.left.equalTo(self.bottomView.mas_left).offset(Px(13));
    }];
    [self.bottomView addSubview:self.playView];
    [self.playView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.bottomView);
        make.size.mas_equalTo(CGSizeMake(Px(143), Py(43)));
    }];
    [self.playView addSubview:self.bgImg];
    [self.bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.playView);
    }];
    [self.playView addSubview:self.gameState];
    [self.gameState mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.playView.mas_centerX);
        make.top.equalTo(self.playView.mas_top).offset(Py(4));
    }];
    [self.playView addSubview:self.price];
    [self.price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.playView.mas_centerX);
        make.top.equalTo(self.gameState.mas_bottom);
        make.bottom.equalTo(self.playView.mas_bottom);
        make.width.equalTo(@(Px(60)));
    }];
    [self.playView sendSubviewToBack:self.bgImg];
    [self.bottomView addSubview:self.recharge];
    [self.recharge mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.commentBtn.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(Px(66), Py(29)));
        make.right.equalTo(self.bottomView.mas_right).offset(-Px(13));
    }];
    [self.bottomView addSubview: self.balance];
    [self.balance mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.recharge.mas_right);
        make.centerY.equalTo(self.playView.mas_top);
    }];
}
#pragma mark system Delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FXOnlineIconCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuserId forIndexPath:indexPath];
    cell.cornerRadius = Px(12.5);
    cell.layer.masksToBounds = YES;
    cell.backgroundColor = DYGRandomColor;
    WwUserModel *model = self.dataArray[indexPath.row];
    [cell.iconImgV sd_setImageWithURL:[NSURL URLWithString:model.portrait] placeholderImage:[UIImage imageNamed:@"user_default"]];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(Px(25),Py(25));
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0,Px(4),0,Px(4));
}

-(void)palyViewClick{
    DYGLog(@"开始游戏");
    if ([self.delegate respondsToSelector:@selector(playGameAction)]) {
        [self.delegate playGameAction];
    }
}

-(void)commentBtnClick{
    if ([self.delegate respondsToSelector:@selector(commentViewPop)]) {
        [self.delegate commentViewPop];
    }
}

-(void)rechargeBtnClick{
    if ([self.delegate respondsToSelector:@selector(rechargeBtnDidClick)]) {
        [self.delegate rechargeBtnDidClick];
    }
}

//改变视角
- (void)cameraBtnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(cameraBtnDidClick:)]) {
        [self.delegate cameraBtnDidClick:btn];
    }
}

-(void)musicBtnClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"musicBtnDidClick" object:nil userInfo:@{@"open":@(sender.selected)}];
}
-(void)switchBtnClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"bulletBtnDidClick" object:nil userInfo:@{@"open":@(sender.selected)}];
}

- (void)backBtnClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(popToView)]) {
        [self.delegate popToView];
    }
}

#pragma mark lazy load

- (UIView *)defaultPlayView{
    if (!_defaultPlayView) {
        _defaultPlayView = [[UIView alloc] init];
        _defaultPlayView.backgroundColor = [UIColor blackColor];
    }
    return _defaultPlayView;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithImage:@"popBack" WithHighlightedImage:@"popBack"];
        [_backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor colorWithHexString:@"ffea00" alpha:1];
    }
    return _bgView;
}

-(UIView *)videoView{
    if (!_videoView) {
        _videoView = [[UIView alloc]init];
        _videoView.backgroundColor = [UIColor whiteColor];
    }
    return _videoView;
}

-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]init];
        _bottomView.backgroundColor = [UIColor colorWithHexString:@"ffea00" alpha:1];;
    }
    return _bottomView;
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumLineSpacing=Px(4);
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(kScreenWidth-Px(130), Py(25), Px(120),Py(25)) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerNib:[UINib nibWithNibName:@"FXOnlineIconCell" bundle:nil] forCellWithReuseIdentifier:reuserId];
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}
-(UIButton *)peopleNum{
    if (!_peopleNum) {
        _peopleNum = [UIButton buttonWithImage:@"piont" WithTitle:@"0人围观" WithColor:DYGColorFromHex(0xffffff) WithFont:10];
        _peopleNum.userInteractionEnabled = NO;
        _peopleNum.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.2];
        _peopleNum.cornerRadius = 10;
        _peopleNum.layer.masksToBounds = YES;
        [_peopleNum xm_setImagePosition:XMImagePositionRight titleFont:[UIFont systemFontOfSize:10] spacing:10];
    }
    return _peopleNum;
}
-(UIButton *)pingBtn{
    if (!_pingBtn) {
        _pingBtn = [UIButton buttonWithImage:@"wifi" WithTitle:@"30ms" WithColor:DYGColorFromHex(0xffffff) WithFont:10];
        _pingBtn.userInteractionEnabled = NO;
        _pingBtn.cornerRadius = 10;
        _pingBtn.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.2];
        _pingBtn.layer.masksToBounds = YES;
        [_pingBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0 )];
    }
    return _pingBtn;
}
-(UIButton *)cameraBtn{
    if (!_cameraBtn) {
        _cameraBtn = [UIButton buttonWithImage:@"camera" WithHighlightedImage:@"camera"];
        [_cameraBtn addTarget:self action:@selector(cameraBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cameraBtn;
}

-(UIButton *)bgMusicBtn{
    if (!_bgMusicBtn) {
        _bgMusicBtn = [UIButton buttonWithImage:@"sound_open" WithHighlightedImage:@"sound_down"];
        [_bgMusicBtn setImage:[UIImage imageNamed:@"sound_down"] forState:UIControlStateSelected];
        [_bgMusicBtn addTarget:self action:@selector(musicBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bgMusicBtn;
}
-(UIButton *)switchBtn{
    if (!_switchBtn) {
        _switchBtn = [UIButton buttonWithImage:@"bar_open" WithHighlightedImage:@"bar_down"];
        [_switchBtn setImage:[UIImage imageNamed:@"bar_down"] forState:UIControlStateSelected];
        [_switchBtn addTarget:self action:@selector(switchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchBtn;
}

#pragma mark bottomView
-(UIButton *)commentBtn{
    if (!_commentBtn) {
        _commentBtn = [UIButton buttonWithImage:@"talk" WithHighlightedImage:@"talk"];
        [_commentBtn addTarget:self action:@selector(commentBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentBtn;
}
-(UIImageView *)bgImg{
    if (!_bgImg) {
        _bgImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"start"]];
    }
    return _bgImg;
}
-(UIView *)playView{
    if (!_playView) {
        _playView = [UIView new];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(palyViewClick)];
        [_playView addGestureRecognizer:tap];
    }
    return _playView;
}
-(UIButton *)recharge{
    if (!_recharge) {
        _recharge = [UIButton buttonWithImage:@"recharge" WithHighlightedImage:@"recharge"];
        [_recharge addTarget:self action:@selector(rechargeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _recharge;
}
-(UIButton *)price{
    if (!_price) {
        _price = [UIButton buttonWithImage:@"dia_small" WithTitle:@"X0" WithColor:DYGColorFromHex(0xffffff) WithFont:11];
        _price.imageEdgeInsets = UIEdgeInsetsMake(-Py(5), 0, 0, 0);
        _price.titleEdgeInsets = UIEdgeInsetsMake(-Py(5), 0, 0, 0);
        _price.userInteractionEnabled = NO;
    }
    return _price;
}
-(UILabel *)gameState{
    if (!_gameState) {
        _gameState = [UILabel labelWithFont:16 WithTextColor:DYGColorFromHex(0xffffff)];
        _gameState.textAlignment = NSTextAlignmentCenter;
        _gameState.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        _gameState.text =@"开始游戏";
    }
    return _gameState;
}

-(UILabel *)balance{
    if (!_balance) {
        _balance = [UILabel labelWithFont:10 WithTextColor:TextColor];
        _balance.text =@"我的钻石:13421";
    }
    return _balance;
}


-(UIImageView *)testImg{
    if (!_testImg) {
        _testImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"testImg"]];
    }
    return _testImg;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark userView
- (UIView *)userView{
    if (!_userView) {
        _userView = [[UIView alloc] init];
        _userView.backgroundColor = DYGColorFromHex(0xffd800);
        _userView.layer.cornerRadius = 5;
        _userView.layer.masksToBounds = YES;
    }
    return _userView;
}

- (UILabel *)nameL{
    if (!_nameL) {
        _nameL = [UILabel labelWithFont:14 WithTextColor:DYGColorFromHex(0xffffff)];
        _nameL.textAlignment = NSTextAlignmentCenter;
        _nameL.text =@"虚位以待";
    }
    return _nameL;
}

- (UIImageView *)iconImgV{
    if (!_iconImgV) {
        _iconImgV = [[UIImageView alloc] init];
        _iconImgV.backgroundColor = [UIColor whiteColor];
        _iconImgV.layer.cornerRadius = 5;
        _iconImgV.layer.masksToBounds = YES;
        _iconImgV.contentMode = UIViewContentModeScaleAspectFill;
        _iconImgV.image = [UIImage imageNamed:@"鱿鱼center"];
    }
    return _iconImgV;
}

- (void)setRoomID:(NSInteger)roomID{
    if (self.dataArray.count > 0) {
        [self.dataArray removeAllObjects];
    }
    [[WwGameManager GameMgrInstance] requestAudienceListWithRoomID:roomID page:1 complete:^(BOOL success, NSInteger code, NSArray<WwUserModel *> *waInfo) {
        if (!success) {
            NSLog(@"获取围观列表失败");
        }else{
            for (WwUserModel *model in waInfo) {
                [self.dataArray addObject:model];
            }
            NSString *num = [NSString stringWithFormat:@"%zd人围观",self.dataArray.count];
            [_peopleNum setTitle:num forState:UIControlStateNormal];
            [_peopleNum xm_setImagePosition:XMImagePositionRight titleFont:[UIFont systemFontOfSize:10] spacing:10];
            [self.collectionView reloadData];
        }
    }];
}

- (void)setModel:(WwUserModel *)model{
    _model = model;
    if (model == nil) {
        self.nameL.text = @"虚位以待";
        self.iconImgV.image = [UIImage imageNamed:@"鱿鱼center"];
    }else{
        self.nameL.text = model.nickname;
        [self.iconImgV sd_setImageWithURL:[NSURL URLWithString:model.portrait] placeholderImage:[UIImage imageNamed:@"鱿鱼center"]];
    }
    
}

@end

