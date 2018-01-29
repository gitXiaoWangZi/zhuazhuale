//
//  FXOrdingListViewController.m
//  zzl
//
//  Created by Mr_Du on 2017/11/29.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "FXOrdingListViewController.h"
#import "FXSpoilsCell.h"
#import "FXAddressManageController.h"

@interface FXOrdingListViewController ()
{
    NSString *money;
}
@property (nonatomic,strong) UIView *nBgView;
@property (nonatomic,strong) UIImageView *nAdressIcon;
@property (nonatomic,strong) UILabel *msgL;
@property (nonatomic,strong) UIImageView *nArrowImgV;
@property (nonatomic,strong) UIImageView *nBottomImgV;

@property (nonatomic,strong) UIView *yBgView;
@property (nonatomic,strong) UILabel *nameL;
@property (nonatomic,strong) UILabel *phoneL;
@property (nonatomic,strong) UIImageView *yAdressIcon;
@property (nonatomic,strong) UILabel *adressL;
@property (nonatomic,strong) UIImageView *yArrowImgV;
@property (nonatomic,strong) UIImageView *yBottomImgV;

@property (nonatomic,strong) UIView *downV;
@property (nonatomic,strong) UILabel *numLabel;
@property (nonatomic,strong) UIButton *sureBtn;

@property (nonatomic,strong) WwAddress *addressModel;
@property (nonatomic,strong) UIView *popBgView;
@end

@implementation FXOrdingListViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.downV removeFromSuperview];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.downV.frame = CGRectMake(0, kScreenHeight-50, kScreenWidth, 50);
    [[UIApplication sharedApplication].keyWindow addSubview:self.downV];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"确认订单";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView registerClass:[FXSpoilsCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    
    [self setUpUI];
    [[WwUserInfoManager UserInfoMgrInstance] requestMyAddressListWithComplete:^(int code, NSString *message, NSArray<WwAddress *> *list) {
        if (list.count == 0) {
            self.nBgView.frame = CGRectMake(0, 0, kScreenWidth, Py(80));
            self.tableView.tableHeaderView = self.nBgView;
        }else{
            self.yBgView.frame = CGRectMake(0, 0, kScreenWidth, Py(90));
            self.tableView.tableHeaderView = self.yBgView;
            WwAddress *model = list[0];
            self.addressModel = model;
            self.nameL.text = [NSString stringWithFormat:@"收货人:%@",model.name];
            self.phoneL.text = model.phone;
            self.adressL.text = [NSString stringWithFormat:@"收货地址:%@%@%@%@",model.province,model.city,model.district,model.address];
        }
    }];
    [self.numLabel setText:[NSString stringWithFormat:@"共%zd件",self.dataArray.count]];
    if (self.dataArray.count == 1) {
        [self loadPostFeeData];
    }
}

- (void)addPostViewWithMoney:(NSString *)money{
    UIView *bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    bgView.backgroundColor = DYGAColor(0, 0, 0, 0.4);
    self.popBgView = bgView;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissSelf)];
    [bgView addGestureRecognizer:tap];
    
    UIView *centerV = [[UIView alloc] init];
    centerV.backgroundColor = [UIColor whiteColor];
    centerV.cornerRadius = 8;
    [bgView addSubview:centerV];
    [centerV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(bgView);
        make.width.equalTo(@(Px(280)));
        make.height.equalTo(@(Py(180)));
    }];
    UIButton *dismissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [dismissBtn setImage:[UIImage imageNamed:@"mine_send_cross"] forState:UIControlStateNormal];
    [dismissBtn addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
    [centerV addSubview:dismissBtn];
    [dismissBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(centerV).offset(Py(10));
        make.right.equalTo(centerV).offset(-Px(10));
    }];
    UILabel *titleL = [[UILabel alloc] init];
    titleL.textColor = DYGColor(77, 77, 77);
    titleL.font = kPingFangSC_Medium(24);
    titleL.numberOfLines = 2;
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.text = [NSString stringWithFormat:@"单个商品发货需要支付%@元哦~",money];
    [centerV addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(centerV).offset(Py(50));
        make.left.equalTo(centerV.mas_left).offset(Px(20));
        make.right.equalTo(centerV.mas_right).offset(-Px(20));
    }];
    UIButton *zhifubaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [zhifubaoBtn setTitle:@"支付宝" forState:UIControlStateNormal];
    zhifubaoBtn.titleLabel.font = kPingFangSC_Semibold(15);
    [zhifubaoBtn setTitleColor:DYGColor(19, 130, 233) forState:UIControlStateNormal];
    [zhifubaoBtn addTarget:self action:@selector(zhifubaoPay:) forControlEvents:UIControlEventTouchUpInside];
    [centerV addSubview:zhifubaoBtn];
    [zhifubaoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(centerV);
        make.left.equalTo(centerV);
        make.width.equalTo(@((Px(280)-0.5)/2.0));
        make.height.equalTo(@(Py(52)));
    }];
    UIButton *wechatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [wechatBtn setTitle:@"微信" forState:UIControlStateNormal];
    wechatBtn.titleLabel.font = kPingFangSC_Semibold(15);
    [wechatBtn setTitleColor:DYGColor(35, 186, 0) forState:UIControlStateNormal];
    [wechatBtn addTarget:self action:@selector(wechatPay:) forControlEvents:UIControlEventTouchUpInside];
    [centerV addSubview:wechatBtn];
    [wechatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(centerV);
        make.right.equalTo(centerV);
        make.width.equalTo(@((Px(280)-0.5)/2.0));
        make.height.equalTo(@(Py(52)));
    }];
    UIView *line0 = [UIView new];
    line0.backgroundColor = DYGColor(204, 204, 204);
    [centerV addSubview:line0];
    [line0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(centerV);
        make.width.equalTo(@(0.5));
        make.centerX.equalTo(centerV);
        make.height.equalTo(@(Py(52)));
    }];
    UIView *line = [UIView new];
    line.backgroundColor = DYGColor(204, 204, 204);
    [centerV addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(line0.mas_top);
        make.height.equalTo(@(0.5));
        make.left.right.equalTo(centerV);
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:bgView];
    bgView.hidden = YES;
}

