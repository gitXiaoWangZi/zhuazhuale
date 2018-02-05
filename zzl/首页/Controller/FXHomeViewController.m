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
#import "FXSelfViewController.h"
#import "FXZZLViewController.h"
#import "LSJGameViewController.h"
#import "LSJPersonalTableViewController.h"
#import "ZYSpreadButton.h"
#import "ZYSpreadSubButton.h"
#import "FXNotificationController.h"
#import "FXTaskViewController.h"

#define AppID @"2017112318102887"
#define AppKey @"552b92dc67b646d5b9d1576799545f4c"
@interface FXHomeViewController ()<NewPagedFlowViewDelegate,NewPagedFlowViewDataSource,DYGHeaderImageViewDelegate,DYGMoreBtnClickDelegate,UIGestureRecognizerDelegate,FXHomePopViewDelegate,WwRoomManagerDelegate>

/**
 *  轮播图
 */
@property (nonatomic, strong) NewPagedFlowView *pageFlowView;

@property (nonatomic,strong) DYGHomeHeaderView *header;
@property (nonatomic,strong) NSMutableArray *roomIdsArray;
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
@property (nonatomic,strong) UIImageView *bgImageV;
@property (nonatomic,strong) ZYSpreadButton *spreadBtn;

@end

@implementation FXHomeViewController

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.roomsArray.count == 0) {
        [self loadRoomIDData];
    }
}

