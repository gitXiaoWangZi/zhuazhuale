//
//  LSJSpoilsController.m
//  zzl
//
//  Created by Mr_Du on 2018/1/18.
//  Copyright © 2018年 Mr.Du. All rights reserved.
//

#import "LSJSpoilsController.h"
#import "LSJWaWaDepositController.h"
#import "LSJWaWaDeliverController.h"
#import "LSJWaWaExchangeController.h"
#import "UIButton+Position.h"
#import "FXOrdingListViewController.h"
#import "LSJLogisticsPopView.h"
#define  btnW kScreenWidth/3

@interface LSJSpoilsController ()<UIScrollViewDelegate,LSJLogisticsPopViewDelegate>

@property (nonatomic,strong) LSJWaWaDepositController *depositVC;
@property (nonatomic,strong) LSJWaWaDeliverController *deliverVC;
@property (nonatomic,strong) LSJWaWaExchangeController *exchangeVC;

@property (nonatomic,strong) UIScrollView *bgScrollV;
@property(nonatomic,strong)NSArray * btnTitleArr;
@property (nonatomic,strong) UIView *topView;
@property (nonatomic,strong) UIView *lineView;
@property(nonatomic,strong) UIButton * tempBtn;

@property (nonatomic,strong) UIView *orderView;
@property (nonatomic,strong) UIButton *selectBtn;
@property (nonatomic,strong) UIButton *applySendBtn;
@property (nonatomic,strong) UIButton *applyExchangeBtn;

@property (nonatomic,strong) LSJLogisticsPopView *popV;

@end

@implementation LSJSpoilsController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.selectBtn.selected = NO;
    [self.depositVC.selectArray removeAllObjects];
    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshBottom:) name:@"KClickCell" object:nil];[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpLogisticsVC:) name:@"jumpLogisticsVC" object:nil];
    
    self.title =@"我的娃娃";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.btnTitleArr = @[@"寄存中",@"已发货",@"已兑换"];
    [self creatTopViewWithArr:self.btnTitleArr];
    [self.view addSubview:self.bgScrollV];
    [self addChildViewController:self.depositVC];
    [self addChildViewController:self.deliverVC];
    [self addChildViewController:self.exchangeVC];
    self.depositVC.view.frame = CGRectMake(0, 0, kScreenWidth, self.bgScrollV.height-Py(50));
    self.deliverVC.view.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, self.bgScrollV.height);
    self.exchangeVC.view.frame = CGRectMake(kScreenWidth*2, 0, kScreenWidth, self.bgScrollV.height);
    [self.bgScrollV addSubview:self.depositVC.view];
    [self.bgScrollV addSubview:self.deliverVC.view];
    [self.bgScrollV addSubview:self.exchangeVC.view];
    
    [self addBottomView];
}

- (void)refreshBottom:(NSNotification *)noti{
    NSDictionary *dic = (NSDictionary *)noti.object;
    if ([dic[@"select"] isEqualToString:@"yes"]) {
        self.selectBtn.selected = YES;
    }else{
        self.selectBtn.selected = NO;
    }
}

- (void)addBottomView{
    [self.view addSubview:self.orderView];
    [self.orderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.equalTo(@(Py(50)));
    }];
    
    [self.orderView addSubview:self.selectBtn];
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orderView).offset(Px(20));
        make.centerY.equalTo(self.orderView);
        make.width.equalTo(@(Px(62)));
        make.height.equalTo(@(Py(30)));
    }];
    
    [self.orderView addSubview:self.applySendBtn];
    [self.applySendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.orderView.mas_right).offset(Px(-15));
        make.centerY.equalTo(self.orderView);
        make.size.mas_equalTo(CGSizeMake(Px(80), Py(30)));
    }];
    _applySendBtn.layer.cornerRadius = Py(15);
    _applySendBtn.layer.masksToBounds = YES;
    
    [self.orderView addSubview:self.applyExchangeBtn];
    [self.applyExchangeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.applySendBtn.mas_left).offset(Px(-7));
        make.centerY.equalTo(self.applySendBtn);
        make.size.mas_equalTo(CGSizeMake(Px(80), Py(30)));
    }];
    _applyExchangeBtn.layer.cornerRadius = Py(15);
    _applyExchangeBtn.layer.masksToBounds = YES;
    
}

