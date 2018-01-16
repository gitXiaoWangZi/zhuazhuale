//
//  FXRecordViewController.m
//  zzl
//
//  Created by Mr_Du on 2017/11/8.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "FXRecordViewController.h"
#import "FXRecordCell.h"
#import "FXGameDetailViewController.h"


@interface FXRecordViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) NSInteger currentPage;


@end

@implementation FXRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"游戏记录";
    self.view.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:self.tableView];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
//    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self loadNewData];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * reuserId = @"recordCell";
    FXRecordCell * cell = [tableView dequeueReusableCellWithIdentifier:reuserId];
    if (!cell) {
        cell = [[FXRecordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuserId];
    }
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Py(90);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FXGameDetailViewController *gameVC = [[FXGameDetailViewController alloc] init];
    gameVC.model = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:gameVC animated:YES];
}

- (void)loadNewData{
    _currentPage = 1;
    [self loadDataWithPage:_currentPage];
}

- (void)loadMoreData{
    _currentPage ++;
    [self loadDataWithPage:_currentPage];
}

#pragma mark 请求战绩数据
- (void)loadDataWithPage:(NSInteger)page{
    [[WwUserInfoManager UserInfoMgrInstance] requestGameHistoryAtPage:page complete:^(int code, NSString *message, NSArray<WwGameHistory *> *list) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSArray *tempArr = [WwGameHistory mj_objectArrayWithKeyValuesArray:list];
        if (page == 1) {
            [self.dataArray removeAllObjects];
        }
        if (tempArr.count < 20) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.dataArray addObjectsFromArray:tempArr];
        [self.tableView reloadData];
    }];
}

#pragma mark lazy load

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
        _tableView.backgroundColor = BGColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