- (void)dismissSelf{
    self.popBgView.hidden = YES;
}

- (void)zhifubaoPay:(UIButton *)sender{
    self.popBgView.hidden = YES;
    WwDepositItem *item = self.dataArray[0];
    NSString *path = @"DealiPay";
    NSDictionary *params = @{@"uid":KUID,@"money":money,@"itemCode":@(item.wid)};
    [DYGHttpTool postWithURL:path params:params sucess:^(id json) {
        NSDictionary *dic = (NSDictionary *)json;
        if ([dic[@"code"] integerValue] == 200) {
            [[AlipaySDK defaultService] payOrder:dic[@"data"] fromScheme:@"zzlwwzfb" callback:^(NSDictionary *resultDic) {
            }];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)wechatPay:(UIButton *)sender{
    self.popBgView.hidden = YES;
    WwDepositItem *item = self.dataArray[0];
    NSString *path = @"Depay";
    NSDictionary *params = @{@"uid":KUID,@"money":money,@"itemCode":@(item.wid)};
    [DYGHttpTool postWithURL:path params:params sucess:^(id json) {
        NSDictionary *dic = (NSDictionary *)json;
        if ([dic[@"code"] integerValue] == 200) {
            PayReq *req = [[PayReq alloc] init];
            req.partnerId = dic[@"data"][@"partnerid"];
            req.prepayId = dic[@"data"][@"prepayid"];
            req.package = dic[@"data"][@"package"];
            req.nonceStr = dic[@"data"][@"noncestr"];
            req.timeStamp = [dic[@"data"][@"timestamp"] intValue];
            req.sign = dic[@"data"][@"sign"];
            if ([WXApi sendReq:req]) {
                NSLog(@"调起成功");
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - 收到支付成功的消息后作相应的处理
- (void)getOrderPayResult:(NSNotification *)notification
{
    if ([notification.object isEqualToString:@"success"]) {
        [MBProgressHUD showSuccess:@"支付成功" toView:self.view];
        [self applySend];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshUserData" object:nil];
    }else {
        [MBProgressHUD showSuccess:@"支付失败" toView:self.view];
    }
}

//支付宝回调
- (void)getOrderzfbPayResult:(NSNotification *)noti{
    NSDictionary *dic= noti.object;
    if ([dic[@"resultStatus"] integerValue] == 9000) {
        [MBProgressHUD showSuccess:@"支付成功" toView:self.view];
        [self applySend];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshUserData" object:nil];
    }else{
        [MBProgressHUD showError:@"支付失败" toView:self.view];
    }
}

#pragma mark 请求支付邮费
- (void)loadPostFeeData{
    NSString *path = @"Postage";
    NSDictionary *params = @{@"uid":KUID};
    [DYGHttpTool postWithURL:path params:params sucess:^(id json) {
        NSDictionary *dic = (NSDictionary *)json;
        if ([dic[@"code"] integerValue] == 200) {
            money = dic[@"data"][@"money"];
            [self addPostViewWithMoney:money];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FXSpoilsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    cell.celltype = WawaList_All;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Py(90);
}

- (void)setUpUI{
    
    [self.nBgView addSubview:self.nAdressIcon];
    [self.nAdressIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(10));
        make.centerY.equalTo(self.nBgView).offset(-5);
        make.width.equalTo(@(Px(17)));
        make.height.equalTo(@(Py(23)));
    }];
    [self.nBgView addSubview:self.msgL];
    [self.msgL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nAdressIcon.mas_right).offset(Px(5));
        make.centerY.equalTo(self.nAdressIcon);
    }];
    [self.nBgView addSubview:self.nArrowImgV];
    [self.nArrowImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-10));
        make.centerY.equalTo(self.nAdressIcon);
        make.width.equalTo(@(Px(9)));
        make.height.equalTo(@(Py(16)));
    }];
    [self.nBgView addSubview:self.nBottomImgV];
    [self.nBottomImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(0));
        make.bottom.equalTo(@(0));
        make.right.equalTo(@(0));
        make.height.equalTo(@(Py(5)));
    }];

    [self.yBgView addSubview:self.yAdressIcon];
    [self.yAdressIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(10));
        make.centerY.equalTo(self.yBgView).offset(-5);
        make.width.equalTo(@(Px(17)));
        make.height.equalTo(@(Py(23)));
    }];
    [self.yBgView addSubview:self.nameL];
    [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.yAdressIcon.mas_right).offset(Px(10));
        make.top.equalTo(@(10));
    }];
    [self.yBgView addSubview:self.yArrowImgV];
    [self.yArrowImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-10));
        make.centerY.equalTo(self.yBgView).offset(-5);
        make.width.equalTo(@(Px(9)));
        make.height.equalTo(@(Py(16)));
    }];
    [self.yBgView addSubview:self.phoneL];
    [self.phoneL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.yArrowImgV.mas_left).offset(Px(-10));
        make.top.equalTo(@(10));
        make.left.equalTo(self.nameL.mas_right).offset(Px(0));
    }];
    [self.yBgView addSubview:self.adressL];
    [self.adressL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.yArrowImgV.mas_left).offset(Px(-10));
        make.top.equalTo(self.nameL.mas_bottom).offset(Px(5));
        make.left.equalTo(self.yAdressIcon.mas_right).offset(Px(10));
    }];
    [self.yBgView addSubview:self.yBottomImgV];
    [self.yBottomImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(0));
        make.bottom.equalTo(@(0));
        make.right.equalTo(@(0));
        make.height.equalTo(@(Py(5)));
    }];
    
    [self.downV addSubview:self.sureBtn];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-10));
        make.centerY.equalTo(self.downV);
        make.width.equalTo(@(Px(70)));
        make.height.equalTo(@(Py(30)));
    }];
    self.sureBtn.layer.cornerRadius = Py(15);
    self.sureBtn.layer.masksToBounds = YES;
    
    [self.downV addSubview:self.numLabel];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.sureBtn.mas_left).offset(Px(-10));
        make.centerY.equalTo(self.sureBtn);
    }];
    
    UIView *lineV = [[UIView alloc] init];
    lineV.backgroundColor = DYGColorFromHex(0xeeeeee);
    [self.downV addSubview:lineV];
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(@(0));
        make.height.equalTo(@(1));
    }];
}

