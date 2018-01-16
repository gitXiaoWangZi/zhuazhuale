//
//  LSJRechargeViewController.m
//  zzl
//
//  Created by Mr_Du on 2018/1/5.
//  Copyright © 2018年 Mr.Du. All rights reserved.
//

#import "LSJRechargeViewController.h"
#import "RechargeModel.h"
#import "LSJRechargeCell.h"
#import "LSJRechargeFooterV.h"

@interface LSJRechargeViewController ()<LSJRechargeFooterVDelegate>

@property (nonatomic,strong) NSArray *dataArr;
@property (nonatomic,strong) LSJRechargeFooterV *footerV;

@property (nonatomic,strong) UILabel *zuanshiNumL;//钻石数
@property (nonatomic,assign) BOOL isFirst;
@property (nonatomic,assign) NSInteger payNum;
@property (nonatomic,copy) NSString *indent;

@end

static NSString *const cellID = @"LSJRechargeCell";
@implementation LSJRechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.payNum = 0;
    self.title = @"充值";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView registerClass:[LSJRechargeCell class] forCellReuseIdentifier:cellID];
    self.tableView.tableHeaderView = [self headerView];
    self.tableView.tableFooterView = self.footerV;
    [self loadData];
    // 判断 用户是否安装微信
    //如果判断结果一直为NO,可能appid无效,这里的是无效的
    if([WXApi isWXAppInstalled])
        
    {
        // 监听一个通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getOrderPayResult:) name:@"ORDER_PAY_NOTIFICATION" object:nil];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getOrderzfbPayResult:) name:@"ORDER_ZFBPAY_NOTIFICATION" object:nil];
}

- (UIView *)headerView{
    UIView *headerV = [UIView new];
    headerV.frame = CGRectMake(0, 0, kScreenWidth, Py(68));
    headerV.backgroundColor = [UIColor whiteColor];
    
    UIView *lineV = [[UIView alloc] init];
    lineV.backgroundColor = DYGColorFromHex(0xEDF1F5);
    [headerV addSubview:lineV];
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(headerV.mas_bottom);
        make.left.right.equalTo(headerV);
        make.height.equalTo(@(Py(5)));
    }];
    
    UILabel *titleL = [[UILabel alloc] init];
    titleL.text = @"我的余额";
    titleL.textColor = DYGColorFromHex(0x494848);
    titleL.font = [UIFont systemFontOfSize:15];
    [headerV addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerV.mas_left).offset(15);
        make.centerY.equalTo(headerV.mas_centerY).offset(Py(-5));
    }];
    
    UIImageView *zuanImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_diamo"]];
    [headerV addSubview:zuanImgV];
    [zuanImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleL.mas_right).offset(10);
        make.centerY.equalTo(titleL.mas_centerY);
    }];
    
    self.zuanshiNumL = [[UILabel alloc] init];
    self.zuanshiNumL.textColor = DYGColorFromHex(0x494848);
    self.zuanshiNumL.font = [UIFont fontWithName:@"STYuanti-SC-Bold" size:20];
    [headerV addSubview:self.zuanshiNumL];
    [self.zuanshiNumL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(zuanImgV.mas_right).offset(5);
        make.centerY.equalTo(titleL.mas_centerY);
    }];
    return headerV;
}

