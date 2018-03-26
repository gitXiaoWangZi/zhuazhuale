//
//  FXRechargeRecordContoller.m
//  zzl
//
//  Created by Mr_Du on 2017/11/8.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "FXRechargeRecordContoller.h"
#import "FXHistoryCell.h"
#import "FXHistoryHeader.h"
#import "FXRechargeRecordModel.h"
@interface FXRechargeRecordContoller ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong) FXHistoryHeader *header;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation FXRechargeRecordContoller

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"我的钻石";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewData) name:@"refreshUserData" object:nil];
    [self.view addSubview:self.tableView];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 70, 0);
    [self creatHeader];
    [self loadNewData];
}

-(void)creatHeader{
    self.header = [[FXHistoryHeader alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, Py(176))];
    self.header.money.text = self.moneyStr;
    self.tableView.tableHeaderView = self.header;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * reuserId = @"historyCell";
    FXHistoryCell * cell = [tableView dequeueReusableCellWithIdentifier:reuserId];
    if (!cell) {
        cell = [[FXHistoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuserId];
    }
    cell.model = self.dataArray[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Py(50);
}
#pragma mark lazy load
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = DYGColorFromHex(0xf7f7f7);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorColor = DYGColorFromHex(0xececec);
    }
    return _tableView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark 消费记录
- (void)loadNewData{
    _currentPage = 0;
    [self loadDataWithCurrentPage:_currentPage];
}

- (void)loadMoreData{
    _currentPage ++;
    [self loadDataWithCurrentPage:_currentPage];
}

- (void)loadDataWithCurrentPage:(NSInteger)page{
    NSString *path = @"RechargeRecord";
    NSDictionary *params = @{@"uid":KUID,@"index":@(page),@"num":@(20)};
    [DYGHttpTool postWithURL:path params:params sucess:^(id json) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSDictionary *dic = (NSDictionary *)json;
        if ([dic[@"code"] integerValue] == 200) {
            if (page == 0) {
                [self.dataArray removeAllObjects];
            }
            NSArray *tempArr = [FXRechargeRecordModel mj_objectArrayWithKeyValuesArray:dic[@"data"]];
            if (tempArr.count < 20) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            self.dataArray = [[self.dataArray arrayByAddingObjectsFromArray:tempArr] mutableCopy];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

@end