#pragma mark 获取用户任务列表
- (void)loadTastListData{
    NSString *path = @"newtask";
    NSDictionary *params = @{@"uid":KUID};
    [DYGHttpTool postWithURL:path params:params sucess:^(id json) {
        NSDictionary *dic = (NSDictionary *)json;
        if ([dic[@"code"] integerValue] == 200) {
            if (self.spreadBtn && [dic[@"red"] integerValue] == 1) {
                [self.spreadBtn setImage:[UIImage imageNamed:@"zhangyu_btn"] highImage:[UIImage imageNamed:@"zhangyu_btn_light"]];
            }else if (self.spreadBtn && [dic[@"red"] integerValue] == 0){
                [self.spreadBtn setImage:[UIImage imageNamed:@"zhangyu_btn_no"] highImage:[UIImage imageNamed:@"zhangyu_btn_light_no"]];
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)loadView{
    [super loadView];
    _bgImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_bg"]];
    _bgImageV.frame = self.view.bounds;
    [self.view addSubview:_bgImageV];
    [self.view sendSubviewToBack:_bgImageV];
    [self loadVersionData];
}

#pragma mark 版本号
- (void)loadVersionData{
    NSString *path = @"getNewIos";
    [DYGHttpTool postWithURL:path params:nil sucess:^(id json) {
        NSDictionary *dic = (NSDictionary *)json;
        if ([dic[@"code"] integerValue] == 200) {
            NSString *saveVersion = [[NSUserDefaults standardUserDefaults] objectForKey:kBundleVersionKey];
            if (![saveVersion isEqualToString:dic[@"data"][@"version"]]) {
                UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:dic[@"data"][@"content"] message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    UIWebView *webV = [[UIWebView alloc] initWithFrame:CGRectZero];
                    NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/cn/app/id1320308247?mt=8"];
                    NSURLRequest *request = [NSURLRequest requestWithURL:url];
                    [webV loadRequest:request];
                    [self.view addSubview:webV];
                }];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"暂不" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    NSLog(@"Cancel Action");
                }];
                [alertVC addAction:okAction];
                [alertVC addAction:cancelAction];
                [self presentViewController:alertVC animated:YES completion:nil];
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)loadRoomIDData{
    self.roomIdsArray = [NSMutableArray array];
    NSString *path = @"getIndexGoodsBanner";
    NSDictionary *params = @{@"uid":KUID};
    [DYGHttpTool postWithURL:path params:params sucess:^(id json) {
        NSDictionary *dic = (NSDictionary *)json;
        if ([dic[@"code"] integerValue] == 200) {
            self.roomPicArray = [FXHomeHouseItem mj_objectArrayWithKeyValuesArray:dic[@"data"]];
            for (FXHomeHouseItem *item in self.roomPicArray) {
                [self.roomIdsArray addObject:item.dicid];
            }
            [self initData];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
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
    [self loadRoomIDData];
    
    [self addbottomView];
    [self addSpreadButton];
}

- (void)addSpreadButton{
    ZYSpreadSubButton *btn0 = [[ZYSpreadSubButton alloc] initWithBackgroundImage:[UIImage imageNamed:@"zy_msg"] highlightImage:[UIImage imageNamed:@"zy_msg_select"] clickedBlock:^(int index, UIButton *sender) {
        NSLog(@"点击消息");
        if (![[VisiteTools shareInstance] isVisite]) {
            FXNotificationController *notiVC = [[FXNotificationController alloc] init];
            [self.navigationController pushViewController:notiVC animated:YES];
        }else{
            [[VisiteTools shareInstance] outLogin];
        }
    }];
    ZYSpreadSubButton *btn1 = [[ZYSpreadSubButton alloc] initWithBackgroundImage:[UIImage imageNamed:@"zy_task"] highlightImage:[UIImage imageNamed:@"zy_task_select"] clickedBlock:^(int index, UIButton *sender) {
        NSLog(@"点击任务");
        if (![[VisiteTools shareInstance] isVisite]) {
            FXTaskViewController *taskVC = [[FXTaskViewController alloc] init];
            [self.navigationController pushViewController:taskVC animated:YES];
        }else{
            [[VisiteTools shareInstance] outLogin];
        }
    }];
    ZYSpreadSubButton *btn2 = [[ZYSpreadSubButton alloc] initWithBackgroundImage:[UIImage imageNamed:@"zy_share"] highlightImage:[UIImage imageNamed:@"zy_share_select"] clickedBlock:^(int index, UIButton *sender) {
        NSLog(@"点击分享");
        if (![[VisiteTools shareInstance] isVisite]) {
            FXHomeBannerItem *item = [FXHomeBannerItem new];
            item.href = @"http://wawa.api.fanx.xin/share";
            item.title = @"邀请好友";
            item.banner_type = @"2";
            FXGameWebController *vc = [[FXGameWebController alloc] init];
            vc.item = item;
            [self.navigationController pushViewController:vc animated:YES];
            
            //充值活动
//            FXHomeBannerItem *item = [FXHomeBannerItem new];
//            item.href = @"http://openapi.wawa.zhuazhuale.xin/zuanshidsf?uid=69";
//            item.title = @"邀请好友";
//            FXGameWebController *vc = [[FXGameWebController alloc] init];
//            vc.item = item;
//            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [[VisiteTools shareInstance] outLogin];
        }
        
    }];
    ZYSpreadSubButton *btn3 = [[ZYSpreadSubButton alloc] initWithBackgroundImage:[UIImage imageNamed:@"zy_otherPay"] highlightImage:[UIImage imageNamed:@"zy_otherPay_select"] clickedBlock:^(int index, UIButton *sender) {
        NSLog(@"代付");
        if (![[VisiteTools shareInstance] isVisite]) {
            FXHomeBannerItem *item = [FXHomeBannerItem new];
            item.href = [NSString stringWithFormat:@"%@?uid=%@",@"http://openapi.wawa.zhuazhuale.xin/zhuli",KUID];
            item.title = @"好友助力";
            FXGameWebController *vc = [[FXGameWebController alloc] init];
            vc.item = item;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [[VisiteTools shareInstance] outLogin];
        }
        
    }];
    ZYSpreadButton *spreadBtn =  [[ZYSpreadButton alloc] initWithBackgroundImage:[UIImage imageNamed:@"zhangyu_btn_no"] highlightImage:[UIImage imageNamed:@"zhangyu_btn_light_no"] position: CGPointMake(kScreenWidth - 40, kScreenHeight - 205)];
    self.spreadBtn = spreadBtn;
    spreadBtn.subButtons = @[btn0,btn1,btn2,btn3];
    spreadBtn.mode = SpreadModeSickleSpread;
    spreadBtn.direction = SpreadDirectionLeft;
    spreadBtn.positionMode = SpreadPositionModeFixed;
    [self.view addSubview:spreadBtn];
}

- (void)addbottomView{
    UIView *bottomV = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 105.5, kScreenWidth, 105.5)];
    bottomV.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bottomV];
    
    UIImageView *bottomImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_base"]];
    bottomImgV.frame = CGRectMake(0, 32.5, kScreenWidth, 73);
    bottomImgV.userInteractionEnabled = YES;
    [bottomV addSubview:bottomImgV];
    
    UIButton *listBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    listBtn.frame = CGRectMake(20, 26.5, 92.5, 74);
    [listBtn setBackgroundImage:[UIImage imageNamed:@"home_list"] forState:UIControlStateNormal];
    [listBtn setBackgroundImage:[UIImage imageNamed:@"home_list_select"] forState:UIControlStateHighlighted];
    [listBtn addTarget:self action:@selector(listAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomV addSubview:listBtn];
    
    UIButton *captureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    captureBtn.frame = CGRectMake(0, 5, 120, 95.5);
    captureBtn.centerX = bottomImgV.centerX;
    [captureBtn setBackgroundImage:[UIImage imageNamed:@"home_ capture"] forState:UIControlStateNormal];
    [captureBtn setBackgroundImage:[UIImage imageNamed:@"home_ capture_select"] forState:UIControlStateHighlighted];
    [captureBtn addTarget:self action:@selector(captureAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomV addSubview:captureBtn];
    
    UIButton *personalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    personalBtn.frame = CGRectMake(kScreenWidth-112.5, 26.5, 92.5, 74);
    [personalBtn setBackgroundImage:[UIImage imageNamed:@"home_personal"] forState:UIControlStateNormal];
    [personalBtn setBackgroundImage:[UIImage imageNamed:@"home_personal_select"] forState:UIControlStateHighlighted];
    [personalBtn addTarget:self action:@selector(personalAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomV addSubview:personalBtn];
}

- (void)personalAction:(UIButton *)sender{
    if (![[VisiteTools shareInstance] isVisite]) {
        LSJPersonalTableViewController *mineVC = [[LSJPersonalTableViewController alloc] init];
        [self.navigationController pushViewController:mineVC animated:YES];
    }else{
        [[VisiteTools shareInstance] outLogin];
    }
}

- (void)captureAction:(UIButton *)sender{
    if (![[VisiteTools shareInstance] isVisite]) {
        [LSJHasNetwork lsj_hasNetwork:^(bool hasNet) {
            if (hasNet) {
                if (![[VisiteTools shareInstance] isVisite]) {
                    [self jumpRooms];
                }else{
                    [[VisiteTools shareInstance] outLogin];
                }
            }else{
                [MBProgressHUD showMessage:@"暂无网络，请连接网络后再试" toView:self.view];
            }
        }];
    }else{
        [[VisiteTools shareInstance] outLogin];
    }
}

- (void)jumpRooms{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"查找房间中……";
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        [[WwRoomManager RoomMgrInstance] requestQuickStartWithComplete:^(NSInteger code, NSString *msg, WwRoom *room) {
            if (room == nil) {
                [MBProgressHUD showError:@"没有房间可以进入" toView:[UIApplication sharedApplication].keyWindow];
            }else{
//                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kQuitEnter"];
                LSJGameViewController *game = [[LSJGameViewController alloc] init];
                game.model = room;
                [self.navigationController pushViewController:game animated:YES];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
            });
        }];
        
    });
}

- (void)listAction:(UIButton *)sender{
    if (![[VisiteTools shareInstance] isVisite]) {
        FXZZLViewController *moreVC = [[FXZZLViewController alloc] init];
        [self.navigationController pushViewController:moreVC animated:YES];
    }else{
        [[VisiteTools shareInstance] outLogin];
    }
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
    [self.header beginScroll];
    [self.header starTimer];
    [self loadTastListData];
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.header.timer invalidate];
    self.header.timer = nil;
    [self.header stopScroll];
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
    [[WawaSDK WawaSDKInstance].userInfoMgr loginWithComplete:^(int code, NSString *message) {
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
        _header.frame = CGRectMake(12, 28, kScreenWidth - 24,Py(142));
        _header.delegate =self;
    }
    return _header;
}

#pragma mark ---请求最近抓中记录数据
- (void)loadLatesRecordDataWithRoomID:(NSInteger)ID{
    [[WwRoomManager RoomMgrInstance] requestCatchHistory:ID atPage:1 withComplete:^(NSInteger code, NSString *message, NSArray<WwRoomCatchRecordItem *> *list) {
        NSMutableArray *tempArr = [NSMutableArray array];
        for (WwRoomCatchRecordItem *info in list) {
            NSDictionary *tempDic = @{@"username":info.user.nickname};
            [tempArr addObject:tempDic];
        }
        self.header.scrollAdArr = tempArr;
    }];
}

- (void)setupUI {
    NewPagedFlowView *pageFlowView = [[NewPagedFlowView alloc] initWithFrame:CGRectMake(0, kScreenHeight - Py(478), kScreenWidth, Py(380))];
    pageFlowView.delegate = self;
    pageFlowView.dataSource = self;
    pageFlowView.minimumPageAlpha = 0.1;
    pageFlowView.isCarousel = NO;
    pageFlowView.orientation = NewPagedFlowViewOrientationHorizontal;
    pageFlowView.isOpenAutoScroll = YES;
    pageFlowView.leftRightMargin = Px(15);
    [self.view addSubview:pageFlowView];
    [pageFlowView reloadData];
    self.pageFlowView = pageFlowView;
    if (self.roomPicArray.count>1) {
        [pageFlowView scrollToPage:1];
    }
    pageFlowView.clipsToBounds = NO;
    [self.view insertSubview:pageFlowView aboveSubview:_bgImageV];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
#pragma mark 加载数据
-(void)loadRoomList {
    
    [[WwRoomManager RoomMgrInstance] requestRoomListByIds:self.roomIdsArray withComplete:^(NSInteger code, NSString *message, NSArray<WwRoom *> *list) {
        [_hud hideAnimated:YES];
        self.defaultImageV.hidden = YES;
        
        [[WwRoomManager RoomMgrInstance] setDelegate:self];
        [self.roomsArray removeAllObjects];
        if (code == 0) {
            // 成功
            self.roomsArray = [WwRoom mj_objectArrayWithKeyValuesArray:list];
            
            WwRoom *model = list[0];
            [self loadLatesRecordDataWithRoomID:model.ID];
            [self setupUI];
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
- (void)onRoomListChange:(NSArray <WwRoom *> *)roomList{
    [self.roomsArray removeAllObjects];
    [self.roomPicArray removeAllObjects];
    self.roomsArray = [WwRoom mj_objectArrayWithKeyValuesArray:roomList];
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
    NSString *path = @"getIndexnewBanner";
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
        
        LSJGameViewController *game = [[LSJGameViewController alloc] init];
        game.model = self.roomsArray[subIndex];
        [self.navigationController pushViewController:game animated:YES];
        
//        FXGameWaitController * vc = [[FXGameWaitController alloc]init];
//        vc.model = self.roomsArray[subIndex];
//        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [[VisiteTools shareInstance] outLogin];
    }
}

#pragma mark NewPagedFlowView Datasource
- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
    return self.roomsArray.count;
}

- (UIView *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    PGIndexBannerSubiew *bannerView = (PGIndexBannerSubiew *)[flowView dequeueReusableCell];
    WwRoom *model = self.roomsArray[index];
    if (!bannerView) {
        bannerView = [[PGIndexBannerSubiew alloc] initWithFrame:CGRectMake(0, 0, Px(233), Py(360))];
        bannerView.layer.cornerRadius = 15;
        bannerView.layer.masksToBounds = YES;
        bannerView.delegate = self;
        bannerView.model = model;
    }
    for (FXHomeHouseItem *item in self.roomPicArray) {
        if ([item.dicid isEqualToString:[NSString stringWithFormat:@"%zd",model.ID]]) {
            [bannerView.mainImageView sd_setImageWithURL:[NSURL URLWithString:item.img_path] placeholderImage:[UIImage imageNamed:@"鱿鱼"]];
        }
    }
    return bannerView;
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView {
    
    NSLog(@"TestViewController 滚动到了第%ld页",pageNumber);
}
- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView {
    return CGSizeMake(Px(298), Py(408));
}

#pragma self Delegate
-(void)loadWebViewWithImgIndex:(NSInteger)index{
    if (![[VisiteTools shareInstance] isVisite]) {
        [MobClick event:@"main_banner_clieck"];
        FXHomeBannerItem *item = self.bannerArray[index];
        FXGameWebController *webVC = [[FXGameWebController alloc] init];
        webVC.item = item;
        [self.navigationController pushViewController:webVC animated:YES];
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
            self.loginPopView = [[[NSBundle mainBundle] loadNibNamed:@"FXHomeLoginSuccessPopView" owner:nil options:nil] firstObject];
            self.loginPopView.frame = self.view.bounds;
            self.loginPopView.day = day;
            self.loginPopView.money = [dic[@"data"][@"money"] stringValue];
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
