//
//  LSJWaWaDepositController.m
//  zzl
//
//  Created by Mr_Du on 2018/1/18.
//  Copyright © 2018年 Mr.Du. All rights reserved.
//

#import "LSJWaWaDepositController.h"
#import "FXSpoilsCell.h"

@interface LSJWaWaDepositController ()

@end

@implementation LSJWaWaDepositController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView) name:@"kREFRESHTABLE" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(allAllSelectAction:) name:@"ORDERSELECT" object:nil];
    self.tableView.tableFooterView = [UIView new];
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

- (void)refreshView {
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * resueId = @"spolisCell";
    FXSpoilsCell * cell = [tableView dequeueReusableCellWithIdentifier:resueId];
    if (!cell) {
        cell = [[FXSpoilsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:resueId];
    }
    cell.celltype = WawaList_Deposit;
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FXSpoilsCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Py(94);
}

#pragma mark lazyload
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