- (void)jumpAdress:(UITapGestureRecognizer *)tap {
    FXAddressManageController *addressVC = [[FXAddressManageController alloc] init];
    addressVC.isMine = @"yes";//做标识，从战利品进去的
    __weak typeof(self) weakSelf = self;
    addressVC.getAddressModelBlock = ^(WwAddress *model) {
        weakSelf.yBgView.frame = CGRectMake(0, 0, kScreenWidth, Py(90));
        weakSelf.tableView.tableHeaderView = weakSelf.yBgView;
        weakSelf.addressModel = model;
        weakSelf.nameL.text = [NSString stringWithFormat:@"收货人:%@",model.name];
        weakSelf.phoneL.text = model.phone;
        weakSelf.adressL.text = [NSString stringWithFormat:@"收货地址:%@%@%@%@",model.province,model.city,model.district,model.address];
    };
    [self.navigationController pushViewController:addressVC animated:YES];
}

//申请发货
- (void)applySend{
    NSMutableArray *tempArr = [NSMutableArray array];
    for (WwDepositItem *model in self.dataArray) {
        [tempArr addObject:[NSString stringWithFormat:@"%zd",model.ID]];
    }
    [[WawaSDK WawaSDKInstance].userInfoMgr requestCreateOrderWithWawaIds:tempArr address:self.addressModel completeHandler:^(int code, NSString *message) {
        
        if (code == WwCodeSuccess) {
            [MBProgressHUD showMessage:@"申请成功" toView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    }];
}

- (void)sureOrding:(UIButton *)sender{
    if (self.addressModel == nil) {
        [MBProgressHUD showMessage:@"请选择地址" toView:self.view];
        return;
    }
    if (self.dataArray.count > 1) {
        [self applySend];
    }else{
        self.popBgView.hidden = NO;
    }
    
}

#pragma mark 懒加载

- (UIView *)nBgView{
    if (!_nBgView) {
        _nBgView = [[UIView alloc] init];
        _nBgView.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpAdress:)];
        [_nBgView addGestureRecognizer:tap];
    }
    return _nBgView;
}

