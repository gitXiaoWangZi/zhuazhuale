//
//  FXAddressManageController.m
//  zzl
//
//  Created by Mr_Du on 2017/11/6.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "FXAddressManageController.h"
#import "FXAddAddressController.h"
#import "FXBgView.h"
#import "FXAddressCell.h"
@interface FXAddressManageController ()<UITableViewDelegate,UITableViewDataSource,FXAddressCellDelegate>

@property(nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong) UIButton * addBtn;
@property (nonatomic,strong) NSArray *dataArr;
@end

@implementation FXAddressManageController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadAdressListData) name:@"refreshAddress" object:nil];
    self.title =@"收货地址管理";
    [self.view addSubview:self.tableView];
    [self creatFooter];
    self.tableView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadAdressListData)];
    [self loadAdressListData];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)creatHeader{
    FXBgView *bg = [[FXBgView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, Py(310))];
    self.tableView.tableHeaderView = bg;
}
-(void)creatFooter{
    UIView * footer = [UIView new];
    footer.backgroundColor = [UIColor whiteColor];
    footer.frame = CGRectMake(0, 0, kScreenWidth,Py(64));
    self.addBtn = [UIButton buttonWithTitle:@"添加收货地址" titleColor:DYGColorFromHex(0xfefefe) font:16];
    self.addBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    [self.addBtn setBackgroundColor:systemColor];
    [self.addBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    self.addBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -Px(8), 0, 0 );
    self.addBtn.cornerRadius = Py(22);
    self.addBtn.layer.masksToBounds = YES;
    [self.addBtn addTarget:self action:@selector(addAddress) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:self.addBtn];
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(footer);
        make.width.equalTo(@(kScreenWidth-Px(32)));
        make.height.equalTo(@(Py(44)));
        make.bottom.equalTo(footer);
    }];
    self.tableView.tableFooterView = footer;
}

#pragma mark 请求收货地址列表
- (void)loadAdressListData{
    self.dataArr = [NSArray array];
    [[WwUserInfoManager UserInfoMgrInstance] requestMyAddressListWithComplete:^(int code, NSString *message, NSArray<WwAddress *> *list) {
        [self.tableView.mj_header endRefreshing];
        self.dataArr = [WwAddress mj_objectArrayWithKeyValuesArray:list];
        if (self.dataArr.count==0) {
            [self creatHeader];
        }else{
            self.tableView.tableHeaderView = [UIView new];
        }
        [self.tableView reloadData];
    }];
}

#pragma mark tablview Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * reuseId =@"adressCell";
    WwAddress *model = self.dataArr[indexPath.row];
    FXAddressCell * cell =[tableView dequeueReusableCellWithIdentifier:reuseId];
    
    if (!cell) {
        cell = [[FXAddressCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
        cell.delegate = self;
        cell.indexPath = indexPath;
    }
    cell.model = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.isMine isEqualToString:@"yes"]) {//从战利品进来的
        WwAddress *model = self.dataArr[indexPath.row];
        if (self.getAddressModelBlock) {
            self.getAddressModelBlock(model);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}


-(void)addAddress{
//    [self.dataArr addObject:@"1"];
//    self.tableView.tableHeaderView = nil;
//    [self.tableView reloadData];
    FXAddAddressController * vc = [FXAddAddressController new];
    vc.isAdd = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark lazy load

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 100;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

#pragma mark FXAddressCellDelegate编辑删除地址处理
- (void)editAction:(NSIndexPath *)path{
    NSLog(@"编辑:%zd--%zd",path.section,path.row);
    WwAddressModel *model = self.dataArr[path.row];
    FXAddAddressController * vc = [FXAddAddressController new];
    vc.isAdd = NO;
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)deleteAction:(NSIndexPath *)path{
    NSLog(@"删除:%zd--%zd",path.section,path.row);
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"确定删除该地址" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction0 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *alertAction1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        WwAddress *model = self.dataArr[path.row];
        [[WwUserInfoManager UserInfoMgrInstance] requestDeleteAddress:model.ID complete:^(int code, NSString *message) {
            [self loadAdressListData];
        }];
    }];
    [alertVC addAction:alertAction0];
    [alertVC addAction:alertAction1];
    [self presentViewController:alertVC animated:YES completion:nil];
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
