//
//  LSJLogisticsPopView.m
//  zzl
//
//  Created by Mr_Du on 2018/1/17.
//  Copyright © 2018年 Mr.Du. All rights reserved.
//

#import "LSJLogisticsPopView.h"
#import "LSJLogisticsCell.h"

@interface LSJLogisticsPopView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UIView *centerV;
@property (nonatomic,strong) UIView *topV;
@property (nonatomic,strong) UIButton *disBtn;
@property (nonatomic,strong) UIButton *topBtn;
@property (nonatomic,strong) UILabel *titileL;
@property (nonatomic,strong) UILabel *companyL;
@property (nonatomic,strong) UILabel *numL;

@property (nonatomic,strong) UITableView *tableV;

@property (nonatomic,strong) NSArray *dataArr;


@end

static NSString *const cellID = @"cell";
@implementation LSJLogisticsPopView

- (NSArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSArray array];
    }
    return _dataArr;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = DYGAColor(0, 0, 0, 0.4);
        [self addChildView];
    }
    return self;
}

- (void)addChildView{
    
    [self addSubview:self.centerV];
    [self.centerV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@(Py(598.5)));
    }];
    [self addSubview:self.topBtn];
    [self.topBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.bottom.equalTo(self.centerV.mas_top);
    }];
    [self.centerV addSubview:self.topV];
    [self.topV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.centerV);
        make.height.equalTo(@(Py(62)));
    }];
    [self.topV addSubview:self.disBtn];
    [self.disBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topV).offset(10);
        make.right.equalTo(self.topV.mas_right).offset(-10);
    }];
    [self.topV addSubview:self.titileL];
    [self.titileL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topV).offset(Py(14));
        make.centerX.equalTo(self.topV);
    }];
    [self.centerV addSubview:self.tableV];
    [self.tableV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.centerV);
        make.top.equalTo(self.topV.mas_bottom);
    }];
    self.tableV.tableHeaderView = [self addHeaderV];
}

- (void)dismiss{
    if ([self.delegate respondsToSelector:@selector(dismissAction)]) {
        [self.delegate dismissAction];
    }
}

- (UIView *)addHeaderV{
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Px(258), Py(90))];
    headerV.backgroundColor = [UIColor whiteColor];
    
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_logistics_icon"]];
    [headerV addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerV).offset(Py(19));
        make.left.equalTo(headerV).offset(Px(38));
    }];
    
    UILabel *companyL = [[UILabel alloc] init];
    companyL.textColor = DYGColor(77, 77, 77);
    companyL.font = kPingFangSC_Regular(19);
    self.companyL = companyL;
    [headerV addSubview:companyL];
    [companyL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(icon.mas_right).offset(Px(21));
        make.top.equalTo(icon.mas_top);
        make.height.equalTo(@(Py(19)));
    }];
    UILabel *noL = [[UILabel alloc] init];
    noL.textColor = DYGColor(77, 77, 77);
    noL.font = kPingFangSC_Regular(19);
    self.numL = noL;
    [headerV addSubview:noL];
    [noL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(icon.mas_bottom);
        make.left.equalTo(companyL.mas_left);
        make.height.equalTo(@(Py(19)));
    }];
    
    return headerV;
}

#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WwExpressItem *item = self.dataArr[indexPath.row];
    LSJLogisticsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.time.text = item.time;
    cell.content.text = item.status;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark lazyload
- (UIButton *)topBtn{
    if (!_topBtn) {
        _topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _topBtn.backgroundColor = [UIColor clearColor];
        [_topBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topBtn;
}

- (UITableView *)tableV{
    if (!_tableV) {
        _tableV = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableV.backgroundColor = [UIColor whiteColor];
        _tableV.delegate = self;
        _tableV.dataSource = self;
        [_tableV registerClass:[LSJLogisticsCell class] forCellReuseIdentifier:cellID];
        _tableV.estimatedRowHeight = Py(100);
        _tableV.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableV;
}

- (UIView *)centerV{
    if (!_centerV) {
        _centerV = [UIView new];
        _centerV.backgroundColor = [UIColor whiteColor];
    }
    return _centerV;
}
- (UIView *)topV{
    if (!_topV) {
        _topV = [UIView new];
        _topV.backgroundColor = DYGColor(254, 216, 17);
    }
    return _topV;
}
- (UIButton *)disBtn{
    if (!_disBtn) {
        _disBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_disBtn setImage:[UIImage imageNamed:@"mine_logistics_dismiss"] forState:UIControlStateNormal];
        [_disBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _disBtn;
}
- (UILabel *)titileL{
    if (!_titileL) {
        _titileL = [[UILabel alloc] init];
        _titileL.textColor = [UIColor whiteColor];
        _titileL.font = kPingFangSC_Semibold(24);
        _titileL.textAlignment = NSTextAlignmentCenter;
        _titileL.text = @"物流详情";
    }
    return _titileL;
}

- (void)setModel:(WwExpressInfo *)model{
    _model = model;
    self.dataArr = model.list;
    self.companyL.text = model.company.length == 0 ? @"物流公司:暂无" : [NSString stringWithFormat:@"物流公司:%@",model.company];
    self.numL.text = model.number.length == 0 ? @"物流编号:暂无" : [NSString stringWithFormat:@"物流编号:%@",model.number];
    [self.tableV reloadData];
}
@end
