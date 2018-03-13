//
//  LSJTopView.m
//  zzl
//
//  Created by Mr_Du on 2017/12/29.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "LSJTopView.h"
#import "FXOnlineIconCell.h"
#import "LSJOperationNormalView.h"
#import "BulletView.h"
#import "BulletManager.h"
#import "BulletBackgroudView.h"
#import "UIButton+Position.h"
#import "ZYCountDownView.h"

@interface LSJTopView()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UIButton *backBtn;

@property (nonatomic,strong) UIImageView *bgImgV;
@property (nonatomic,strong) UIImageView *iconImgV;

@property (nonatomic,strong) UICollectionView *audienceCollectV;
@property (nonatomic,strong) UIImageView *personNumImgV;
@property (nonatomic,strong) UILabel *personNumL;

@property (nonatomic,strong) UIView *zuanshiView;
@property (nonatomic,strong) UIImageView *zuanshiBgImgV;
@property (nonatomic,strong) UIImageView *zuanshiImgV;
@property (nonatomic,strong) UIImageView *rechargeImgV;

@property (nonatomic,strong) UIImageView *musicImgV;
@property (nonatomic,strong) UILabel *musicL;
@property (nonatomic,strong) UIImageView *barrageImgV;
@property (nonatomic,strong) UILabel *barrageL;
@property (nonatomic,strong) UIImageView *musicNoImgV;
@property (nonatomic,strong) UIImageView *barrageNoImgV;
@property (nonatomic,strong) UIButton *musicBtn;
@property (nonatomic,strong) UIButton *barrageBtn;

@property (nonatomic,strong) UIImageView *clockImgV;//闹钟图标
@property (nonatomic,strong) UILabel *clockL;//
@property (nonatomic,strong) UILabel *clockCountDownL;//
@property (nonatomic,strong) UIView *lineView;//

@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,assign) int countDownTime;

@end

@implementation LSJTopView
static NSString * reuserId= @"roomCell";

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUpChildView];
    }
    return self;
}

