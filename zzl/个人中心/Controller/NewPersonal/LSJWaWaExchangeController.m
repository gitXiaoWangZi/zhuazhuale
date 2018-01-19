//
//  LSJWaWaExchangeController.m
//  zzl
//
//  Created by Mr_Du on 2018/1/18.
//  Copyright © 2018年 Mr.Du. All rights reserved.
//

#import "LSJWaWaExchangeController.h"
#import "FXSpoilsCell.h"

@interface LSJWaWaExchangeController ()

@end

@implementation LSJWaWaExchangeController

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
    cell.celltype = WawaList_Exchange;
    WwOrderModel *model = self.dataArray[indexPath.section];
    WwOrderItem *item = model.records[indexPath.row];
    cell.item = item;
    cell.indexPath = indexPath;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Py(94);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    WwOrderModel *model = self.dataArray[section];
    UIView *headerV = [UIView new];
    headerV.backgroundColor = DYGColorFromHex(0xf5f5f5);
    
    UILabel *statusL = [[UILabel alloc] init];
    statusL.textColor = DYGColorFromHex(0x4d4d4d);
    statusL.font = kPingFangSC_Regular(12);
    statusL.text = @"已兑换";
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

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

@end