- (UIImageView *)nAdressIcon{
    if (!_nAdressIcon) {
        _nAdressIcon = [[UIImageView alloc] init];
        _nAdressIcon.image = [UIImage imageNamed:@"mine_adress"];
        _nAdressIcon.contentMode = UIViewContentModeCenter;
    }
    return _nAdressIcon;
}

- (UILabel *)msgL{
    if (!_msgL) {
        _msgL = [UILabel labelWithFont:14 WithTextColor:DYGColorFromHex(0x999999) WithAlignMent:NSTextAlignmentLeft];
        _msgL.text = @"小主，您还未添加收货地址~";
    }
    return _msgL;
}

- (UIImageView *)nArrowImgV{
    if (!_nArrowImgV) {
        _nArrowImgV = [[UIImageView alloc] init];
        _nArrowImgV.image = [UIImage imageNamed:@"mine_rightArrow"];
        _nArrowImgV.contentMode = UIViewContentModeCenter;
    }
    return _nArrowImgV;
}

- (UIImageView *)nBottomImgV{
    if (!_nBottomImgV) {
        _nBottomImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_bottomLine"]];
    }
    return _nBottomImgV;
}

- (UIView *)yBgView{
    if (!_yBgView) {
        _yBgView = [[UIView alloc] init];
        _yBgView.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpAdress:)];
        [_yBgView addGestureRecognizer:tap];
    }
    return _yBgView;
}

- (UILabel *)nameL{
    if (!_nameL) {
        _nameL = [UILabel labelWithFont:14 WithTextColor:TextColor WithAlignMent:NSTextAlignmentLeft];
    }
    return _nameL;
}

- (UILabel *)phoneL{
    if (!_phoneL) {
        _phoneL = [UILabel labelWithFont:14 WithTextColor:TextColor WithAlignMent:NSTextAlignmentRight];
    }
    return _phoneL;
}

- (UIImageView *)yAdressIcon{
    if (!_yAdressIcon) {
        _yAdressIcon = [[UIImageView alloc] init];
        _yAdressIcon.image = [UIImage imageNamed:@"mine_adress"];
    }
    return _yAdressIcon;
}

- (UILabel *)adressL{
    if (!_adressL) {
        _adressL = [UILabel labelWithFont:14 WithTextColor:TextColor WithAlignMent:NSTextAlignmentLeft];
        _adressL.numberOfLines = 2;
    }
    return _adressL;
}

- (UIImageView *)yArrowImgV{
    if (!_yArrowImgV) {
        _yArrowImgV = [[UIImageView alloc] init];
        _yArrowImgV.image = [UIImage imageNamed:@"mine_rightArrow"];
        _yArrowImgV.contentMode = UIViewContentModeCenter;
    }
    return _yArrowImgV;
}

- (UIImageView *)yBottomImgV{
    if (!_yBottomImgV) {
        _yBottomImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_bottomLine"]];
    }
    return _yBottomImgV;
}

- (UIView *)downV{
    if (!_downV) {
        _downV = [[UIView alloc] init];
        _downV.backgroundColor = [UIColor whiteColor];
    }
    return _downV;
}

- (UILabel *)numLabel{
    if (!_numLabel) {
        _numLabel = [UILabel labelWithFont:14 WithTextColor:TextColor WithAlignMent:NSTextAlignmentLeft];
        _numLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _numLabel;
}

- (UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureBtn setTitle:@"确认订单" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:systemColor forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _sureBtn.layer.borderColor = systemColor.CGColor;
        _sureBtn.layer.borderWidth = 1;
        [_sureBtn addTarget:self action:@selector(sureOrding:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}
@end