- (void)setUpChildView{
    //返回按钮
    [self addSubview:self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(10));
        make.top.equalTo(@(20));
        make.width.equalTo(@(20));
        make.height.equalTo(@(Px(70)));
    }];
    //头像背景
    [self addSubview:self.bgImgV];
    [self.bgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backBtn.mas_right).offset(Px(5));
        make.centerY.equalTo(self.backBtn);
        make.width.equalTo(@(Px(70)));
        make.height.equalTo(@(Px(70)));
    }];
    //头像
    [self addSubview:self.iconImgV];
    [self.iconImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgImgV);
        make.centerX.equalTo(self.bgImgV);
        make.width.equalTo(self.bgImgV.mas_width).offset(-10);
        make.height.equalTo(self.bgImgV.mas_height).offset(-10);
    }];
    self.iconImgV.layer.cornerRadius = Px(30);
    self.iconImgV.layer.masksToBounds = YES;
    //倒计时
    [self addSubview:self.countDownV];
    [self.countDownV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgImgV);
        make.centerX.equalTo(self.bgImgV);
        make.width.equalTo(self.bgImgV.mas_width).offset(-10);
        make.height.equalTo(self.bgImgV.mas_height).offset(-10);
    }];
    self.countDownV.layer.cornerRadius = Px(30);
    self.countDownV.layer.masksToBounds = YES;
    self.countDownV.hidden = YES;
    //游戏状态
    [self addSubview:self.statusImgV];
    [self.statusImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgImgV);
        make.bottom.equalTo(self.bgImgV.mas_bottom).offset(0);
    }];
    //围观控件
    [self addSubview:self.audienceCollectV];
    [self.audienceCollectV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgImgV);
        make.left.equalTo(self.bgImgV.mas_right).offset(3);
        make.width.equalTo(@(Py(103)));
        make.height.equalTo(@(Py(40)));
    }];
    //围观人数背景
    [self addSubview:self.personNumImgV];
    [self.personNumImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgImgV);
        make.left.equalTo(self.audienceCollectV.mas_right).offset(0);
        make.width.equalTo(@(Px(35)));
        make.height.equalTo(@(Px(35)));
    }];
    //围观人数
    [self addSubview:self.personNumL];
    [self.personNumL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.personNumImgV);
        make.centerX.equalTo(self.personNumImgV);
        make.width.equalTo(@(Px(30)));
        make.height.equalTo(@(Px(30)));
    }];
    //充值背景
    [self addSubview:self.zuanshiBgImgV];
    [self.zuanshiBgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgImgV);
        make.right.equalTo(self.mas_right).offset(-10);
    }];
    self.zuanshiBgImgV.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recharge:)];
    [self.zuanshiBgImgV addGestureRecognizer:tap];
    //充值钻石
    [self addSubview:self.zuanshiImgV];
    [self.zuanshiImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.zuanshiBgImgV);
        make.left.equalTo(self.zuanshiBgImgV.mas_left).offset(10);
        make.width.equalTo(@(Px(18)));
        make.height.equalTo(@(Px(15.5)));
    }];
    //加号
    [self addSubview:self.rechargeImgV];
    [self.rechargeImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.zuanshiBgImgV);
        make.right.equalTo(self.zuanshiBgImgV.mas_right).offset(2);
        make.width.equalTo(@(Px(35.5)));
        make.height.equalTo(@(Px(35)));
    }];
    //钻石数量
    [self addSubview:self.zuanshiNumL];
    [self.zuanshiNumL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.zuanshiBgImgV);
        make.left.equalTo(self.zuanshiImgV.mas_right).offset(0);
        make.right.equalTo(self.rechargeImgV.mas_left).offset(0);
    }];
    [self.zuanshiNumL sizeToFit];
    //视频页面
    [self addSubview:self.playView];
    [self.playView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgImgV.mas_bottom).offset(8);
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(Py(-80));
    }];
    //音乐图
    [self addSubview:self.musicImgV];
    [self.musicImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.playView.mas_top).offset(Py(10));
        make.right.equalTo(self.playView.mas_right).offset(-5);
    }];
    //音乐禁止图
    [self addSubview:self.musicNoImgV];
    [self.musicNoImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.musicImgV.mas_bottom).offset(0);
        make.right.equalTo(self.musicImgV.mas_right).offset(0);
    }];
    self.musicNoImgV.hidden = YES;
    //音乐文字
    [self addSubview:self.musicL];
    [self.musicL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.musicImgV);
        make.top.equalTo(self.musicImgV.mas_bottom).offset(0);
    }];
    //音乐按钮
    [self addSubview:self.musicBtn];
    [self.musicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.musicImgV);
        make.centerY.equalTo(self.musicImgV);
        make.width.equalTo(self.musicImgV);
        make.height.equalTo(self.musicImgV);
    }];
    //弹幕图
    [self addSubview:self.barrageImgV];
    [self.barrageImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.musicL.mas_bottom).offset(Py(10));
        make.centerX.equalTo(self.musicImgV);
    }];
    //弹幕禁止图
    [self addSubview:self.barrageNoImgV];
    [self.barrageNoImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.barrageImgV.mas_bottom).offset(0);
        make.right.equalTo(self.barrageImgV.mas_right).offset(0);
    }];
    self.barrageNoImgV.hidden = YES;
    //弹幕文字
    [self addSubview:self.barrageL];
    [self.barrageL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.barrageImgV);
        make.top.equalTo(self.barrageImgV.mas_bottom).offset(0);
    }];
    //弹幕按钮
    [self addSubview:self.barrageBtn];
    [self.barrageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.barrageImgV);
        make.centerY.equalTo(self.barrageImgV);
        make.width.equalTo(self.barrageImgV);
        make.height.equalTo(self.barrageImgV);
    }];
    //游戏操作
    [self addSubview:self.normalView];
    [self.normalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.height.equalTo(@(Py(108)));
    }];
    //弹幕
    [self addSubview:self.bulletBgView];
    [self.bulletBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.barrageL.mas_bottom).offset(5);
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.height.equalTo(@(Py(190)));
    }];
    //每次多少金币
    [self addSubview:self.perPayBtn];
    [self.perPayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.normalView.mas_top).offset(-20);
        make.centerX.equalTo(self.mas_centerX);
//        make.width.equalTo(@(Px(93)));
        make.height.equalTo(@(Py(19)));
    }];
    self.perPayBtn.layer.cornerRadius = Py(9.5);
    self.perPayBtn.layer.masksToBounds = YES;
    
    //现价每次多少金币
    [self addSubview:self.currentPayBtn];
    [self.currentPayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.perPayBtn.mas_top).offset(-4);
        make.centerX.equalTo(self.mas_centerX);
