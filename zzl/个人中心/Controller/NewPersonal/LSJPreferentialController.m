//
//  LSJPreferentialController.m
//  zzl
//
//  Created by Mr_Du on 2018/2/24.
//  Copyright © 2018年 Mr.Du. All rights reserved.
//

#import "LSJPreferentialController.h"
#import "MinePreferentialCell.h"
#import "LSJPreferentialModel.h"
#import "LSJRechargeViewController.h"

@interface LSJPreferentialController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
{
    NSInteger page;
}
@property (nonatomic,strong) UIView *topV;
@property (nonatomic,strong) UIView *lineV;
@property (nonatomic,strong) UIScrollView *myScrollV;
@property (nonatomic,strong) NSMutableArray *pageArray;
@property (nonatomic,strong) UITableView *currentTableV;
@property (nonatomic,strong) NSMutableArray *dataArray;
@end

static NSString *const cellID = @"MinePreferentialCell";
@implementation LSJPreferentialController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _pageArray = [@[@0,@0,@0] mutableCopy];
    page = 0;
    self.title = @"优惠券";
    self.view.backgroundColor = DYGColor(247, 247, 247);
    [self addChildView];
    [self loadNewData];
}

- (void)addChildView{
    self.topV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, Py(40))];
    self.topV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.topV];
    
    NSArray *titleArr = @[@"未使用",@"已使用",@"已过期"];
    CGFloat btnWidth = kScreenWidth/titleArr.count;
    for (int i = 0; i < titleArr.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * btnWidth, Py(5), btnWidth, Py(30));
        btn.tag = 100+i;
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:DYGColor(108, 108, 108) forState:UIControlStateNormal];
        [btn setTitleColor:DYGColor(217, 182, 0) forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(changeViews:) forControlEvents:UIControlEventTouchUpInside];
        [self.topV addSubview:btn];
        if (i == 0) {
            btn.selected = YES;
        }
    }
    _lineV = [[UIView alloc] initWithFrame:CGRectMake(0, Py(39), Px(60), Py(1))];
    _lineV.backgroundColor = DYGColor(217, 182, 0);
    UIButton *btn = [self.topV viewWithTag:100];
    _lineV.centerX = btn.centerX;
    [self.topV addSubview:_lineV];
    
    self.myScrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, Py(40), kScreenWidth, kScreenHeight - Py(40) - 64)];
    self.myScrollV.contentSize = CGSizeMake(kScreenWidth * titleArr.count, self.myScrollV.height);
    self.myScrollV.pagingEnabled = YES;
    self.myScrollV.delegate = self;
    [self.view addSubview:self.myScrollV];
    
    for (int i = 0; i < titleArr.count; i ++) {
        UITableView *tableV = [[UITableView alloc] initWithFrame:CGRectMake(kScreenWidth * i, 0, kScreenWidth, self.myScrollV.height) style:UITableViewStylePlain];
        tableV.delegate = self;
        tableV.dataSource = self;
        tableV.emptyDataSetSource = self;
        tableV.emptyDataSetDelegate = self;
        tableV.tag = 200+i;
        tableV.backgroundColor = DYGColorFromHex(0xf7f7f7);
        [tableV registerClass:[MinePreferentialCell class] forCellReuseIdentifier:cellID];
        tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableV.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        tableV.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        [self.myScrollV addSubview:tableV];
    }
    self.currentTableV = [self.view viewWithTag:200];
}

