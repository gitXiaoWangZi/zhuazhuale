//
//  FXHomeViewController.m
//  zzl
//
//  Created by Mr_Du on 2017/10/30.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "FXHomeViewController.h"
#import "PGIndexBannerSubiew.h"
#import "NewPagedFlowView.h"
#import "DYGHomeHeaderView.h"
#import "FXZZLViewController.h"
#import "FXGameWaitController.h"
#import "FXHomeBannerItem.h"
#import "FXHomePopView.h"
#import "FXGameWebController.h"
#import "FXHomeHouseItem.h"
#import "FXHomeSignPopView.h"//连续登录签到页面
#import "FXHomeLoginSuccessPopView.h" //登录成功页面
#import "LSJHasNetwork.h"

#define AppID @"2017112318102887"
#define AppKey @"552b92dc67b646d5b9d1576799545f4c"
@interface FXHomeViewController ()<NewPagedFlowViewDelegate,NewPagedFlowViewDataSource,DYGHeaderImageViewDelegate,DYGMoreBtnClickDelegate,UIGestureRecognizerDelegate,FXHomePopViewDelegate,WwRoomListManagerDelegate>

/**
 *  轮播图
 */
@property (nonatomic, strong) NewPagedFlowView *pageFlowView;

@property (nonatomic,strong) DYGHomeHeaderView *header;

/**
 * 房间模型数组
 */
@property (nonatomic,strong) NSMutableArray *roomsArray;

@property (nonatomic,strong) NSArray *bannerArray;
@property (nonatomic,strong) NSMutableArray *roomPicArray;
@property (nonatomic, assign) BOOL passValidity;
@property (nonatomic,strong) FXHomePopView *popView;
@property (nonatomic,strong) FXHomeSignPopView *signPopView;//7天连续登录页面
@property (nonatomic,strong) FXHomeLoginSuccessPopView *loginPopView;//登录成功页面
@property (nonatomic,strong) MBProgressHUD *hud;
@property (nonatomic,strong) UIImageView *defaultImageV;

@end

@implementation FXHomeViewController

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.roomsArray.count == 0) {
        [self initData];
    }
}

#pragma  Controller Life
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdkPassValidity) name:kSDKNotifyKey object:nil];
    self.defaultImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_noInter_default"]];
    self.defaultImageV.contentMode = UIViewContentModeCenter;
    [self.view addSubview:self.defaultImageV];
    [self.defaultImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view);
    }];
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.view.backgroundColor = BGColor;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    [self.view addSubview:self.header];
    [self initData];
    
}

- (void)initData{
    
    [LSJHasNetwork lsj_hasNetwork:^(bool has) {
        if (has) {//有网
            [self loadBannerData];
            
            //请求签到天数数据
            [self loadSignDayNumData];
        }else{//没网
            [MBProgressHUD showMessage:@"请检查网络" toView:self.view];
            return ;
        }
    }];

    
    NSDictionary *wawaUserDic = (NSDictionary *)[[NSUserDefaults standardUserDefaults] objectForKey:@"KWAWAUSER"];
    [WwUserInfoManager UserInfoMgrInstance].userInfo = ^UserInfo *{
        UserInfo * user = [UserInfo new];
        user.uid = wawaUserDic[@"ID"];// 接入方用户ID
        user.name = wawaUserDic[@"name"];// 接入方用户昵称
        user.avatar = wawaUserDic[@"img"]; // 接入方
        return user;
    };
    
    [self sdkPassValidity];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.header starTimer];
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.header.timer invalidate];
    self.header.timer = nil;
    [self.header beginScroll];
}

#pragma mark - Public
- (void)sdkPassValidity
{
    self.passValidity = YES;
    //may be you can login
    [self loginUser];
}

- (void)loginUser
{
    if (self.passValidity == NO) {
        [_hud hideAnimated:YES];
        return;
    }
    
    
    //必须等到鉴权成功之后调用
    [[WawaSDK WawaSDKInstance].userInfoMgr loginUserWithCompleteHandler:^(int code, NSString *message) {
        NSLog(@"%@,%zd",message,code);
        if (code != 0) {
            [_hud hideAnimated:YES];
        }else{
        }
    }];
    
    [self loadRoomList];
}

- (DYGHomeHeaderView *)header{
    if (!_header) {
        _header = [[DYGHomeHeaderView alloc]init];
        _header.frame = CGRectMake(0, -20, kScreenWidth,Py(200));
        _header.delegate =self;
    }
    return _header;
}

#pragma mark ---请求最近抓中记录数据
- (void)loadLatesRecordDataWithRoomID:(NSInteger)ID{
    [[WwGameManager GameMgrInstance] requestLatestRecordInRoom:ID atPage:1 complete:^(BOOL success, NSInteger code, NSArray<WwRoomRecordInfo *> *list) {
        NSMutableArray *tempArr = [NSMutableArray array];
        for (WwRoomRecordInfo *info in list) {
            NSDictionary *tempDic = @{@"username":info.user.nickname};
            [tempArr addObject:tempDic];
        }
        self.header.scrollAdArr = tempArr;
    }];
}