#pragma mark 请求充值数据
- (void)loadData{
    NSString *path = @"rechargePage";
    NSDictionary *params = @{@"uid":KUID};
    [DYGHttpTool postWithURL:path params:params sucess:^(id json) {
        NSDictionary *dic = (NSDictionary *)json;
        if ([dic[@"code"] integerValue] == 200) {
            self.zuanshiNumL.text = [dic[@"money"] stringValue];
            self.dataArr = [RechargeModel mj_objectArrayWithKeyValuesArray:dic[@"data"]];
            self.isFirst = [dic[@"firstpunch"] integerValue] == 1 ? YES : NO;
            [self.tableView reloadData];
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
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RechargeModel *model = self.dataArr[indexPath.row];
    LSJRechargeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    [cell fillPageWithData:model isFirst:self.isFirst];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RechargeModel *model = self.dataArr[indexPath.row];
    for (LSJRechargeCell *cell in [tableView visibleCells]) {
        cell.selectImgV.hidden = YES;
    }
    LSJRechargeCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectImgV.hidden = NO;
    self.payNum = [model.money integerValue];
}

#pragma mark  LSJRechargeFooterVDelegate
- (void)payActionWithType:(RechargePayType)type{
    if (![self isCanPay]) {
        return;
    }
    switch (type) {
        case RechargePayTypeWechat:
            {
                NSString *path = @"pay";
                NSDictionary *params = @{@"uid":KUID,@"money":@(self.payNum)};
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
                        _indent = dic[@"data"][@"indent"];
                        if ([WXApi sendReq:req]) {
                            NSLog(@"调起成功");
                        }
                    }
                } failure:^(NSError *error) {
                    NSLog(@"%@",error);
                }];
            }
            break;
        case RechargePayTypeZhifubao:
        {
            NSString *path = @"aliPay";
            NSDictionary *params = @{@"uid":KUID,@"money":@(self.payNum)};
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
            break;
        case RechargePayTypeNil:
        {
            [MBProgressHUD showMessage:@"请选择充值方式" toView:self.tableView];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 收到支付成功的消息后作相应的处理
- (void)getOrderPayResult:(NSNotification *)notification
{
    if ([notification.object isEqualToString:@"success"]) {
        NSString *path = @"payResult";
        NSDictionary *params = @{@"indent":_indent,@"uid":KUID};
        [DYGHttpTool postWithURL:path params:params sucess:^(id json) {
            NSDictionary *dic = (NSDictionary *)json;
            if ([dic[@"code"] integerValue] == 200) {
                if ([self.firstpunch integerValue] == 1) {//首冲
                    [self loadRechargeSuccessData];
                }
                [MobClick event:@"wecat_pay"];
                [MBProgressHUD showSuccess:@"支付成功" toView:self.view];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshUserData" object:nil];
            }else if ([dic[@"code"] integerValue] == 502){
                [MBProgressHUD showError:@"订单号为空" toView:self.view];
            }else{
                [MBProgressHUD showError:@"支付失败" toView:self.view];
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }else {
        NSLog(@"支付失败");
    }
}

//支付宝回调
- (void)getOrderzfbPayResult:(NSNotification *)noti{
    NSDictionary *dic= noti.object;
    if ([dic[@"resultStatus"] integerValue] == 9000) {
        if ([self.firstpunch integerValue] == 1) {//首冲
            [self loadRechargeSuccessData];
        }
        [MobClick event:@"alipay_click"];
        [MBProgressHUD showSuccess:@"支付成功" toView:self.view];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshUserData" object:nil];
    }else{
        [MBProgressHUD showError:@"支付失败" toView:self.view];
    }
}

#pragma mark 首冲成功后的接口
- (void)loadRechargeSuccessData{
    NSString *path = @"raw_award";
    NSDictionary *params = @{@"uid":KUID,@"type":@"first_pay"};
    [DYGHttpTool postWithURL:path params:params sucess:^(id json) {
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

//是否可以支付判断
- (BOOL)isCanPay{
    if (self.payNum == 0) {
        [MBProgressHUD showMessage:@"请选择充值金额" toView:self.tableView];
        return NO;
    }
    return YES;
}

#pragma mark lazyload
- (NSArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSArray array];
    }
    return _dataArr;
}

- (LSJRechargeFooterV *)footerV{
    if (!_footerV) {
        _footerV = [[[NSBundle mainBundle] loadNibNamed:@"LSJRechargeFooterV" owner:nil options:nil] firstObject];
        _footerV.frame = CGRectMake(0, 0, kScreenWidth, 237);
        _footerV.delegate = self;
    }
    return _footerV;
}
@end
