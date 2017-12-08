//
//  FXCollecTBCell.m
//  zzl
//
//  Created by Mr_Du on 2017/11/8.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "FXCollecTBCell.h"
#import "FXSpoilsCell.h"
@interface FXCollecTBCell()<UITableViewDelegate,UITableViewDataSource>


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
    for (WwWawaDepositModel *model in self.dataArray) {
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
        WwWawaOrderModel *model = self.dataArray[section];
        return model.records.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * resueId = @"spolisCell";
    FXSpoilsCell * cell = [tableView dequeueReusableCellWithIdentifier:resueId];
    if (!cell) {
        cell = [[FXSpoilsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:resueId];
    }
    cell.isShow = self.isShow;
    if (self.colectType == WawaList_Deposit) {
        cell.model = self.dataArray[indexPath.row];
    }else{
        WwWawaOrderModel *model = self.dataArray[indexPath.section];
        WwWawaOrderItem *item = model.records[indexPath.row];
        cell.item = item;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if ([self.delegate respondsToSelector:@selector(cellDidClickWithIndexPath:)]) {
//        [self.delegate cellDidClickWithIndexPath:indexPath];
//    }
    FXSpoilsCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (self.colectType == WawaList_Deposit) {
        cell.isSelectBtn.selected = !cell.isSelectBtn.selected;
        WwWawaDepositModel *model = self.dataArray[indexPath.row];
        model.selected = cell.isSelectBtn.selected;
        
        [self.selectArray removeAllObjects];
        for (WwWawaDepositModel *model in self.dataArray) {
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
    return Py(90);
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

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
@end
