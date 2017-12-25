//
//  FXGameDetailViewController.m
//  zzl
//
//  Created by Mr_Du on 2017/12/22.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "FXGameDetailViewController.h"
#import "FXGameDetailContentView.h"
#import "FXGameWebController.h"
#import "FXComplainReasonListViewController.h"

@interface FXGameDetailViewController ()<FXGameDetailContentViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollV;
@property (nonatomic,strong) FXGameDetailContentView *detailV;

@end

@implementation FXGameDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"游戏详情";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameAppealStateWithOrderID:) name:@"refreshDetail" object:nil];
    [self.view addSubview:self.myScrollV];
    [self.myScrollV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    self.detailV = [FXGameDetailContentView shareInstance];
    self.detailV.frame = CGRectMake(0, 0, kScreenWidth, 300+(kScreenWidth - 20));
    [self.myScrollV addSubview:self.detailV];
    self.myScrollV.contentSize = CGSizeMake(kScreenWidth, 300+(kScreenWidth - 20));
    [self.detailV reloadDataWithModel:self.model];
    self.detailV.delegate = self;
    [self gameAppealStateWithOrderID:self.model.orderId];
}

- (void)gameAppealStateWithOrderID:(NSString *)orderID {
    
    [[WawaSDK WawaSDKInstance].userInfoMgr requestComplainResultWithOrderID:self.model.orderId complete:^(int code, BOOL isComplain, NSString *message) {
        if (code == WwCodeSuccess) {
            [self.detailV updataComplainState:isComplain];
        }
    }];
}

- (UIScrollView *)myScrollV{
    if (!_myScrollV) {
        _myScrollV = [[UIScrollView alloc] init];
    }
    return _myScrollV;
}

#pragma mark-----FXGameDetailContentViewDelegate
- (void)jumpPageWithStatus:(NSInteger)status{
    if (status == 1) {//视频
        FXGameWebController *webv = [[FXGameWebController alloc] init];
        webv.orderId = self.model.orderId;
        [self.navigationController pushViewController:webv animated:YES];
    }else if (status == 2){//申诉
        FXComplainReasonListViewController *complain = [[FXComplainReasonListViewController alloc] init];
        complain.orderID = self.model.orderId;
        [self.navigationController pushViewController:complain animated:YES];
    }else{
        
    }
}

@end
