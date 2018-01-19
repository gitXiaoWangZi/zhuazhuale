//
//  LSJWaWaDeliverController.m
//  zzl
//
//  Created by Mr_Du on 2018/1/18.
//  Copyright © 2018年 Mr.Du. All rights reserved.
//

#import "LSJWaWaDeliverController.h"
#import "FXSpoilsCell.h"

@interface LSJWaWaDeliverController ()<FXSpoilsCellDelegate>

@end

@implementation LSJWaWaDeliverController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView) name:@"kREFRESHTABLE" object:nil];
}

- (void)refreshView {
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    WwOrderModel *model = self.dataArray[section];
    return model.records.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * resueId = @"spolisCell";
    FXSpoilsCell * cell = [tableView dequeueReusableCellWithIdentifier:resueId];
    if (!cell) {
        cell = [[FXSpoilsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:resueId];
    }
    cell.delegate = self;
    cell.celltype = WawaList_Deliver;
    WwOrderModel *model = self.dataArray[indexPath.section];
    WwOrderItem *item = model.records[indexPath.row];
    cell.item = item;
    cell.indexPath = indexPath;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    WwOrderModel *model = self.dataArray[section];
    NSString *status = @"";
    switch (model.status) {/**< 快递状态，0发货准备中；1运送中；2已收货 */
        case 0:
            {
            status = @"发货准备中";
            }
            break;
        case 1:
        {
            status = @"运送中";
        }
            break;
        case 2:
        {
            status = @"已收货";
        }
            break;
        default:
            break;
    }
    UIView *headerV = [UIView new];
    headerV.backgroundColor = DYGColorFromHex(0xf5f5f5);
    
    UILabel *statusL = [[UILabel alloc] init];
    statusL.textColor = DYGColorFromHex(0x4d4d4d);
    statusL.font = kPingFangSC_Regular(12);
    statusL.text = status;
    [headerV addSubview:statusL];
    [statusL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerV).offset(Px(10));
        make.centerY.equalTo(headerV);
    }];
    
    UILabel *timeL = [[UILabel alloc] init];
    timeL.textColor = DYGColorFromHex(0x4d4d4d);
    timeL.font = kPingFangSC_Regular(12);
    timeL.text = model.dateline;
    [headerV addSubview:timeL];
    [timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(statusL.mas_right).offset(Px(5));
        make.centerY.equalTo(headerV);
    }];
    return headerV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return Py(20);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Py(94);
}

#pragma mark FXSpoilsCellDelegate
-(void)checkTheLogistics:(NSIndexPath *)indexPath{
    WwOrderModel *item = self.dataArray[indexPath.section];
    [[WwUserInfoManager UserInfoMgrInstance] requestExpressInfo:item.orderId complete:^(int code, NSString *message, WwExpressInfo *model) {
        if (code == WwCodeSuccess) {
            if (model.number.length == 0) {
                [MBProgressHUD showMessage:@"暂无物流信息" toView:self.tableView];
                return ;
            }else{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"jumpLogisticsVC" object:model];
            }
        }
    }];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
@end