-(void)creatTopViewWithArr:(NSArray *)arr{
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, Py(40))];
    for (int i = 0; i<arr.count; i++) {
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(btnW*i,0, btnW,self.topView.height)];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [btn setTitleColor:DYGColorFromHex(0xd9b600) forState:UIControlStateSelected];
        [btn setTitleColor:DYGColorFromHex(0x4d4d4d) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        btn.tag = 10+i;
        [btn addTarget:self action:@selector(btnClickToScroll:) forControlEvents:UIControlEventTouchUpInside];
        [self.topView addSubview:btn];
    }
    self.topView.borderColor = BGColor;
    self.topView.borderWidth =1;
    self.topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.topView];
    self.lineView.frame = CGRectMake((btnW - Px(60))/2.0, CGRectGetMaxY(self.topView.frame)-2, Px(60), 2);
    [self.view addSubview:self.lineView];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int i = (scrollView.contentOffset.x+ kScreenWidth * 0.5)/kScreenWidth;
    [UIView animateWithDuration:0.25 animations:^{
        self.lineView.frame = CGRectMake((btnW - Px(60))/2.0+btnW*i, self.lineView.y, self.lineView.width, self.lineView.height);
    }];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.tempBtn.selected = NO;
    int i = (scrollView.contentOffset.x+ kScreenWidth * 0.5)/kScreenWidth;
    UIButton *myButton1 = (UIButton *)[self.view viewWithTag:10+i];
    myButton1.selected = YES;
    self.tempBtn = myButton1;
    if (self.tempBtn.tag==myButton1.tag) {
        
    }else{
        self.tempBtn.selected = NO;
        myButton1.selected = !myButton1.selected;
        self.tempBtn = myButton1;
    }
    if (self.tempBtn.tag == 10) {
        self.orderView.hidden = NO;
    }else{
        self.orderView.hidden = YES;
    }
}
-(void)btnClickToScroll:(UIButton *)btn{
    if (self.tempBtn.tag==btn.tag) {
        
    }else{
        self.tempBtn.selected = NO;
        btn.selected = !btn.selected;
        self.tempBtn = btn;
        [self.bgScrollV setContentOffset:CGPointMake((btn.tag-10)*kScreenWidth, 0) animated:YES];
    }
    if (btn.tag == 10) {
        self.orderView.hidden = NO;
    }else{
        self.orderView.hidden = YES;
    }
}

- (void)jumpLogisticsVC:(NSNotification *)noti{
    
    WwExpressInfo *model = (WwExpressInfo *)noti.object;
    [[UIApplication sharedApplication].keyWindow addSubview:self.popV];
    self.popV.model = model;
    [UIView animateWithDuration:0.3 animations:^{
        self.popV.frame = [UIScreen mainScreen].bounds;
        self.popV.backgroundColor = DYGAColor(0, 0, 0, 0.4);
    }];
}

#pragma mark LSJLogisticsPopViewDelegate
- (void)dismissAction{
    self.popV.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.3 animations:^{
        self.popV.frame = CGRectMake(0, kScreenHeight, kScreenWidth, Py(598.5));
    }];
}

#pragma mark lazyload
- (LSJLogisticsPopView *)popV{
    if (!_popV) {
        _popV = [[LSJLogisticsPopView alloc] initWithFrame:CGRectMake(0, Py(598.5), kScreenWidth, kScreenHeight)];
        _popV.backgroundColor = [UIColor clearColor];
        _popV.delegate = self;
    }
    return _popV;
}

- (LSJWaWaDepositController *)depositVC{
    if (!_depositVC) {
        _depositVC = [[LSJWaWaDepositController alloc] initWithStyle:UITableViewStylePlain];
    }
    return _depositVC;
}
- (LSJWaWaDeliverController *)deliverVC{
    if (!_deliverVC) {
        _deliverVC = [[LSJWaWaDeliverController alloc] initWithStyle:UITableViewStylePlain];
    }
    return _deliverVC;
}
- (LSJWaWaExchangeController *)exchangeVC{
    if (!_exchangeVC) {
        _exchangeVC = [[LSJWaWaExchangeController alloc] initWithStyle:UITableViewStylePlain];
    }
    return _exchangeVC;
}

- (UIScrollView *)bgScrollV {
    if (!_bgScrollV) {
        _bgScrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame), kScreenWidth,self.view.height-self.lineView.y-Py(64))];
        _bgScrollV.delegate = self;
        _bgScrollV.backgroundColor = [UIColor whiteColor];
        _bgScrollV.contentSize = CGSizeMake(kScreenWidth * 3, self.view.height-self.lineView.y-Py(64));
        _bgScrollV.pagingEnabled = YES;
        _bgScrollV.bounces = NO;
        _bgScrollV.showsVerticalScrollIndicator = NO;
        _bgScrollV.showsHorizontalScrollIndicator = NO;
    }
    return _bgScrollV;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = systemColor;
    }
    return _lineView;
}

- (UIView *)orderView{
    if (!_orderView) {
        _orderView = [[UIView alloc] init];
        _orderView.backgroundColor = [UIColor whiteColor];
    }
    return _orderView;
}

- (UIButton *)selectBtn{
    if (!_selectBtn) {
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectBtn setImage:[UIImage imageNamed:@"address_normal"] forState:UIControlStateNormal];
        [_selectBtn setImage:[UIImage imageNamed:@"address_selected"] forState:UIControlStateSelected];
        [_selectBtn setTitle:@"全选" forState:UIControlStateNormal];
        _selectBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_selectBtn setTitleColor:DYGColorFromHex(0x4d4d4d) forState:UIControlStateNormal];
        [_selectBtn addTarget:self action:@selector(allSelectAction:) forControlEvents:UIControlEventTouchUpInside];
        [_selectBtn xm_setImagePosition:XMImagePositionLeft titleFont:[UIFont systemFontOfSize:12] spacing:6];
    }
    return _selectBtn;
}

