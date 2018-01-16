//
//  LSJPersonalTableViewController.m
//  zzl
//
//  Created by Mr_Du on 2017/12/28.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "LSJPersonalTableViewController.h"
#import "LSJMineCell.h"
#import "LSJPersonalHeaderView.h"
#import "FXSettingViewController.h"
#import "FXNotificationController.h"
#import "FXHomeBannerItem.h"
#import "FXGameWebController.h"
#import "FXHelpController.h"
#import "FXAddressManageController.h"
#import "FXTaskViewController.h"
#import "FXRecordViewController.h"
#import "FXSpoilsController.h"
#import "AccountItem.h"
#import "FXRechargeViewController.h"
#import "FXUserInfoController.h"
#import "LSJBangPhoneViewController.h"
#import "FXRechargeRecordContoller.h"
#import "LSJRechargeViewController.h"
#import "LSJKoulingPopView.h"

@interface LSJPersonalTableViewController ()<LSJPersonalHeaderViewDelegate>


@property (nonatomic,strong) AccountItem *item;
@property (nonatomic,copy) NSString *receive;
@property (nonatomic,copy) NSString *firstpunch;

@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,strong) NSArray *phoneArray;
@property (nonatomic,strong) LSJPersonalHeaderView *headerView;
@property (nonatomic,strong) UIView *footerV;
@property (nonatomic,assign) BOOL isBang;
@property (nonatomic,strong) LSJKoulingPopView *kouling;

@end

static NSString *const cellID = @"LSJMineCell";
@implementation LSJPersonalTableViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //请求用户信息
    [self loadUserInfoData];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerClass:[LSJMineCell class] forCellReuseIdentifier:cellID];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
}

