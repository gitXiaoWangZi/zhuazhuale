//
//  FXComplainReasonListViewController.m
//  zzl
//
//  Created by Mr_Du on 2017/12/23.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "FXComplainReasonListViewController.h"
#import "MyTextView.h"

@interface FXComplainReasonListViewController ()<UITextViewDelegate>
@property (nonatomic,strong) NSArray *dataArr;
@property (nonatomic,strong) MyTextView *textV;
@property (nonatomic,copy) NSString *content;
@end

@implementation FXComplainReasonListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.content = @"";
    self.title = @"申述";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellid"];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid" forIndexPath:indexPath];
    cell.textLabel.text = model.reason;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView endEditing:YES];
    self.textV.text = nil;
    WwComplainReason *model = self.dataArr[indexPath.row];
    for (UITableViewCell *cell in tableView.visibleCells) {
        cell.contentView.backgroundColor = [UIColor whiteColor];
        self.content = model.reason;
    }
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.contentView.backgroundColor = DYGColorFromHex(0xFFD700);
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *BgView = [UIView new];
    BgView.frame = CGRectMake(0, 0, kScreenWidth, 160);
    BgView.backgroundColor = [UIColor whiteColor];
    
    MyTextView *textV = [[MyTextView alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, 80)];
    _textV = textV;
    textV.placeholder = @"请输入申诉内容";
    textV.delegate = self;
    textV.placeholderColor = DYGColorFromHex(0x999999);
    textV.layer.cornerRadius = 4;
    textV.layer.borderColor = DYGColorFromHex(0xFFD700).CGColor;
    textV.layer.borderWidth = 1.f;
    [BgView addSubview:textV];
    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.backgroundColor = DYGColorFromHex(0xFFD700);
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    sendBtn.frame = CGRectMake(20, 100, kScreenWidth - 40, 40);
    sendBtn.layer.cornerRadius = 4;
    [sendBtn addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    [BgView addSubview:sendBtn];
    return BgView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 160;
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
                [MBProgressHUD showMessage:@"发送成功" toView:self.tableView];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshDetail" object:nil];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
        }];
    }else{
        [MBProgressHUD showMessage:@"请选择或输入申述内容" toView:self.tableView];
    }
}

#pragma mark UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    self.content = textView.text;
    for (UITableViewCell *cell in self.tableView.visibleCells) {
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    self.content = textView.text;
}
@end