- (UIButton *)applySendBtn{
    if (!_applySendBtn) {
        _applySendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_applySendBtn setTitle:@"申请发货" forState:UIControlStateNormal];
        [_applySendBtn setTitleColor:DYGColorFromHex(0xd9b600) forState:UIControlStateNormal];
        _applySendBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _applySendBtn.layer.borderColor = DYGColorFromHex(0xd9b600).CGColor;
        _applySendBtn.layer.borderWidth = 0.5f;
        [_applySendBtn addTarget:self action:@selector(applaySendAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _applySendBtn;
}

- (UIButton *)applyExchangeBtn{
    if (!_applyExchangeBtn) {
        _applyExchangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_applyExchangeBtn setTitle:@"申请兑换" forState:UIControlStateNormal];
        [_applyExchangeBtn setTitleColor:DYGColorFromHex(0x4cbaff) forState:UIControlStateNormal];
        _applyExchangeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _applyExchangeBtn.layer.borderColor = DYGColorFromHex(0x4cbaff).CGColor;
        _applyExchangeBtn.layer.borderWidth = 0.5f;
        [_applyExchangeBtn addTarget:self action:@selector(applyExchangeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _applyExchangeBtn;
}

#pragma mark 请求战利品数据
- (void)loadData{
    [[WwUserInfoManager UserInfoMgrInstance] requestMyWawaList:WawaList_All completeHandler:^(int code, NSString *message, WwUserWawaModel *model) {
        self.depositVC.dataArray = model.depositList;
        self.deliverVC.dataArray = model.expressList;
        self.exchangeVC.dataArray = model.exchangeList;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kREFRESHTABLE" object:nil];
    }];
}

//全选按钮
- (void)allSelectAction:(UIButton *)sender{
    self.selectBtn.selected = !self.selectBtn.selected;
    NSString *isAllSelect = nil;
    if (self.selectBtn.selected) {
        isAllSelect = @"YES";
    }else{
        isAllSelect = @"NO";
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ORDERSELECT" object:@{@"isAllSelect":isAllSelect}];
}

//申请发货按钮
- (void)applaySendAction:(UIButton *)sender{
    if (self.depositVC.selectArray.count != 0) {
        FXOrdingListViewController *listVC = [[FXOrdingListViewController alloc] initWithStyle:UITableViewStylePlain];
        listVC.dataArray = self.depositVC.selectArray;
        [self.navigationController pushViewController:listVC animated:YES];
    }else{
        [MBProgressHUD showMessage:@"还未选择娃娃" toView:self.view];
    }
    
}

//申请兑换按钮
- (void)applyExchangeAction:(UIButton *)sender{
    
    if (self.depositVC.selectArray.count != 0) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"确认兑换" message:@"确认后将不能退回" preferredStyle:UIAlertControllerStyleAlert];
        // 2.创建并添加按钮
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *coins = @"";
            NSMutableArray *idsArr = [NSMutableArray array];
            NSMutableArray *coinArr = [NSMutableArray array];
            for (WwDepositItem *model in self.depositVC.selectArray) {
                [idsArr addObject:[NSString stringWithFormat:@"%zd",model.ID]];
                [coinArr addObject:[NSString stringWithFormat:@"%zd",model.coin]];
            }
            //38671,38687
            coins = [coinArr componentsJoinedByString:@","];
            [[WwUserInfoManager UserInfoMgrInstance] requestExchangeWawaWithDepositIds:idsArr deliverIds:@[] complete:^(int code, NSString *message) {
                if (code == WwCodeSuccess) {
                    [self sendMsgToServesWithCoin:coins];
                }else{
                    [MBProgressHUD showMessage:[NSString stringWithFormat:@"%zd%@",code,message] toView:self.view];
                }
            }];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"Cancel Action");
        }];
        [alertVC addAction:okAction];
        [alertVC addAction:cancelAction];
        [self presentViewController:alertVC animated:YES completion:nil];
    }else{
        [MBProgressHUD showMessage:@"还未选择娃娃" toView:self.view];
    }
    
}

//告诉服务器兑换了娃娃
- (void)sendMsgToServesWithCoin:(NSString *)coins{
    
    NSString *path = @"exchangeDiamonds";
    NSDictionary *params = @{@"uid":KUID,@"money":coins};
    [DYGHttpTool postWithURL:path params:params sucess:^(id json) {
        NSDictionary *dic = (NSDictionary *)json;
        if ([dic[@"code"] integerValue] == 200) {
            [MBProgressHUD showMessage:@"兑换成功" toView:self.view];
            [self loadData];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshUserData" object:nil];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
@end