#pragma mark ---请求用户信息数据
- (void)loadUserInfoData{
    
    NSString *path = @"getUserInfo";
    NSDictionary *params = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KUser_ID]};
    [DYGHttpTool postWithURL:path params:params sucess:^(id json) {
        NSDictionary *dic = (NSDictionary *)json;
        if ([dic[@"code"] intValue] == 200) {
            _item = [AccountItem mj_objectWithKeyValues:dic[@"data"][0]];
            self.headerView.item = _item;
            _firstpunch = dic[@"firstpunch"];
            NSString *phonestr = dic[@"phone"];
            self.isBang = phonestr.length == 11 ? YES : NO;
            [self loadTastListData];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark 获取用户任务列表
- (void)loadTastListData{
    NSString *path = @"task";
    NSDictionary *params = @{@"uid":KUID};
    [DYGHttpTool postWithURL:path params:params sucess:^(id json) {
        NSDictionary *dic = (NSDictionary *)json;
        if ([dic[@"code"] integerValue] == 200) {
            _receive = [dic[@"red"] stringValue];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (KisWChatLogin) {
        return self.dataArray.count;
    }else{
        return self.phoneArray.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (KisWChatLogin) {
        NSArray *arr = self.dataArray[section];
        return arr.count;
    }else{
        NSArray *arr = self.phoneArray[section];
        return arr.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSJMineCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    if (KisWChatLogin) {
        cell.iconImgV.image = [UIImage imageNamed:self.dataArray[indexPath.section][indexPath.row][@"image"]];
        cell.nameL.text = self.dataArray[indexPath.section][indexPath.row][@"name"];
    }else{
        cell.iconImgV.image = [UIImage imageNamed:self.phoneArray[indexPath.section][indexPath.row][@"image"]];
        cell.nameL.text = self.phoneArray[indexPath.section][indexPath.row][@"name"];
    }
    if ([cell.nameL.text isEqualToString:@"绑定手机号"] && self.isBang) {
        cell.desL.hidden = NO;
        cell.desL.text = @"已绑定";
    }
    if ([cell.nameL.text isEqualToString:@"邀请好友"]) {
        cell.hotImgV.hidden = NO;
    }
    if ([cell.nameL.text isEqualToString:@"帮助与反馈"]) {
        cell.desL.hidden = NO;
    }
    if ([cell.nameL.text isEqualToString:@"每日任务"] && [_receive integerValue] == 1) {
        cell.warnImgV.hidden = NO;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 5.0;
    }else{
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0, kScreenWidth,5)];
        view.backgroundColor = DYGColorFromHex(0xEFF3F6);
        return view;
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            FXSpoilsController *spoilVC = [[FXSpoilsController alloc] init];
            [self.navigationController pushViewController:spoilVC animated:YES];
        }else if (indexPath.row == 1) {
            FXRecordViewController *recordVC = [[FXRecordViewController alloc] init];
            [self.navigationController pushViewController:recordVC animated:YES];
        }else if (indexPath.row == 2) {
            FXTaskViewController *taskVC = [[FXTaskViewController alloc] init];
            [self.navigationController pushViewController:taskVC animated:YES];
        }else if (indexPath.row == 3) {
            FXAddressManageController *addressVC = [[FXAddressManageController alloc] init];
            [self.navigationController pushViewController:addressVC animated:YES];
        }
    }else{
        if (indexPath.row == 0) {
            FXHomeBannerItem *item = [FXHomeBannerItem new];
            item.href = @"http://wawa.api.fanx.xin/share";
            item.title = @"邀请好友";
            item.banner_type = @"2";
            FXGameWebController *vc = [[FXGameWebController alloc] init];
            vc.item = item;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 1){
            {
                _kouling = [LSJKoulingPopView shareInstance];
                _kouling.frame = [UIScreen mainScreen].bounds;
                _kouling.sendKoulingClock = ^(NSString *msg) {
                    if (msg.length > 0) {
                        NSString *path = @"exchange";
                        NSDictionary *params = @{@"uid":KUID,@"command":msg};
                        [DYGHttpTool postWithURL:path params:params sucess:^(id json) {
                            NSDictionary *dic = (NSDictionary *)json;
                            [MBProgressHUD showMessage:dic[@"msg"] toView:[UIApplication sharedApplication].keyWindow];
                            if ([dic[@"code"] integerValue] == 200) {
                                [weakSelf.kouling removeFromSuperview];
                            }
                        } failure:^(NSError *error) {
                            NSLog(@"%@",error);
                        }];
                    }else{
                        [MBProgressHUD showMessage:@"请输入口令" toView:[UIApplication sharedApplication].keyWindow];
                    }
                };
                [[UIApplication sharedApplication].keyWindow addSubview:_kouling];
            }
        }else if (indexPath.row == 2){
            if (KisWChatLogin) {
                if (self.isBang) {
                    return;
                }
                LSJBangPhoneViewController *bangVC = [[LSJBangPhoneViewController alloc] init];
                [self.navigationController pushViewController:bangVC animated:YES];
            }else{
                FXHelpController *helpVC = [[FXHelpController alloc] init];
                [self.navigationController pushViewController:helpVC animated:YES];
            }
        }else if (indexPath.row == 3){
            FXHelpController *helpVC = [[FXHelpController alloc] init];
            [self.navigationController pushViewController:helpVC animated:YES];
        }
    }
}

- (void)changeAccount:(UIButton *)sender{
    
}

#pragma mark LSJPersonalHeaderViewDelegate
- (void)doHeaderNavAction:(personalHeader)header{
    switch (header) {
        case personalHeaderBack:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case personalHeaderMsg:
        {
            FXNotificationController *msgVC = [[FXNotificationController alloc] init];
            [self.navigationController pushViewController:msgVC animated:YES];
        }
            break;
        case personalHeaderSetting:
        {
            FXSettingViewController *settingVC = [[FXSettingViewController alloc] init];
            [self.navigationController pushViewController:settingVC animated:YES];
        }
            break;
        case personalHeaderZuanshi:
        {
            FXRechargeRecordContoller *rechargeVC = [[FXRechargeRecordContoller alloc] init];
            rechargeVC.moneyStr = self.item.money;
            [self.navigationController pushViewController:rechargeVC animated:YES];
        }
            break;
        case personalHeaderRecharge:
        {
            [MobClick event:@"click_pay"];
            LSJRechargeViewController *rechargeVC = [[LSJRechargeViewController alloc] init];
            rechargeVC.firstpunch = self.firstpunch;
            rechargeVC.item = self.item;
            [self.navigationController pushViewController:rechargeVC animated:YES];
        }
            break;
        case personalHeaderOtherPay:
        {
            FXHomeBannerItem *item = [FXHomeBannerItem new];
            item.href = [NSString stringWithFormat:@"%@?uid=%@",@"http://openapi.wawa.zhuazhuale.xin/zhuli",KUID];
            item.title = @"好友助力";
            FXGameWebController *vc = [[FXGameWebController alloc] init];
            vc.item = item;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case personalHeaderIcon:
        {
            FXUserInfoController * vc = [FXUserInfoController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark lazyload
- (NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = @[@[@{@"image":@"mine_header_myWawa",@"name":@"我的娃娃"},
                         @{@"image":@"mine_header_gameRecord",@"name":@"游戏记录"},
                         @{@"image":@"mine_header_task",@"name":@"每日任务"},
                         @{@"image":@"mine_header_address",@"name":@"收货地址"}],
                       @[@{@"image":@"mine_header_yaoqing",@"name":@"邀请好友"},
                         @{@"image":@"mine_header_kouling",@"name":@"口令兑换"},
                         @{@"image":@"mine_phone_number",@"name":@"绑定手机号"},
                         @{@"image":@"mine_header_help",@"name":@"帮助与反馈"}]];
    }
    return _dataArray;
}

- (NSArray *)phoneArray{
    if (!_phoneArray) {
        _phoneArray = @[@[@{@"image":@"mine_header_myWawa",@"name":@"我的娃娃"},
                         @{@"image":@"mine_header_gameRecord",@"name":@"游戏记录"},
                         @{@"image":@"mine_header_task",@"name":@"每日任务"},
                         @{@"image":@"mine_header_address",@"name":@"收货地址"}],
                       @[@{@"image":@"mine_header_yaoqing",@"name":@"邀请好友"},
                         @{@"image":@"mine_header_kouling",@"name":@"口令兑换"},
                         @{@"image":@"mine_header_help",@"name":@"帮助与反馈"}]];
    }
    return _phoneArray;
}

- (LSJPersonalHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [LSJPersonalHeaderView shareInstance];
        _headerView.delegate = self;
        _headerView.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth * 0.93 - 60);
    }
    return _headerView;
}

- (UIView *)footerV{
    if (!_footerV) {
        _footerV = [[UIView alloc] initWithFrame:CGRectMake(0,0, kScreenWidth,90)];
        _footerV.backgroundColor = [UIColor whiteColor];
        
        UIView *view0 = [[UIView alloc] initWithFrame:CGRectMake(0,0, kScreenWidth,5)];
        view0.backgroundColor = DYGColorFromHex(0xEFF3F6);
        [_footerV addSubview:view0];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(20, 20, kScreenWidth - 40, 50);
        btn.backgroundColor = DYGColorFromHex(0xfafafa);
        [btn setTitle:@"切换账号" forState:UIControlStateNormal];
        [btn setTitleColor:DYGColorFromHex(0x9b7000) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        btn.layer.borderColor = DYGColorFromHex(0xcccccc).CGColor;
        btn.layer.borderWidth = 1.0f;
        btn.layer.cornerRadius = 25;
        btn.layer.masksToBounds = YES;
        [btn addTarget:self action:@selector(changeAccount:) forControlEvents:UIControlEventTouchUpInside];
        [_footerV addSubview:btn];
    }
    return _footerV;
}

@end
