//
//  FXComplainReasonListViewController.m
//  zzl
//
//  Created by Mr_Du on 2017/12/23.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "FXComplainReasonListViewController.h"
#import "MyTextView.h"
#import "LSJComplainReasonCell.h"

@interface FXComplainReasonListViewController ()<UITextViewDelegate>
@property (nonatomic,strong) NSArray *dataArr;
@property (nonatomic,strong) MyTextView *textV;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,strong) UIView *popView;
@end

static NSString *const cellID = @"LSJComplainReasonCell";
@implementation FXComplainReasonListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.content = @"";
    self.title = @"申诉原因";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView registerClass:[LSJComplainReasonCell class] forCellReuseIdentifier:cellID];
    self.tableView.tableFooterView = [self addFooterView];
    [self loadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WwComplainReason *model = self.dataArr[indexPath.row];
    LSJComplainReasonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.titleL.text = model.reason;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView endEditing:YES];
    self.textV.text = nil;
    WwComplainReason *model = self.dataArr[indexPath.row];
    for (LSJComplainReasonCell *cell in tableView.visibleCells) {
        cell.iconBtn.selected = NO;
        self.content = model.reason;
    }
    LSJComplainReasonCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.iconBtn.selected = YES;
}

- (UIView *)addFooterView{
    UIView *BgView = [UIView new];
    BgView.frame = CGRectMake(0, 0, kScreenWidth, Py(230));
    BgView.backgroundColor = [UIColor whiteColor];
    
    UIView *tfView = [UIView new];
    tfView.frame = CGRectMake(Px(12), Py(20), kScreenWidth - Px(24), Py(150));
    tfView.backgroundColor = [UIColor whiteColor];
    tfView.layer.cornerRadius = 5;
    tfView.layer.shadowColor = DYGColorFromHex(0xececec).CGColor;
    tfView.layer.shadowOffset = CGSizeMake(0, 0);
    tfView.layer.shadowRadius = 5;
    tfView.layer.shadowOpacity = 1;
    [BgView addSubview:tfView];
    
    MyTextView *textV = [[MyTextView alloc] initWithFrame:CGRectMake(Px(18), Py(18), kScreenWidth - Px(60), Py(114))];
    _textV = textV;
    textV.placeholder = @"请输入申诉内容";
    textV.delegate = self;
    textV.placeholderColor = DYGColorFromHex(0x999999);
    [tfView addSubview:textV];
    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.backgroundColor = DYGColorFromHex(0xfed811);
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendBtn setTitle:@"提交申诉" forState:UIControlStateNormal];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    sendBtn.frame = CGRectMake(20, Py(200), Px(180), Py(30));
    sendBtn.layer.cornerRadius = Py(15);
    sendBtn.centerX = BgView.centerX;
    [sendBtn addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    [BgView addSubview:sendBtn];
    return BgView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Py(54);
}

- (void)loadData{
    [[WwUserInfoManager UserInfoMgrInstance] requestComplainReasonListWith:^(NSInteger code, NSString *msg, NSArray<WwComplainReason *> *list) {
        if (code == WwCodeSuccess) {
            self.dataArr = [WwComplainReason mj_objectArrayWithKeyValuesArray:list];
            [self.tableView reloadData];
        }
    }];
}

- (void)sendAction:(UIButton *)btn{
    [self.textV endEditing:YES];
    if (self.content.length > 0) {
        
        NSInteger reasonId = 0;
        for (WwComplainReason *model in self.dataArr) {
            if ([model.reason isEqualToString:self.content]) {
                reasonId = model.ID;
            }
        }
        
        [[WwUserInfoManager UserInfoMgrInstance] requestComplainGame:self.orderID reasonId:reasonId reason:self.content complete:^(NSInteger code, NSString *msg) {
            if (code == WwCodeSuccess) {
                [self addPopView];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshDetail" object:nil];
            }
        }];
    }else{
        [MBProgressHUD showMessage:@"请选择或输入申述内容" toView:self.tableView];
    }
}

#pragma mark UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    self.content = textView.text;
    for (LSJComplainReasonCell *cell in self.tableView.visibleCells) {
        cell.iconBtn.selected = NO;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    self.content = textView.text;
}

- (void)addPopView{
    self.popView = [UIView new];
    self.popView.frame = [UIScreen mainScreen].bounds;
    self.popView.backgroundColor = DYGAColor(0, 0, 0, 0.6);
    
    UIView *centerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Px(180), Py(150))];
    centerV.centerX = self.popView.centerX;
    centerV.centerY = self.popView.centerY;
    centerV.backgroundColor = [UIColor whiteColor];
    centerV.layer.cornerRadius = 10;
    [self.popView addSubview:centerV];
    
    UIImageView *centerIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_ss_success"]];
    [centerV addSubview:centerIcon];
    [centerIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(centerV).offset(Py(27));
        make.centerX.equalTo(centerV.mas_centerX);
    }];
    
    UILabel *titleL = [[UILabel alloc] init];
    titleL.text = @"申诉成功";
    titleL.font = [UIFont systemFontOfSize:17];
    titleL.textColor = DYGColorFromHex(0x3b3b3b);
    titleL.textAlignment = NSTextAlignmentCenter;
    [centerV addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(centerIcon.mas_bottom).offset(Py(25));
        make.centerX.equalTo(centerV.mas_centerX);
    }];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [sureBtn setBackgroundColor:DYGColorFromHex(0xfed811)];
    [sureBtn addTarget:self action:@selector(sure:) forControlEvents:UIControlEventTouchUpInside];
    [self.popView addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(centerV.mas_bottom).offset(Py(27));
        make.centerX.equalTo(self.popView.mas_centerX);
        make.width.equalTo(@(Px(120)));
        make.height.equalTo(@(Py(31)));
    }];
    sureBtn.layer.cornerRadius = Py(15.5);
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.popView];
}

- (void)sure:(UIButton *)sender{
    [self.popView removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
