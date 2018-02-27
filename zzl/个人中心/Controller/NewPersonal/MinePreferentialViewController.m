//
//  MinePreferentialViewController.m
//  zzl
//
//  Created by Mr_Du on 2018/2/24.
//  Copyright © 2018年 Mr.Du. All rights reserved.
//

#import "MinePreferentialViewController.h"
#import "MinePreferentialCell.h"
#import "LSJPreferentialModel.h"

@interface MinePreferentialViewController ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
{
    NSInteger currentPage;
}
@property (nonatomic,strong) NSMutableArray *dataArray;
@end

static NSString *const cellID  = @"MinePreferentialCell";
@implementation MinePreferentialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"优惠券";
    currentPage = 0;
    self.tableView.backgroundColor = DYGColorFromHex(0xf7f7f7);
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    [self.tableView registerClass:[MinePreferentialCell class] forCellReuseIdentifier:cellID];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self loadNewData];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSJPreferentialModel *model = self.dataArray[indexPath.row];
    MinePreferentialCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell updateViewWithIcon:model.img_path title:model.title time:model.expire_time];
    cell.type = preferentialTypeNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Py(95);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LSJPreferentialModel *model = self.dataArray[indexPath.row];
    if (self.usePreferTialBlock) {
        self.usePreferTialBlock(model);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark 请求优惠券数据
- (void)loadNewData{
    currentPage = 0;
    [self loadDataWithPage:currentPage];
}
- (void)loadMoreData{
    currentPage ++;
    [self loadDataWithPage:currentPage];
}
- (void)loadDataWithPage:(NSInteger)currentPage{
        NSString *path = @"Coupon";
        NSDictionary *params = @{@"uid":KUID,@"state":@"0",@"index":@(currentPage),@"num":@"20"};
        [DYGHttpTool postWithURL:path params:params sucess:^(id json) {
            NSDictionary *dic = (NSDictionary *)json;
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            if ([dic[@"code"] integerValue] == 200) {
                NSArray *tempArr = [NSArray array];
                tempArr = [LSJPreferentialModel mj_objectArrayWithKeyValuesArray:dic[@"data"]];
                if (tempArr.count < 20) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
                }
                if (currentPage == 0) {
                    [self.dataArray removeAllObjects];
                }
                [self.dataArray addObjectsFromArray:tempArr];
                [self.tableView reloadData];
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
}

#pragma mark DZNEmptyDataSetSource,DZNEmptyDataSetDelegate
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"mine_empty_placeholder"];
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view
{
    [self loadNewData];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -Py(103);
}

#pragma mark lazyload
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