- (void)changeViews:(UIButton *)sender{
    NSInteger tag = sender.tag;
    page = tag - 100;
    self.currentTableV = [self.view viewWithTag:200 + page];
    for (UIView *subV in self.topV.subviews) {
        if ([subV isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)subV;
            if (btn.tag == tag) {
                btn.selected = YES;
                [UIView animateWithDuration:0.3 animations:^{
                    _lineV.centerX = btn.centerX;
                }];
                [self.myScrollV setContentOffset:CGPointMake((sender.tag-100)*kScreenWidth, 0) animated:YES];
            }else{
                btn.selected = NO;
            }
        }
    }
    [self refreshTableVWithPage:page];
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        return;
    }
    NSInteger i = (scrollView.contentOffset.x+ kScreenWidth * 0.5)/kScreenWidth;
    page = i;
    self.currentTableV = [self.view viewWithTag:200 + page];
    for (UIView *subV in self.topV.subviews) {
        if ([subV isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)subV;
            if (btn.tag == 100+i) {
                btn.selected = YES;
                [UIView animateWithDuration:0.3 animations:^{
                    _lineV.centerX = btn.centerX;
                }];
            }else{
                btn.selected = NO;
            }
        }
    }
    [self refreshTableVWithPage:i];
}

- (void)refreshTableVWithPage:(NSInteger)index{
    NSMutableArray *tempArr = self.dataArray[index];
    if (tempArr.count == 0) {
        [self loadNewData];
    }
}

#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSMutableArray *arr = self.dataArray[page];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LSJPreferentialModel *model = self.dataArray[page][indexPath.row];
    MinePreferentialCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (tableView.tag == 200) {
        cell.type = preferentialTypeGo;
    }else if (tableView.tag == 201){
        cell.type = preferentialTypeUsed;
    }else if (tableView.tag == 202){
        cell.type = preferentialTypePass;
    }
    [cell updateViewWithIcon:model.img_path title:model.title time:model.expire_time];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (page == 0) {
        LSJPreferentialModel *model = self.dataArray[0][indexPath.row];
        LSJRechargeViewController *rechargeVC = [[LSJRechargeViewController alloc] init];
        rechargeVC.model =model;
        [self.navigationController pushViewController:rechargeVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Py(95);
}

#pragma mark 请求优惠券数据
- (void)loadNewData{
    NSInteger currentPage = [self.pageArray[page] integerValue];
    currentPage = 0;
    [self.pageArray replaceObjectAtIndex:page withObject:@(currentPage)];
    [self loadDataWithPage:self.pageArray[page] index:page+1];
}
- (void)loadMoreData{
    NSInteger currentPage = [self.pageArray[page] integerValue];
    currentPage ++;
    [self.pageArray replaceObjectAtIndex:page withObject:@(currentPage)];
    [self loadDataWithPage:self.pageArray[page] index:page+1];
}
- (void)loadDataWithPage:(id)currentPage index:(NSInteger)index{
    NSString *path = @"Coupon";
    NSString *state = @"0";
    if (page == 0) {
        state = @"0";
    }else if (page == 1){
        state = @"1";
    }else{
        state = @"2";
    }
    NSDictionary *params = @{@"uid":KUID,@"state":state,@"index":@([currentPage integerValue]),@"num":@"20"};
    [DYGHttpTool postWithURL:path params:params sucess:^(id json) {
        NSDictionary *dic = (NSDictionary *)json;
        [self.currentTableV.mj_header endRefreshing];
        [self.currentTableV.mj_footer endRefreshing];
        if ([dic[@"code"] integerValue] == 200) {
            NSArray *tempArr = [NSArray array];
            tempArr = [LSJPreferentialModel mj_objectArrayWithKeyValuesArray:dic[@"data"]];
            if ([currentPage integerValue] == 0) {
                [self.dataArray[page] removeAllObjects];
            }
            if (tempArr.count < 20) {
                [self.currentTableV.mj_footer endRefreshingWithNoMoreData];
                self.currentTableV.mj_footer = nil;
            }else{
                self.currentTableV.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
            }
            NSMutableArray *indexArr = self.dataArray[page];
            [indexArr addObjectsFromArray:tempArr];
            [self.dataArray replaceObjectAtIndex:page withObject:indexArr];
            [self.currentTableV reloadData];
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
    [self refreshTableVWithPage:page];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -Py(103);
}

#pragma mark lazyload
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [@[[@[] mutableCopy],[@[] mutableCopy],[@[] mutableCopy]] mutableCopy];
    }
    return _dataArray;
}
@end