//        make.width.equalTo(@(Px(93)));
        make.height.equalTo(@(Py(19)));
    }];
    self.currentPayBtn.layer.cornerRadius = Py(9.5);
    self.currentPayBtn.layer.masksToBounds = YES;
    
    [self addSubview:self.clockCountDownL];
    [self.clockCountDownL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.perPayBtn.mas_bottom).offset(10);
        make.right.equalTo(self.mas_right).offset(-Px(24));
        make.width.equalTo(@(Px(50)));
        make.height.equalTo(@(Py(16)));
    }];
    self.clockCountDownL.layer.cornerRadius = Py(8);
    self.clockCountDownL.layer.masksToBounds = YES;
    
    [self addSubview:self.clockL];
    [self.clockL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.clockCountDownL.mas_top).offset(-Py(3));
        make.centerX.equalTo(self.clockCountDownL.mas_centerX);
    }];
    
    [self addSubview:self.clockImgV];
    [self.clockImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.clockL.mas_top).offset(-Py(3));
        make.centerX.equalTo(self.clockCountDownL.mas_centerX);
    }];
    [self addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.perPayBtn.mas_width);
        make.centerX.equalTo(self.perPayBtn.mas_centerX);
        make.centerY.equalTo(self.perPayBtn.mas_centerY);
        make.height.equalTo(@(1));
    }];
    
    [self creaetBarrage];
    [self.bulletManager start];
    
    self.currentPayBtn.hidden = YES;
    self.clockCountDownL.hidden = YES;
    self.clockL.hidden = YES;
    self.clockImgV.hidden = YES;
    self.lineView.hidden = YES;
    
}

-(void)creaetBarrage{
    self.bulletManager = [[BulletManager alloc] init];
    self.bulletManager.allComments = @[@" "].mutableCopy;
    __weak LSJTopView *myself = self;
    self.bulletManager.generateBulletBlock = ^(BulletView *bulletView) {
        [myself addBulletView:bulletView];
    };
}

- (void)addBulletView:(BulletView *)bulletView {
    bulletView.frame = CGRectMake(CGRectGetWidth(self.frame)+50, 20 + 34 * bulletView.trajectory, CGRectGetWidth(bulletView.bounds), CGRectGetHeight(bulletView.bounds));
    [self.bulletBgView addSubview:bulletView];
    [bulletView startAnimation];
}

//返回
- (void)back{
    if ([self.delegate respondsToSelector:@selector(dealWithTopViewBy:button:)]) {
        [self.delegate dealWithTopViewBy:TopViewBack button:nil];
    }
}

//音乐
- (void)musicSwitch:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.musicNoImgV.hidden = NO;
    }else{
        self.musicNoImgV.hidden = YES;
    }
    if ([self.delegate respondsToSelector:@selector(dealWithTopViewBy:button:)]) {
        [self.delegate dealWithTopViewBy:TopViewMusic button:sender];
    }
}

//弹幕
- (void)barrageSwitch:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.barrageNoImgV.hidden = NO;
    }else{
        self.barrageNoImgV.hidden = YES;
    }
    if ([self.delegate respondsToSelector:@selector(dealWithTopViewBy:button:)]) {
        [self.delegate dealWithTopViewBy:TopViewBarrage button:sender];
    }
}

-(void)start{
    [self creaetBarrage];
    [self.bulletManager start];
    self.bulletBgView.hidden = NO;
}
-(void)stopScroll{
    [self.bulletManager stop];
    self.bulletBgView.hidden = YES;
}

- (void)recharge:(UITapGestureRecognizer *)tap{
    if ([self.delegate respondsToSelector:@selector(dealWithTopViewBy:button:)]) {
        [self.delegate dealWithTopViewBy:TopViewRecharge button:nil];
    }
}

#pragma mark UICollectionViewDelegate,UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FXOnlineIconCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuserId forIndexPath:indexPath];
    cell.cornerRadius = Px(15);
    cell.layer.masksToBounds = YES;
    cell.backgroundColor = DYGRandomColor;
    WwUser *model = self.dataArray[indexPath.row];
    [cell.iconImgV sd_setImageWithURL:[NSURL URLWithString:model.portrait] placeholderImage:[UIImage imageNamed:@"default_icon"]];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(Px(30),Px(30));
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0,Px(2),0,Px(2));
}

