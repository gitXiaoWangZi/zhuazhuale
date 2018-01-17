//
//  FXSpoilsController.m
//  zzl
//
//  Created by Mr_Du on 2017/11/8.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "FXSpoilsController.h"
#import "FXCollecTBCell.h"
#import "FXLogisticsController.h"
#import "FXOrdingListViewController.h"
#import "UIButton+Position.h"
#define  btnW kScreenWidth/3

@interface FXSpoilsController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,FXColecTBCellDelegate>

@property(nonatomic,strong)NSArray * btnTitleArr;
@property (nonatomic,strong) UIView *topView;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UICollectionView * collectionView;
@property(nonatomic,strong) UIButton * tempBtn;
@property (nonatomic,strong) FXCollecTBCell * cell;


@property (nonatomic,strong) UIView *orderView;
@property (nonatomic,strong) UIButton *selectBtn;
@property (nonatomic,strong) UIButton *applySendBtn;
@property (nonatomic,strong) UIButton *applyExchangeBtn;

@property (nonatomic,strong) NSMutableArray *depositArr;
@property (nonatomic,strong) NSMutableArray *deliverArr;
@property (nonatomic,strong) NSMutableArray *exchangeArr;

@end

@implementation FXSpoilsController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.selectBtn.selected = NO;
    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshBottom:) name:@"KClickCell" object:nil];
    self.title =@"我的娃娃";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.btnTitleArr = @[@"寄存中",@"已发货",@"已兑换"];
    [self creatTopViewWithArr:self.btnTitleArr];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.width.bottom.equalTo(self.view);
    }];
    [self scrollViewDidEndDecelerating:self.collectionView];
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
    [self.view addSubview:self.topView];
    self.lineView.frame = CGRectMake((btnW - Px(60))/2.0, CGRectGetMaxY(self.topView.frame)-2, Px(60), 2);
    [self.view addSubview:self.lineView];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.btnTitleArr.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FXCollecTBCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"tableView" forIndexPath:indexPath];
    cell.delegate = self;
    if (indexPath.row == 0) {
        cell.colectType = WawaList_Deposit;
        cell.dataArray = self.depositArr;
    }else if (indexPath.row == 1){
        cell.colectType = WawaList_Deliver;
        cell.dataArray = self.deliverArr;
    }else{
        cell.colectType = WawaList_Exchange;
        cell.dataArray = self.exchangeArr;
    }
    self.cell = cell;
    [cell.tableView reloadData];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.width, collectionView.height);
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
        self.collectionView.contentInset = UIEdgeInsetsMake(40, 0, 50, 0);
    }else{
        self.orderView.hidden = YES;
        self.collectionView.contentInset = UIEdgeInsetsMake(40, 0, 0, 0);
    }
}
-(void)btnClickToScroll:(UIButton *)btn{
    if (self.tempBtn.tag==btn.tag) {
        
    }else{
        self.tempBtn.selected = NO;
        btn.selected = !btn.selected;
        self.tempBtn = btn;
        NSIndexPath * index = [NSIndexPath indexPathForRow:btn.tag-10 inSection:0];
        [self.collectionView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
    if (btn.tag == 10) {
        self.orderView.hidden = NO;
        self.collectionView.contentInset = UIEdgeInsetsMake(40, 0, 50, 0);
    }else{
        self.orderView.hidden = YES;
        self.collectionView.contentInset = UIEdgeInsetsMake(40, 0, 0, 0);
    }
}

-(void)cellDidClickWithIndexPath:(NSIndexPath *)indexPath{
    FXLogisticsController * vc = [FXLogisticsController new];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark lazy load
- (NSMutableArray *)deliverArr{
    if (!_deliverArr) {
        _deliverArr = [NSMutableArray array];
    }
    return _deliverArr;
}

- (NSMutableArray *)depositArr{
    if (!_depositArr) {
        _depositArr = [NSMutableArray array];
    }
    return _depositArr;
}

- (NSMutableArray *)exchangeArr{
    if (!_exchangeArr) {
        _exchangeArr = [NSMutableArray array];
    }
    return _exchangeArr;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = systemColor;
    }
    return _lineView;
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumLineSpacing = 0;
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame), kScreenWidth,self.view.height-self.lineView.y-Py(64)) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[FXCollecTBCell class] forCellWithReuseIdentifier:@"tableView"];
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
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
        self.depositArr = model.depositList;
        self.deliverArr = model.expressList;
        self.exchangeArr = model.exchangeList;
        
        [self.collectionView reloadData];
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
    if (self.cell.selectArray.count != 0) {
        FXOrdingListViewController *listVC = [[FXOrdingListViewController alloc] initWithStyle:UITableViewStylePlain];
        listVC.dataArray = self.cell.selectArray;
        [self.navigationController pushViewController:listVC animated:YES];
    }
    
}

//申请兑换按钮
- (void)applyExchangeAction:(UIButton *)sender{
    if (self.cell.selectArray.count != 0) {
        NSString *coins = @"";
        NSMutableArray *idsArr = [NSMutableArray array];
        NSMutableArray *coinArr = [NSMutableArray array];
        for (WwDepositItem *model in self.cell.selectArray) {
            [idsArr addObject:[NSString stringWithFormat:@"%zd",model.ID]];
            [coinArr addObject:[NSString stringWithFormat:@"%zd",model.coin]];
        }
        coins = [coinArr componentsJoinedByString:@","];
        [[WwUserInfoManager UserInfoMgrInstance] requestExchangeWawaWithDepositIds:idsArr deliverIds:@[] complete:^(int code, NSString *message) {
            if (code == WwCodeSuccess) {
                [self sendMsgToServesWithCoin:coins];
            }else{
                [MBProgressHUD showMessage:message toView:self.view];
            }
        }];
    }
}

//告诉服务器兑换了娃娃
- (void)sendMsgToServesWithCoin:(NSString *)coins{
    
    NSString *path = @"exchangeDiamonds";
    NSDictionary *params = @{@"uid":KUID,@"money":coins};
    [DYGHttpTool postWithURL:path params:params sucess:^(id json) {
        NSDictionary *dic = (NSDictionary *)json;
        if ([dic[@"code"] integerValue] == 200) {
            [MBProgressHUD showMessage:@"兑换成功" toView:self.collectionView];
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
