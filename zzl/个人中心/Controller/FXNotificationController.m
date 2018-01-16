//
//  FXNotificationController.m
//  zzl
//
//  Created by Mr_Du on 2017/11/8.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "FXNotificationController.h"
#import "FXNotificationCell.h"
@interface FXNotificationController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong) NSArray *dataArray;

@property(nonatomic,strong)UIView * defaultV;
@property(nonatomic,strong)UIImageView * defaultImgV;
@property(nonatomic,strong)UILabel * defaultL;
@end

@implementation FXNotificationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
    [self addDefaultV];
    [self.view addSubview:self.tableView];
    UIView *headerV = [UIView new];
    headerV.backgroundColor = DYGColorFromHex(0xf7f7f7);
    headerV.frame = CGRectMake(0, 0, kScreenWidth, Py(15));
    self.tableView.tableHeaderView = headerV;
    [self loadData];
}

- (void)addDefaultV{
    [self.tableView addSubview:self.defaultV];
    [self.defaultV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.tableView);
        make.centerX.equalTo(self.tableView);
        make.width.equalTo(@(Px(132)));
        make.height.equalTo(@(Py(100)));
    }];
    [self.defaultV addSubview:self.defaultImgV];
    [self.defaultImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.defaultV);
        make.centerX.equalTo(self.defaultV);
    }];
    [self.defaultV addSubview:self.defaultL];
    [self.defaultL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.defaultV);
        make.height.equalTo(@(Py(13)));
    }];
    self.defaultV.hidden = YES;
}

#pragma mark 请求消息数据
- (void)loadData{
    self.dataArray = @[@{@"icon":@"ddd",@"title":@"客服",@"msg":@"您的新人奖励已到账，请注意查收",@"time":@"2017-11-11"}];
    if (self.dataArray.count == 0) {
        self.defaultV.hidden = NO;
    }else{
        self.defaultV.hidden = YES;
    }
    [self.tableView reloadData];
}

#pragma mark tableview Delegae And DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * reuseId = @"notifiCell";
    FXNotificationCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[FXNotificationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    return cell;
}

#pragma mark lazy load
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = BGColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorColor =BGColor;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 200;
    }
    return _tableView;
}

- (UIView *)defaultV{
    if (!_defaultV) {
        _defaultV = [[UIView alloc] init];
        _defaultV.backgroundColor = [UIColor clearColor];
    }
    return _defaultV;
}
- (UIImageView *)defaultImgV{
    if (!_defaultImgV) {
        _defaultImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_msg_default"]];
    }
    return _defaultImgV;
}
- (UILabel *)defaultL{
    if (!_defaultL) {
        _defaultL = [[UILabel alloc] init];
        _defaultL.text = @"暂无消息";
        _defaultL.textColor = DYGColorFromHex(0x787878);
        _defaultL.font = [UIFont systemFontOfSize:15];
        _defaultL.textAlignment = NSTextAlignmentCenter;
    }
    return _defaultL;
}
@end
