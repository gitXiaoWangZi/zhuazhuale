//
//  BottomViewController.m
//  MyTabbar
//
//  Created by Mr_Du on 2017/12/28.
//  Copyright © 2017年 Mr.Liu. All rights reserved.
//

#import "BottomViewController.h"
#import "CaughtRecordTableViewCell.h"
#import "WawaInfoTableViewCell.h"
#import "WawaInfoHeaderView.h"
#import "FXGameWaitCell.h"
#import "FXGameWebController.h"
#import "LSJGameViewController.h"

@interface BottomViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIScrollView *scroV;
@property (weak, nonatomic) IBOutlet UIView *leftIcon;
@property (weak, nonatomic) IBOutlet UIView *rightIcon;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@property (nonatomic,strong) WawaInfoHeaderView *headerV;
@property (nonatomic,strong) NSArray *catchRecordArr;
@property (nonatomic,strong) NSArray *wawaPicArr;
@end

static NSString *const rightCellID = @"CaughtRecordTableViewCell";
static NSString *const leftCellID = @"WawaInfoTableViewCell";
@implementation BottomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showLeft];
    
    [self setUpChildView];
}

- (void)setUpChildView{
    self.scroV.bounces = NO;
    self.scroV.pagingEnabled = YES;
    self.scroV.delegate = self;
    self.scroV.showsHorizontalScrollIndicator = NO;
    self.scroV.contentSize = CGSizeMake((kScreenWidth - 20) * 2, kScreenHeight - 70);
    
    [self.scroV addSubview:self.leftTableV];
    [self.scroV addSubview:self.rightTableV];
    
    [self.leftTableV registerClass:[FXGameWaitCell class] forCellReuseIdentifier:leftCellID];
    [self.rightTableV registerNib:[UINib nibWithNibName:@"CaughtRecordTableViewCell" bundle:nil] forCellReuseIdentifier:rightCellID];
    self.rightTableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.headerV = [WawaInfoHeaderView shareInstance];
    self.headerV.frame = CGRectMake(0, 0, kScreenWidth, 160);
    self.leftTableV.tableHeaderView = self.headerV;
    self.view.backgroundColor = DYGColorFromHex(0xFEE354);
}

- (IBAction)leftAction:(UIButton *)sender {
    [self showLeft];
}

- (IBAction)rightAction:(UIButton *)sender {
    [self showRight];
}

//点击左按钮事件
- (void)showLeft{
    [self.leftBtn setAlpha:1];
    [self.rightBtn setAlpha:0.7];
    self.leftIcon.hidden = NO;
    self.rightIcon.hidden = YES;
    [self.scroV setContentOffset:CGPointMake(0, 0) animated:YES];
}

//点击右按钮事件
- (void)showRight{
    [self.leftBtn setAlpha:0.7];
    [self.rightBtn setAlpha:1];
    self.leftIcon.hidden = YES;
    self.rightIcon.hidden = NO;
    [self.scroV setContentOffset:CGPointMake(kScreenWidth - 20, 0) animated:YES];
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        return;
    }
    if (scrollView.contentOffset.x == 0) {
        [self showLeft];
    }else{
        [self showRight];
    }
}

#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 100) {
        return self.wawaPicArr.count;
    }
    return self.catchRecordArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 100) {
        FXGameWaitCell * cell = [tableView dequeueReusableCellWithIdentifier:leftCellID];
        if (!cell) {
            cell = [[FXGameWaitCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:leftCellID];
        }
        [cell.bgImg sd_setImageWithURL:[NSURL URLWithString:self.wawaPicArr[indexPath.row]] placeholderImage:[UIImage imageNamed:@"loginBG"]];
        cell.bgImg.contentMode = UIViewContentModeScaleAspectFit;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        CaughtRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rightCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        WwRoomCatchRecordItem *item = self.catchRecordArr[indexPath.row];
        [cell dataWithItem:item];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 100) {
        return 192;
    }
    return 67;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 100) {
        
    }else{
        [MobClick event:@"video"];
        FXGameWebController *webViewC = [[FXGameWebController alloc] init];
        webViewC.model = self.catchRecordArr[indexPath.row];
        [self.ganeViewC.navigationController pushViewController:webViewC animated:YES];
        if (self.diselectBlock) {
            self.diselectBlock();
        }
    }
}

#pragma mark lazyload
- (UITableView *)leftTableV{
    if (!_leftTableV) {
        _leftTableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 20, kScreenHeight - 90) style:UITableViewStylePlain];
        _leftTableV.tag = 100;
        _leftTableV.delegate = self;
        _leftTableV.dataSource = self;
        _leftTableV.backgroundColor = [UIColor whiteColor];
        _leftTableV.tableFooterView = [UIView new];
        _leftTableV.bounces = NO;
        _leftTableV.showsVerticalScrollIndicator = NO;
        _leftTableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _leftTableV;
}

- (UITableView *)rightTableV{
    if (!_rightTableV) {
        _rightTableV = [[UITableView alloc] initWithFrame:CGRectMake(kScreenWidth - 20, 0, kScreenWidth - 20, kScreenHeight - 90) style:UITableViewStylePlain];
        _rightTableV.tag = 101;
        _rightTableV.delegate = self;
        _rightTableV.dataSource = self;
        _rightTableV.backgroundColor = [UIColor whiteColor];
        _rightTableV.tableFooterView = [UIView new];
        _rightTableV.bounces = NO;
    }
    return _rightTableV;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

//抓中记录的数据处理
- (void)refrshCatchHistoryWithArr:(NSArray *)array{
    self.catchRecordArr = [NSArray arrayWithArray:array];
    [self.rightTableV reloadData];
}
//刷新娃娃详情的数据
- (void)refrshWaWaDetailsWithModel:(WwRoom *)model{
    
    NSInteger wawaID = model.wawa.ID;
    [[WwRoomManager RoomMgrInstance] requestWawaDetail:wawaID withComplete:^(NSInteger code, NSString *message, WwWaWaDetail *waInfo) {
        if (code == WwCodeSuccess) {
            [self.headerV refreshHeaderWithmodel:waInfo];
            self.wawaPicArr = [NSArray array];
            self.wawaPicArr = [waInfo.detailPics componentsSeparatedByString:@","];
            [self.leftTableV reloadData];
        }else{
            NSLog(@"%zd",code);
        }
    }];
    
}
@end
