//
//  DYGPopDetailView.m
//  zzl
//
//  Created by Mr_Du on 2017/11/2.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "DYGPopDetailView.h"
#import "FXGameWaitCell.h"
#import "FXTextDetailCell.h"
@interface DYGPopDetailView()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property(nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong) NSArray *titleArr;
@property (nonatomic,strong) NSMutableArray * dataArr;
@property (nonatomic,strong) NSMutableArray *picArr;
@property (nonatomic,strong) UIButton * coloseBtn;


@end

@implementation DYGPopDetailView

- (NSMutableArray *)picArr {
    if (!_picArr) {
        _picArr = [NSMutableArray array];
    }
    return _picArr;
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self creatCoverView];
    }
    return self;
}

-(void)creatCoverView{
    self.titleArr = @[@"娃娃名称",@"娃娃尺寸",@"面料",@"填充物",@"可兑换钻石"];
    self.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.4];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disMiss)];
    tap.delegate =self;
    [self addGestureRecognizer:tap];
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.mas_top).offset(Py(103));
        make.size.mas_equalTo(CGSizeMake(Px(350), Py(517)));
    }];
    [self addSubview:self.coloseBtn];
    [self.coloseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.tableView.mas_right).offset(-Px(22));
        make.bottom.equalTo(self.tableView.mas_top);
        make.size.mas_equalTo(CGSizeMake(Px(25), Py(53)));
    }];
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = BGColor;
        _tableView.cornerRadius = 5;
        _tableView.layer.masksToBounds = YES;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 40;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
-(UIButton *)coloseBtn{
    if (!_coloseBtn) {
        _coloseBtn = [UIButton buttonWithImage:@"delete_ready" WithHighlightedImage:@"delete_ready"];
        [_coloseBtn addTarget:self action:@selector(disMiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _coloseBtn;
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isDescendantOfView:self.tableView]) {
        return NO;
    }
    return YES;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return self.titleArr.count + self.picArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * reuseId ;
    if (indexPath.row<5) {
        reuseId = @"norCell";
        FXTextDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
        if (!cell) {
            cell = [[FXTextDetailCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:reuseId];
        }
        cell.title.text = self.titleArr[indexPath.row];
        if (self.dataArr.count != 0) {
            cell.subLabel.text = self.dataArr[indexPath.row];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        reuseId = @"imgCell";
        FXGameWaitCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
        if (!cell) {
            cell = [[FXGameWaitCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
        }
        [cell.bgImg sd_setImageWithURL:[NSURL URLWithString:self.picArr[indexPath.row - 5]] placeholderImage:[UIImage imageNamed:@"testImg"]];
        cell.bgImg.contentMode = UIViewContentModeScaleAspectFill;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * v = [UIView new];
    v.backgroundColor = [UIColor whiteColor];
    UILabel * label = [[UILabel alloc]init];
    label.text = self.model.wawa.name;
    label.textColor = DYGColorFromHex(0x555555);
    label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:19];
    [v addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(v.mas_left).offset(Px(13));
        make.centerY.equalTo(v);
    }];
    return v;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DYGLog(@"cell click");
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return Py(40);
}

-(void)disMiss{
    if ([self.delegate respondsToSelector:@selector(popViewDismiss)]) {
        [self.delegate popViewDismiss];
    }
}

- (void)setModel:(WwRoomModel *)model{
    _model = model;
    NSInteger wawaID = model.wawa.ID;
    
    [[WwGameManager GameMgrInstance] requestWawaInfo:wawaID complete:^(BOOL success, NSInteger code, WwWaWaDetailInfo *waInfo) {
        if (success) {
            [self.picArr removeAllObjects];
            [self.dataArr addObject:waInfo.name];
            [self.dataArr addObject:waInfo.size];
            [self.dataArr addObject:waInfo.material];
            [self.dataArr addObject:waInfo.filler];
            NSString *coins = [NSString stringWithFormat:@"%zd",waInfo.recoverCoin];
            [self.dataArr addObject:coins];
            NSArray *picUrls = [waInfo.detailPics componentsSeparatedByString:@","];
            for (NSString *url in picUrls) {
                [self.picArr addObject:url];
            }
            [self.tableView reloadData];
        }else{
            NSLog(@"%zd",code);
        }
    }];
    
}


@end