#pragma mark 处理数据
- (void)refreshAudienceWithWwUserNum:(NSInteger)num withModel:(WwRoom *)model{
    [[WawaSDK WawaSDKInstance].roomMgr requestViewerWithRoomId:model.ID page:1 withComplete:^(NSInteger code, NSString *message, NSArray<WwUser *> *userList) {
        if (code == WwCodeSuccess) {
            NSArray *kvArr = [WwUser mj_keyValuesArrayWithObjectArray:userList];
            self.dataArray = [NSMutableArray array];
            if ([kvArr isKindOfClass:[NSArray class]]) {
                self.dataArray = [WwUser mj_objectArrayWithKeyValuesArray:kvArr];
                self.personNumL.text = userList.count < 10 ? [NSString stringWithFormat:@"%zd",userList.count] : [NSString stringWithFormat:@"%zd0+",userList.count/10];
                [self.audienceCollectV reloadData];
            }
        }
    }];
}
- (void)refreGameUserByUser:(WwUser *)user{
    if (user == nil) {
        self.iconImgV.image = [UIImage imageNamed:@"default_icon"];
        self.statusImgV.hidden = NO;
        return;
    }
    [self.iconImgV sd_setImageWithURL:[NSURL URLWithString:user.portrait]];
    self.statusImgV.hidden = YES;
}
- (void)refrshWaWaDetailsWithModel:(WwRoom *)model{
    NSString *coin = [NSString stringWithFormat:@"%zd/次 ",model.wawa.coin];
    [self.perPayBtn setTitle:coin forState:UIControlStateNormal];
    [self.perPayBtn xm_setImagePosition:XMImagePositionLeft titleFont:[UIFont systemFontOfSize:12] spacing:0];
}

- (void)refreshViewWithOrigin:(NSInteger )price Credits:(NSString *)credits time:(NSString *)time{
    
    [self.perPayBtn setTitle:[NSString stringWithFormat:@"原价:%ld/次 ",price] forState:UIControlStateNormal];
    [self.perPayBtn xm_setImagePosition:XMImagePositionLeft titleFont:[UIFont systemFontOfSize:12] spacing:0];
    
    if ([credits integerValue] == price && [time integerValue] != 0) {
        [self.currentPayBtn setTitle:[NSString stringWithFormat:@"原价:%@/次 ",credits] forState:UIControlStateNormal];
        self.perPayBtn.hidden = YES;
        self.lineView.hidden = YES;
        self.clockCountDownL.hidden = NO;
        self.clockL.hidden = NO;
        self.clockImgV.hidden = NO;
        self.countDownTime = [time intValue];
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdown:) userInfo:nil repeats:YES];
    }else{
        [self.currentPayBtn setTitle:[NSString stringWithFormat:@"现价:%@/次 ",credits] forState:UIControlStateNormal];
        self.perPayBtn.hidden = NO;
        self.lineView.hidden = NO;
        self.clockCountDownL.hidden = YES;
        self.clockL.hidden = YES;
        self.clockImgV.hidden = YES;
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
    }
    [self.currentPayBtn xm_setImagePosition:XMImagePositionLeft titleFont:[UIFont systemFontOfSize:12] spacing:0];
}

- (void)countdown:(NSTimer *)timer{
    self.countDownTime --;
    
    if (self.countDownTime <= 0) {
        [self.timer invalidate];
        self.timer = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:KrefreshActiveCountDown object:nil];
        return;
    }
    
    int seconds = self.countDownTime % 60;
    int minutes = (self.countDownTime / 60) % 60;
    int hours = self.countDownTime / 3600;
    
    self.clockCountDownL.text = [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
    
}

- (void)stopCountDownAction{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)refeshClock:(BOOL)isActive{
    if (isActive) {
        self.currentPayBtn.hidden = NO;
        self.clockCountDownL.hidden = NO;
        self.clockL.hidden = NO;
        self.clockImgV.hidden = NO;
        self.lineView.hidden = NO;
    }else{
        self.currentPayBtn.hidden = YES;
        self.clockCountDownL.hidden = YES;
        self.clockL.hidden = YES;
        self.clockImgV.hidden = YES;
        self.lineView.hidden = YES;
    }
}