- (void)setupUI {
    NewPagedFlowView *pageFlowView = [[NewPagedFlowView alloc] initWithFrame:CGRectMake(0, Py(184), kScreenWidth, Py(380))];
    pageFlowView.backgroundColor = [UIColor whiteColor];
    pageFlowView.delegate = self;
    pageFlowView.dataSource = self;
    pageFlowView.minimumPageAlpha = 0.1;
    pageFlowView.isCarousel = NO;
    pageFlowView.orientation = NewPagedFlowViewOrientationHorizontal;
    pageFlowView.isOpenAutoScroll = YES;
    pageFlowView.backgroundColor = BGColor;
    pageFlowView.leftRightMargin = Px(25);
    [self.view addSubview:pageFlowView];
    [pageFlowView reloadData];
    self.pageFlowView = pageFlowView;
    if (self.roomPicArray.count>1) {
        [pageFlowView scrollToPage:1];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
#pragma mark 加载数据
-(void)loadRoomList {
    [[WwRoomListManager RoomListMgrInstance] requestRoomListByIds:@[@"270",@"300",@"269",@"239",@"263"] withCompleteHandler:^(int code, NSString *message, NSArray<WwRoomModel *> *list) {
        [_hud hideAnimated:YES];
        self.defaultImageV.hidden = YES;
        
        [[WwRoomListManager RoomListMgrInstance] setDelegate:self];
        [self.roomsArray removeAllObjects];
        if (code == 0) {
            // 成功
            self.roomsArray = [WwRoomModel mj_objectArrayWithKeyValuesArray:list];
            
            WwRoomModel *model = list[0];
            [self loadLatesRecordDataWithRoomID:model.ID];
            NSString *path = @"getGoodsBanner";
            NSDictionary *params = @{@"uid":KUID};
            [DYGHttpTool postWithURL:path params:params sucess:^(id json) {
                NSDictionary *dic = (NSDictionary *)json;
                if ([dic[@"code"] integerValue] == 200) {
                    self.roomPicArray = [FXHomeHouseItem mj_objectArrayWithKeyValuesArray:dic[@"data"]];

                    [self setupUI];
                }
            } failure:^(NSError *error) {
                NSLog(@"%@",error);
            }];
            DYGLog(@"查找房间成功");
        }
        else {
            [_hud hideAnimated:YES];
            // 失败
            DYGLog(@"查找房间失败---%@",message);
        }
    }];
    
}

/**
 * 通知接入方客户端，当前房间列表首页数据有变化(主要是房间状态)
 */
- (void)onRoomListChange:(NSArray <WwRoomModel *> *)roomList{
    [self.roomsArray removeAllObjects];
    [self.roomPicArray removeAllObjects];
    self.roomsArray = [WwRoomModel mj_objectArrayWithKeyValuesArray:roomList];
    NSString *path = @"getGoodsBanner";
    NSDictionary *params = @{@"uid":KUID};
    [DYGHttpTool postWithURL:path params:params sucess:^(id json) {
        NSDictionary *dic = (NSDictionary *)json;
        if ([dic[@"code"] integerValue] == 200) {
            self.roomPicArray = [FXHomeHouseItem mj_objectArrayWithKeyValuesArray:dic[@"data"]];
            [_pageFlowView reloadData];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
      
#pragma mark 请求banner图数据
- (void)loadBannerData{
    NSString *path = @"getIndexBanner";
    NSDictionary *params = @{@"uid":KUID,@"index":@(1),@"num":@(20)};
    [DYGHttpTool postWithURL:path params:params sucess:^(id json) {
        NSDictionary *dic = (NSDictionary *)json;
        if ([dic[@"code"] integerValue] == 200) {
            self.bannerArray = [FXHomeBannerItem mj_objectArrayWithKeyValuesArray:dic[@"data"]];
            
            NSMutableArray *temparr = [NSMutableArray array];
            //将banner图片url添加到数组中
            for (FXHomeBannerItem *item in self.bannerArray) {
                [temparr addObject:item.img_path];
            }
            self.header.adArray = temparr;
        }
    } failure:^(NSError *error) {
        NSLog(@"请求banner图数据错误：%@",error);
    }];
}

#pragma mark NewPagedFlowView Delegate
- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
    if (![[VisiteTools shareInstance] isVisite]) {
        [MobClick event:@"home_page_click"];
        FXGameWaitController * vc = [[FXGameWaitController alloc]init];
        vc.model = self.roomsArray[subIndex];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [[VisiteTools shareInstance] outLogin];
    }
}

#pragma mark NewPagedFlowView Datasource
- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
    if (self.roomsArray.count >= 5) {
        return 5;
    }else{
        return self.roomsArray.count;
    }
}

- (UIView *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    PGIndexBannerSubiew *bannerView = (PGIndexBannerSubiew *)[flowView dequeueReusableCell];
    WwRoomModel *model = self.roomsArray[index];
    if (!bannerView) {
        bannerView = [[PGIndexBannerSubiew alloc] initWithFrame:CGRectMake(0, 0, Px(233), Py(360))];
        bannerView.layer.cornerRadius = 4;
        bannerView.layer.masksToBounds = YES;
        bannerView.delegate = self;
        bannerView.model = model;
    }
    for (FXHomeHouseItem *item in self.roomPicArray) {
        
        if ([item.dicid isEqualToString:[NSString stringWithFormat:@"%zd",model.ID]]) {
            [bannerView.mainImageView sd_setImageWithURL:[NSURL URLWithString:item.img_path] placeholderImage:[UIImage imageNamed:@"鱿鱼"]];
            bannerView.currentScore = [item.level floatValue];
        }
    }
    return bannerView;
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView {
    
    NSLog(@"TestViewController 滚动到了第%ld页",pageNumber);
}
- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView {
    return CGSizeMake(Px(233), Py(360));
}

#pragma self Delegate
-(void)loadWebViewWithImgIndex:(NSInteger)index{
    if (![[VisiteTools shareInstance] isVisite]) {
        [MobClick event:@"main_banner_clieck"];
        FXHomeBannerItem *item = self.bannerArray[index];
        FXGameWebController *webVC = [[FXGameWebController alloc] init];
        webVC.url = item.href;
        webVC.titleName = item.title;
        [self.navigationController pushViewController:webVC animated:YES];
    }else{
        [[VisiteTools shareInstance] outLogin];
    }
    
}

-(void)moreBtnDidClick{
    if (![[VisiteTools shareInstance] isVisite]) {
        [MobClick event:@"more_btn_clieck"];
        FXZZLViewController * vc = [[FXZZLViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [[VisiteTools shareInstance] outLogin];
    }
}

#pragma mark FXHomePopViewDelegate 第一注册App进入首页送钻石view
- (void)dimiss{
    [self.popView removeFromSuperview];
}
- (void)gameNow{
    //进入游戏
}

#pragma mark 一些弹出视图
//第一次注册登录进来送钻石的页面
- (void)showRegisterView{
    self.popView = [[FXHomePopView alloc] initWithFrame:self.view.bounds];
    self.popView.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.4];
    self.popView.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:self.popView];
}
//每天连续登录签到的页面
- (void)showLoginSignViewWithDic:(NSDictionary *)dic{
    self.signPopView = [[[NSBundle mainBundle] loadNibNamed:@"FXHomeSignPopView" owner:self options:nil] firstObject];
    self.signPopView.frame = self.view.bounds;
    self.signPopView.dataDic = dic;
    __weak typeof(self) weakSelf = self;
    self.signPopView.signActionBlock = ^(NSString *day){
        [weakSelf loadGetSignDataWithDay:day];
    };
    [[UIApplication sharedApplication].keyWindow addSubview:self.signPopView];
}

#pragma mark 签到天数
- (void)loadSignDayNumData{
    NSString *path = @"getSignDays";
    NSDictionary *params = @{@"uid":KUID};
    [DYGHttpTool postWithURL:path params:params sucess:^(id json) {
        NSDictionary *dic = (NSDictionary *)json;
        if ([dic[@"code"] integerValue] == 200) {
            if ([dic[@"today"] integerValue] == 0) {//未签到
                
                if (![[VisiteTools shareInstance] isVisite]) {
                    [self showLoginSignViewWithDic:dic];
                }
            }else{//已签到
                NSLog(@"已签到");
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark 点击签到
- (void)loadGetSignDataWithDay:(NSString *)day{
    NSString *path = @"getSign";
    NSDictionary *params = @{@"uid":KUID};
    [DYGHttpTool postWithURL:path params:params sucess:^(id json) {
        NSDictionary *dic = (NSDictionary *)json;
        if ([dic[@"code"] integerValue] == 200) {
            [self.signPopView removeFromSuperview];
            self.loginPopView = [[[NSBundle mainBundle] loadNibNamed:@"FXHomeLoginSuccessPopView" owner:self options:nil] firstObject];
            self.loginPopView.frame = self.view.bounds;
            self.loginPopView.day = day;
            self.loginPopView.money = dic[@"data"][@"money"];
            [[UIApplication sharedApplication].keyWindow addSubview:self.loginPopView];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark --懒加载

- (NSMutableArray *)roomPicArray{
    if (!_roomPicArray) {
        _roomPicArray = [NSMutableArray array];
    }
    return _roomPicArray;
}
- (NSMutableArray *)roomsArray{
    if (_roomsArray == nil) {
        _roomsArray = [NSMutableArray array];
    }
    return _roomsArray;
}

- (NSArray *)bannerArray{
    if (!_bannerArray) {
        _bannerArray = [NSArray array];
    }
    return _bannerArray;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
