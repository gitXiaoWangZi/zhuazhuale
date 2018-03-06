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
#import "LSJPayPopView.h"

@interface FXOrdingListViewController ()<LSJPayPopViewDelegate>

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
@property (nonatomic,strong) LSJPayPopView *payPopView;
@end

@implementation FXOrdingListViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.downV removeFromSuperview];
    if (self.payPopView) {
        [self.payPopView removeFromSuperview];
    }
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

#pragma mark LSJPayPopViewDelegate
- (void)payForType:(BOOL)isWechat num:(NSString *)num{
    if (isWechat) {//微信
        [self wechatPay:num];
    }else{//支付宝
        [self zhifubaoPay:num];
    }
}

- (void)zhifubaoPay:(NSString *)num{
    self.payPopView.hidden = YES;
    WwDepositItem *item = self.dataArray[0];
    NSString *path = @"DealiPay";
    NSDictionary *params = @{@"uid":KUID,@"money":num,@"itemCode":@(item.wid)};
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

- (void)wechatPay:(NSString *)num{
    self.payPopView.hidden = YES;
    [self.navigationController popToRootViewControllerAnimated:YES];
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
            [[UIApplication sharedApplication].keyWindow addSubview:self.payPopView];
            self.payPopView.titleL.text = [NSString stringWithFormat:@"两件才包邮哦~单件商品发货需支付%@元",dic[@"data"][@"money"]];
            self.payPopView.num = dic[@"data"][@"money"];
            self.payPopView.hidden = YES;
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
    WwDepositItem *model = self.dataArray[0];
    if ((kWaWaID == model.wid && self.dataArray.count == 10)||(kWaWaID != model.wid)||(kWaWaID == model.wid && self.isDifference == YES)) {
        
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
    
}

- (void)sureOrding:(UIButton *)sender{
    if (self.addressModel == nil) {
        [MBProgressHUD showMessage:@"请选择地址" toView:self.view];
        return;
    }
    if (self.dataArray.count > 1) {
        [self applySend];
    }else{
        self.payPopView.hidden = NO;
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

- (LSJPayPopView *)payPopView{
    if (!_payPopView) {
        _payPopView = [LSJPayPopView instance];
        _payPopView.delegate = self;
        [_payPopView.rightBtn setTitle:@"再抓一次" forState:UIControlStateNormal];
    }
    return _payPopView;
}
@end
