//
//  DYGPopViewMenu.m
//  zzl
//
//  Created by Mr_Du on 2017/11/1.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "DYGPopViewMenu.h"

@interface DYGPopViewMenu()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIView * coverView;
@property(nonatomic,strong)UITableView * tableView;

@end

@implementation DYGPopViewMenu

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self creatCoverView];
    }
    return self;
}
-(void)creatCoverView{
    self.clipsToBounds = YES;
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(@(Py(44*3)));
    }];
    self.coverView = [[UIView alloc]init];
    self.coverView.backgroundColor = [UIColor blackColor];
    self.coverView.alpha = 0.4;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disMiss)];
    [self.coverView addGestureRecognizer:tap];
    [self addSubview:self.coverView];
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom);
        make.left.right.equalTo(self);
        make.bottom.equalTo(self);
    }];
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = BGColor;
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArr.count;
//    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * reuseId = @"popCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    cell.textLabel.text = self.titleArr[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Py(44);
}
//-(void)setLineNum:(NSInteger)lineNum{
//    _lineNum = lineNum;
//    [self.tableView reloadData];
//}

-(void)setTitleArr:(NSArray *)titleArr{
    _titleArr = titleArr;
    [self.tableView reloadData];
}

#pragma mark delegate
-(void)disMiss{
    if ([self.delegate respondsToSelector:@selector(popViewDismissWithSelf:)]) {
        [self.delegate popViewDismissWithSelf:self];
    }
}
-(void)hidPopView{
    [UIView animateWithDuration:0.25 animations:^{
        self.tableView.y = -self.tableView.height;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)setIsHidPopView:(BOOL)isHidPopView{
    _isHidPopView = isHidPopView;
    [self hidPopView];
}

@end