#pragma mark lazyload
- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"mine_header_back"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}
- (UIImageView *)bgImgV{
    if (!_bgImgV) {
        _bgImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_header_icon"]];
    }
    return _bgImgV;
}
- (UIImageView *)iconImgV{
    if (!_iconImgV) {
        _iconImgV = [[UIImageView alloc] init];
    }
    return _iconImgV;
}
- (UILabel *)countdownL{
    if (!_countdownL) {
        _countdownL = [[UILabel alloc] init];
        _countdownL.backgroundColor = DYGAColor(255, 255, 255, 0.6);
        _countdownL.textAlignment = NSTextAlignmentCenter;
        _countdownL.font = [UIFont fontWithName:@"STYuanti-SC-Bold" size:24];
        _countdownL.textColor = [UIColor whiteColor];
        _countdownL.text = @"24s";
    }
    return _countdownL;
}
- (UIImageView *)statusImgV{
    if (!_statusImgV) {
        _statusImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"game_status"]];
    }
    return _statusImgV;
}
- (UICollectionView *)audienceCollectV{
    if (!_audienceCollectV) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumLineSpacing=Px(4);
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _audienceCollectV = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _audienceCollectV.delegate = self;
        _audienceCollectV.dataSource = self;
        _audienceCollectV.showsVerticalScrollIndicator = NO;
        _audienceCollectV.backgroundColor = [UIColor clearColor];
        [_audienceCollectV registerNib:[UINib nibWithNibName:@"FXOnlineIconCell" bundle:nil] forCellWithReuseIdentifier:reuserId];
        _audienceCollectV.showsHorizontalScrollIndicator = NO;
    }
    return _audienceCollectV;
}
- (UIImageView *)personNumImgV{
    if (!_personNumImgV) {
        _personNumImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"game_audience_num"]];
    }
    return _personNumImgV;
}
- (UILabel *)personNumL{
    if (!_personNumL) {
        _personNumL = [[UILabel alloc] init];
        _personNumL.textAlignment = NSTextAlignmentCenter;
        _personNumL.font = [UIFont fontWithName:@"STYuanti-SC-Bold" size:12];
        _personNumL.textColor = DYGColorFromHex(0x5e4000);
        _personNumL.text = @"0";
    }
    return _personNumL;
}
- (UIView *)zuanshiView{
    if (!_zuanshiView) {
        _zuanshiView = [UIView new];
        _zuanshiView.backgroundColor = [UIColor clearColor];
    }
    return _zuanshiView;
}
- (UIImageView *)zuanshiImgV{
    if (!_zuanshiImgV) {
        _zuanshiImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"game_recharge_zs"]];
    }
    return _zuanshiImgV;
}
- (UIImageView *)zuanshiBgImgV{
    if (!_zuanshiBgImgV) {
        UIImage *image = [UIImage imageNamed:@"game_recharge_bgV"];
        image = [image stretchableImageWithLeftCapWidth:20 topCapHeight:0];
        _zuanshiBgImgV = [[UIImageView alloc] initWithImage:image];
    }
    return _zuanshiBgImgV;
}
- (UIImageView *)rechargeImgV{
    if (!_rechargeImgV) {
        _rechargeImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"game_recharge_add"]];
    }
    return _rechargeImgV;
}
- (UILabel *)zuanshiNumL{
    if (!_zuanshiNumL) {
        _zuanshiNumL = [[UILabel alloc] init];
        _zuanshiNumL.textAlignment = NSTextAlignmentCenter;
        _zuanshiNumL.font = [UIFont fontWithName:@"STYuanti-SC-Bold" size:20];
        _zuanshiNumL.textColor = DYGColorFromHex(0xffffff);
    }
    return _zuanshiNumL;
}

