//
//  FXCollecTBCell.m
//  zzl
//
//  Created by Mr_Du on 2017/11/8.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "FXCollecTBCell.h"
#import "FXSpoilsCell.h"
#import "LSJLogisticsPopView.h"
@interface FXCollecTBCell()<UITableViewDelegate,UITableViewDataSource,FXSpoilsCellDelegate>

@property (nonatomic,strong) LSJLogisticsPopView *popView;
@end

@implementation FXCollecTBCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    [self addSubview:self.tableView];
     self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(allAllSelectAction:) name:@"ORDERSELECT" object:nil];
}

- (void)allAllSelectAction:(NSNotification *)noti{
    NSDictionary *dic = noti.object;
    if ([dic[@"isAllSelect"] isEqualToString:@"YES"]) {
        [self allRefreshData:YES];
    }else{
        [self allRefreshData:NO];
    }
}

- (void)allRefreshData:(BOOL)isSelect{
    [self.selectArray removeAllObjects];
    for (WwDepositItem *model in self.dataArray) {
        model.selected = isSelect;
        if (isSelect) {
            [self.selectArray addObject:model];
        }
    }
    [self.tableView reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.colectType == WawaList_Deposit) {
        return 1;
    }else{
        return self.dataArray.count;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.colectType == WawaList_Deposit) {
        return self.dataArray.count;
    }else{
        WwOrderModel *model = self.dataArray[section];
        return model.records.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * resueId = @"spolisCell";
    FXSpoilsCell * cell = [tableView dequeueReusableCellWithIdentifier:resueId];
    if (!cell) {
        cell = [[FXSpoilsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:resueId];
    }
    cell.delegate = self;
    cell.celltype = self.colectType;
    if (self.colectType == WawaList_Deposit) {
        cell.model = self.dataArray[indexPath.row];
    }else{
        WwOrderModel *model = self.dataArray[indexPath.section];
        WwOrderItem *item = model.records[indexPath.row];
        cell.item = item;
        cell.indexPath = indexPath;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FXSpoilsCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (self.colectType == WawaList_Deposit) {
        cell.isSelectBtn.selected = !cell.isSelectBtn.selected;
        WwDepositItem *model = self.dataArray[indexPath.row];
        model.selected = cell.isSelectBtn.selected;
        
        [self.selectArray removeAllObjects];
        for (WwDepositItem *model in self.dataArray) {
            if (model.selected) {
                [self.selectArray addObject:model];
            }
        }
        if (self.selectArray.count == self.dataArray.count) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"KClickCell" object:@{@"select":@"yes"}];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"KClickCell" object:@{@"select":@"no"}];
        }
    }
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

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = BGColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (NSMutableArray *)selectArray{
    if (!_selectArray) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}

- (LSJLogisticsPopView *)popView{
    if (!_popView) {
        _popView = [[LSJLogisticsPopView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _popView;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
@end
