//
//  FXRechargeViewController.m
//  zzl
//
//  Created by Mr_Du on 2017/11/3.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "FXRechargeViewController.h"
#import "FXRechargeHeader.h"
#import "FXRechargeCell.h"
#import "AccountItem.h"
@interface FXRechargeViewController ()<UITableViewDelegate,UITableViewDataSource,FXRechargeCellDelegate>

@property(nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong) FXRechargeHeader *rHeader;
@property (nonatomic,strong) NSArray *payCell;
@property (nonatomic,strong) FXRechargeCell *tempCell;
@property (nonatomic,assign) NSInteger isClick;

@property (nonatomic,copy) NSString *indent;
@end

@implementation FXRechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"充值";
    if(!_item){
        [self loadUserInfoData];
    }else{
        [self setUpUI];
    }
}
    
- (void)setUpUI{
    self.isClick = 0;
    self.tableView.backgroundColor = BGColor;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.tableView];
    self.rHeader = [[FXRechargeHeader alloc]initWithFrame:CGRectMake(0, 0, Px(342), Py(158))];
    self.rHeader.money.text = self.item.money;
    self.rHeader.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = self.rHeader;
    self.tableView.tableFooterView = [UIView new];
    
    // 判断 用户是否安装微信
    //如果判断结果一直为NO,可能appid无效,这里的是无效的
    if([WXApi isWXAppInstalled])
    
    {
        // 监听一个通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getOrderPayResult:) name:@"ORDER_PAY_NOTIFICATION" object:nil];
    }
}

-(NSArray *)payCell{
    if (!_payCell) {
        _payCell = @[@{@"img":@"wechat",@"payType":@"微信"},
                     @{@"img":@"alipay",@"payType":@"支付宝"}];
    }
    return _payCell;
}
#pragma mark tableView Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 2;
            break;
        default:
            return 1;
            break;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * reuseId;
    if (indexPath.section==0) {
        reuseId = @"collectCell";
        FXRechargeCell * cell = [[FXRechargeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
        cell.firstpunch = self.firstpunch;
        cell.delegate = self;
        return cell;
    }else{
        reuseId = @"selectCell";
        FXRechargeCell * cell = [[FXRechargeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
        NSString * str =self.payCell[indexPath.row][@"img"];
        cell.icon.image =[UIImage imageNamed:str];
        cell.payType.text = self.payCell[indexPath.row][@"payType"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.row == 0) {
            cell.seletBtn.selected = YES;
            self.tempCell = cell;
        }
        
        return cell;
    }
//    else{
//        reuseId = @"cell";
//        UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
//        cell.textLabel.text = @"邀请好友代付";
//        cell.textLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
//        cell.textLabel.textColor = TextColor;
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        return cell;
//    }
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @" ";
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return Py(15);
    }else if (section==1){
        return Py(50);
    }
    return Py(10);
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        return view;
    }else if (section==1){
        UIView *v = [UIView new];
        v.backgroundColor = BGColor;
        UIView * l = [UIView new];
        l.backgroundColor = [UIColor whiteColor];
        [v addSubview:l];
        [l mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(v);
            make.width.equalTo(@(Px(16)));
            make.top.equalTo(v).offset(Py(13));
        }];
        UILabel * label = [UILabel labelWithMediumFont:17 WithTextColor:TextColor];
        label.backgroundColor = DYGColorFromHex(0xffffff);
        label.text = @"选择支付方式";
        [v addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(l.mas_right);
            make.right.bottom.equalTo(v);
            make.top.equalTo(v).offset(Py(13));
        }];
        return v;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            return Py(178);
            break;
        default:
            return Py(55);
            break;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1) {
        FXRechargeCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        self.isClick = 1;
        if (self.isClick==1) {
            if (self.tempCell==cell) {
            }else{
                cell.seletBtn.selected = NO;
                cell.seletBtn.selected = !cell.seletBtn.selected;
                self.tempCell.seletBtn.selected = !self.tempCell.seletBtn.selected;
                self.tempCell = cell;
            }
        }else{
            cell.seletBtn.selected = !cell.seletBtn.selected;
            self.tempCell = cell;

        }
    }
}

#pragma mark FXRechargeCellDelegate 支付
- (void)payActionWithMoney:(NSString *)num{//钻石数
    
    FXRechargeCell *cell = (FXRechargeCell *)self.tempCell;
    NSLog(@"%@",num);
    NSString *path = @"pay";
    int money = [num intValue]/100;
    NSDictionary *params = @{@"uid":KUID,@"money":@(money)};
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
            if ([cell.payType.text isEqualToString:@"微信"]) {
                //调起微信支付
                if ([WXApi sendReq:req]) {
                    NSLog(@"调起成功");
                }
            }else{
                //调起支付宝支付
//                if ([WXApi sendReq:req]) {
                    NSLog(@"调起支付宝");
//                }
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
    } else {
        NSLog(@"支付失败");
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

#pragma mark lazy load

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

#pragma mark ---请求用户信息数据
- (void)loadUserInfoData{
    
    NSString *path = @"getUserInfo";
    NSDictionary *params = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KUser_ID]};
    [DYGHttpTool postWithURL:path params:params sucess:^(id json) {
        NSDictionary *dic = (NSDictionary *)json;
        if ([dic[@"code"] intValue] == 200) {
            _item = [AccountItem mj_objectWithKeyValues:dic[@"data"][0]];
            _firstpunch = dic[@"firstpunch"];
            
            [self setUpUI];
        }
    } failure:^(NSError *error) {
        
    }];
}
    
@end