- (UIView *)playView{
    if (!_playView) {
        _playView = [UIView new];
        _playView.backgroundColor = [UIColor orangeColor];
    }
    return _playView;
}
- (UIImageView *)musicImgV{
    if (!_musicImgV) {
        _musicImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"game_music"]];
    }
    return _musicImgV;
}
- (UILabel *)musicL{
    if (!_musicL) {
        _musicL = [[UILabel alloc] init];
        _musicL.text = @"音乐";
        _musicL.font = [UIFont systemFontOfSize:12];
        _musicL.textColor = [UIColor whiteColor];
    }
    return _musicL;
}
- (UIImageView *)barrageImgV{
    if (!_barrageImgV) {
        _barrageImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"game_danmu"]];
    }
    return _barrageImgV;
}
- (UILabel *)barrageL{
    if (!_barrageL) {
        _barrageL = [[UILabel alloc] init];
        _barrageL.text = @"弹幕";
        _barrageL.font = [UIFont systemFontOfSize:12];
        _barrageL.textColor = [UIColor whiteColor];
    }
    return _barrageL;
}
- (UIImageView *)musicNoImgV{
    if (!_musicNoImgV) {
        _musicNoImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"game_play_no"]];
    }
    return _musicNoImgV;
}
- (UIImageView *)barrageNoImgV{
    if (!_barrageNoImgV) {
        _barrageNoImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"game_play_no"]];
    }
    return _barrageNoImgV;
}
-(UIButton *)musicBtn{
    if (!_musicBtn) {
        _musicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _musicBtn.backgroundColor = [UIColor clearColor];
        [_musicBtn addTarget:self action:@selector(musicSwitch:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _musicBtn;
}
-(UIButton *)barrageBtn{
    if (!_barrageBtn) {
        _barrageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _barrageBtn.backgroundColor = [UIColor clearColor];
        [_barrageBtn addTarget:self action:@selector(barrageSwitch:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _barrageBtn;
}

- (UIButton *)perPayBtn{
    if (!_perPayBtn) {
        _perPayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_perPayBtn setImage:[UIImage imageNamed:@"game_recharge_zs"] forState:UIControlStateNormal];
        [_perPayBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        _perPayBtn.backgroundColor = DYGAColor(0, 0, 0, 0.6);
        _perPayBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _perPayBtn;
}

- (UIButton *)currentPayBtn{
    if (!_currentPayBtn) {
        _currentPayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_currentPayBtn setImage:[UIImage imageNamed:@"game_recharge_zs"] forState:UIControlStateNormal];
        [_currentPayBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        _currentPayBtn.backgroundColor = DYGAColor(0, 0, 0, 0.6);
        _currentPayBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_currentPayBtn setTitle:@"现价:23/次" forState:UIControlStateNormal];
    }
    return _currentPayBtn;
}

- (LSJOperationNormalView *)normalView{
    if (!_normalView) {
        _normalView = [[LSJOperationNormalView alloc] init];
    }
    return _normalView;
}

- (BulletBackgroudView *)bulletBgView {
    if (!_bulletBgView) {
        _bulletBgView = [[BulletBackgroudView alloc] init];
        _bulletBgView.backgroundColor = [UIColor clearColor];
        _bulletBgView.clipsToBounds = YES;
        [self addSubview:_bulletBgView];
    }
    return _bulletBgView;
}

// 倒计时
- (UIView *)countDownV {
    if (!_countDownV) {
        _countDownV = [[ZYCountDownView alloc] init];
        _countDownV.backgroundColor = DYGAColor(0, 0, 0, 0.6);
        _countDownV.hidden = YES;
    }
    return _countDownV;
}

- (UIImageView *)clockImgV{
    if (!_clockImgV) {
        _clockImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"game_clock"]];
    }
    return _clockImgV;
}

- (UILabel *)clockL{
    if (!_clockL) {
        _clockL = [[UILabel alloc] init];
        _clockL.text = @"折扣开启时间";
        _clockL.font = [UIFont systemFontOfSize:13];
        _clockL.textColor = [UIColor whiteColor];
    }
    return _clockL;
}

- (UILabel *)clockCountDownL{
    if (!_clockCountDownL) {
        _clockCountDownL = [[UILabel alloc] init];
        _clockCountDownL.text = @"00:00:00";
        _clockCountDownL.font = [UIFont systemFontOfSize:11];
        _clockCountDownL.textColor = [UIColor whiteColor];
        _clockCountDownL.backgroundColor = DYGAColor(0, 0, 0, 0.5);
        _clockCountDownL.textAlignment = NSTextAlignmentCenter;
    }
    return _clockCountDownL;
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = DYGColorFromHex(0xfed811);
    }
    return _lineView;
}
@end
