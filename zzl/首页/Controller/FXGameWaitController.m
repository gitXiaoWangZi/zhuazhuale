//
//  FXGameWaitController.m
//  zzl
//
//  Created by Mr_Du on 2017/11/2.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "FXGameWaitController.h"
#import "FXTabBarController.h"
#import "BulletView.h"
#import "BulletManager.h"
#import "BulletBackgroudView.h"
#import "FXOnlineView.h"
#import "FXGameWaitCell.h"
#import "DYGPersonInfoTbCell.h"
#import "DYGPopDetailView.h"
#import "FXCommentView.h"
#import "FXRechargeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "FXLoginHomeController.h"
#import "ZYPlayOperationView.h"
#import "ZYCountDownView.h"
#import "FXLatesRecordModel.h"//最近抓中数据模型
#import "FXGameWebController.h"//加载视频页面
#import "AccountItem.h"
#import "FXGameResultView.h"
#import "FXSpoilsController.h"
#import "UIButton+Position.h"
#import "FXNavigationController.h"

@interface FXGameWaitController ()<UITableViewDelegate,UITableViewDataSource,DYGPopDetailViewDelegate,DYGOnlineCommentDelegate,UITextFieldDelegate,AVAudioPlayerDelegate,WwGameManagerDelegate,ZYPlayOperationViewDelegate,ZYCountDownViewDelegate,FXCommentViewDelegate,FXGameResultViewDelegate>
{
    int num;
}
@property (nonatomic,strong) MBProgressHUD *hud;
@property (nonatomic, strong) BulletManager *bulletManager;//弹幕
@property (nonatomic, strong) BulletBackgroudView *bulletBgView;//弹幕背景
@property (nonatomic,strong) FXOnlineView *onlineView;//头部
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) DYGPopDetailView *popView;
@property (nonatomic,strong) FXCommentView *comment;//键盘
@property (nonatomic,assign) int commentBtnStatue;
@property (nonatomic,assign) int musicBtnStatue;
@property (nonatomic,strong) AVAudioPlayer * player;
@property (nonatomic,strong) FXGameResultView *resultPopView;

@property (nonatomic,strong) UIView *playView;//视频view
@property (nonatomic, strong) ZYPlayOperationView *playOperationBar;/**< 游戏操作视图*/
@property (nonatomic, strong) ZYCountDownView *countDownV;          /**< 倒计时视图*/

@property (nonatomic,strong) NSMutableArray *dataArray;//抓中娃娃记录数据数组
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) dispatch_source_t timer0;

@end

@implementation FXGameWaitController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(musicBtnSwitch:) name:@"musicBtnDidClick" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(bulletBtnSwtich:) name:@"bulletBtnDidClick" object:nil];
    if (self.player && self.player.isPlaying) {
        [self.player play];
    } else {
        if (self.musicBtnStatue == 2) {
            [self.player play];
        }else{
            [self.player pause];
        }
    }
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"musicBtnDidClick" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"bulletBtnDidClick" object:nil];
    [self.player stop];
    
    [self.timer invalidate];
    self.timer = nil;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = DYGRandomColor;
    self.title = @"抓抓乐";
    [self.view addSubview:self.tableView];
    self.commentBtnStatue = 1;
    self.musicBtnStatue = 1;
    [self setMusicPayer];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.onlineView = [[FXOnlineView alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth-20, kScreenHeight * 0.77 + 80)];
    self.onlineView.roomID = self.model.ID;
    self.onlineView.delegate = self;
    self.tableView.tableHeaderView = self.onlineView;
    
    // 添加倒计时视图
    [self.onlineView.defaultPlayView addSubview:self.countDownV];
    [self.countDownV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-20));
        make.bottom.equalTo(@(-50));
        make.width.height.equalTo(@(40));
    }];
    //添加视频View
    [self configRtcPlayer];
    
    //请求最近抓中记录数据
    [self loadLatesRecordData];
    //请求用户信息
    [self loadUserInfoData];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self creaetBarrage];
    [self.bulletManager start];
    
}

- (void)configRtcPlayer{
    _hud = [MBProgressHUD showHUDAddedTo:self.onlineView.defaultPlayView animated:YES];
    _hud.mode = MBProgressHUDModeCustomView;
    UIImageView *imageV= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"game_load"]];
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    anima.toValue = @(M_PI * 2);
    anima.duration = 1.0f;
    anima.repeatCount = 50;
    [imageV.layer addAnimation:anima forKey:nil];
    _hud.customView = imageV;
    _hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    _hud.bezelView.color = [UIColor colorWithWhite:0.0 alpha:1];
    _hud.animationType = MBProgressHUDAnimationFade;
    _hud.backgroundColor = [UIColor clearColor];
    [WwGameManager GameMgrInstance].delegate = self;
    
    //添加视频流View
    self.playView = [[WwGameManager GameMgrInstance] enterRoomWith:self.model];
    self.playView.hidden = YES;
    if (self.playView) {
        [self.playView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin];
        [self.onlineView.defaultPlayView insertSubview:self.playView atIndex:0];
    } else {
        // 进入房间失败了
        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:nil message:@"进入房间失败" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self popToView];
        }];
        [alertVC addAction:action];
        [self.navigationController presentViewController:alertVC animated:YES completion:nil];
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelKey)];
    [self.playView addGestureRecognizer:tap];
}

- (void)cancelKey{
    [self.view endEditing:YES];
}

#pragma mark ---请求用户信息数据
- (void)loadUserInfoData{
    
    [self.onlineView.price setTitle:[NSString stringWithFormat:@"x%zd",self.model.wawa.coin] forState:UIControlStateNormal];
    NSString *path = @"getUserInfo";
    NSDictionary *params = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KUser_ID]};
    [DYGHttpTool postWithURL:path params:params sucess:^(id json) {
        NSDictionary *dic = (NSDictionary *)json;
        if ([dic[@"code"] intValue] == 200) {
            AccountItem *item = [AccountItem mj_objectWithKeyValues:dic[@"data"][0]];
            self.onlineView.balance.text = [NSString stringWithFormat:@"我的钻石:%@",item.money];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark ---请求最近抓中记录数据
- (void)loadLatesRecordData{
    [[WwRoomManager RoomMgrInstance] requestCatchHistory:self.model.ID atPage:1 withComplete:^(NSInteger code, NSString *message, NSArray<WwRoomCatchRecordItem *> *list) {
        for (WwRoomCatchRecordItem *info in list) {
            FXLatesRecordModel *model = [[FXLatesRecordModel alloc] init];
            model.userIcon = info.user.portrait;
            model.userName = info.user.nickname;
            model.orderId = info.orderId;
            [self.dataArray addObject:model];
        }
        [self.tableView reloadData];
    }];
}

#pragma mark --- 对视频View进行约束（三方代理方法）
- (void)onMasterStreamReady{
    
    self.playView.backgroundColor = DYGColorFromHex(0xffea00);
    self.playView.frame = CGRectMake(0, 0, self.onlineView.defaultPlayView.width, self.onlineView.defaultPlayView.height);

    self.playView.layer.cornerRadius = 10;
    self.playView.layer.masksToBounds = YES;
    self.playView.hidden = NO;
    [_hud hideAnimated:YES];
}

-(void)setMusicPayer{
    NSURL * url = [[NSBundle mainBundle]URLForResource:@"gameWait.mp3" withExtension:nil];
    self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    self.player.numberOfLoops = -1;
    self.player.delegate = self;
    [self.player play];
}
-(void)creaetBarrage{
    self.bulletManager = [[BulletManager alloc] init];
    self.bulletManager.allComments = @[@" "].mutableCopy;
    __weak FXGameWaitController *myself = self;
    self.bulletManager.generateBulletBlock = ^(BulletView *bulletView) {
        [myself addBulletView:bulletView];
    };
}
#pragma mark lazy load
- (BulletBackgroudView *)bulletBgView {
    if (!_bulletBgView) {
        _bulletBgView = [[BulletBackgroudView alloc] init];
        _bulletBgView.frame = CGRectMake(10, 110, kScreenWidth-20, self.onlineView.bounds.size.height - 110);
        _bulletBgView.backgroundColor = [UIColor clearColor];
        _bulletBgView.clipsToBounds = YES;
        [self.onlineView addSubview:_bulletBgView];
    }
    return _bulletBgView;
}

- (void)addBulletView:(BulletView *)bulletView {
    bulletView.frame = CGRectMake(CGRectGetWidth(self.view.frame)+50, 20 + 34 * bulletView.trajectory, CGRectGetWidth(bulletView.bounds), CGRectGetHeight(bulletView.bounds));
    [self.bulletBgView addSubview:bulletView];
    [bulletView startAnimation];
}

- (ZYPlayOperationView *)playOperationBar {
    if (!_playOperationBar) {
        _playOperationBar = [ZYPlayOperationView operationView];
        _playOperationBar.hidden = NO;
        CGFloat height = kScreenHeight * 0.23;
        _playOperationBar.backgroundColor = [UIColor clearColor];
        CGRect rect = CGRectMake(0, kScreenHeight - height, kScreenWidth, height);
        _playOperationBar.frame = rect;
        _playOperationBar.delegate = self;
    }
    return _playOperationBar;
}

// 倒计时
- (UIView *)countDownV {
    if (!_countDownV) {
        _countDownV = [[ZYCountDownView alloc] init];
        _countDownV.hidden = YES;
        _countDownV.delegate = self;
    }
    return _countDownV;
}

#pragma mark  tableView Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2+self.dataArray.count;
}
-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * resuerId;
    if (indexPath.row<2) {
        resuerId = @"imgCell";
        FXGameWaitCell * cell = [tableView dequeueReusableCellWithIdentifier:resuerId];
        if (!cell) {
            cell = [[FXGameWaitCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:resuerId];
        }
        cell.bgImg.image =[UIImage imageNamed:@"geme_wawaShow"];
        if (indexPath.row==1) {
            cell.bgImg.image = [UIImage imageNamed:@"videoImg"];
        }
        return cell;
    }else{
        
        FXLatesRecordModel *model = self.dataArray[indexPath.row - 2];
        DYGPersonInfoTbCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"perCell" forIndexPath:indexPath];
        
        cell.nickNameL.text = model.userName;
        [cell.iconImgV sd_setImageWithURL:[NSURL URLWithString:model.userIcon] placeholderImage:[UIImage imageNamed:@"talk"]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.player.isPlaying) {
        self.musicBtnStatue = 2;
    } else {
        self.musicBtnStatue = 1;
    }
    if (indexPath.row==0) {
        [MobClick event:@"goods_details"];
        self.popView = [[DYGPopDetailView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight)];
        self.popView.model = self.model;
        self.popView.delegate = self;
        [self.view.window addSubview:self.popView];
        [UIView animateWithDuration:0.25 animations:^{
            self.popView.y = 0;
        }];
    }
    if (indexPath.row > 1) {
        [MobClick event:@"video"];
        FXGameWebController *webViewC = [[FXGameWebController alloc] init];
        webViewC.model = self.dataArray[indexPath.row - 2];
        [self.navigationController pushViewController:webViewC animated:YES];
    }
}
#pragma mark Notification Selector

-(void)musicBtnSwitch:(NSNotification *)notification{
    [self pause];
    
}
-(void)bulletBtnSwtich:(NSNotification *)notification{
    NSDictionary * dic = notification.userInfo;
    NSString * open = [NSString stringWithFormat:@"%@",dic[@"open"]];
    open.intValue ==1?[self stopScroll]:[self start];
}

-(void)start{
    [self creaetBarrage];
    [self.bulletManager start];
    self.bulletBgView.hidden = NO;
}
-(void)stopScroll{
    [self.bulletManager stop];
    self.bulletBgView.hidden = YES;
}

#pragma mark music switch

-(void)play{
    [self.player play];
}
-(void)pause{
    if (self.player.isPlaying) {
        [self.player pause];
    } else {
        [self.player play];
    }
}
-(void)stop{
    [self.player stop];
    self.player.currentTime = 0;
}

-(void)rechargeBtnDidClick{
    if (self.player.isPlaying) {
        self.musicBtnStatue = 2;
    } else {
        self.musicBtnStatue = 1;
    }
    [MobClick event:@"game_pay"];
    FXRechargeViewController * vc = [[FXRechargeViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)cameraBtnDidClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    [[WwGameManager GameMgrInstance] cameraSwitchIsFront:!sender.selected];
    self.playOperationBar.cameraDir = sender.selected ? CameraDirection_Right : CameraDirection_Front;
}

-(void)popToView{
    //销毁房间, 离开房间时务必调用, 否则会影响之后的逻辑
    [[WwGameManager GameMgrInstance] exitRoom];
    [self.player stop];
    
    [self.timer invalidate];
    self.timer = nil;
    if (_timer0) {
        dispatch_source_cancel(_timer0);
        _timer0 = nil;
    }
//    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kQuitEnter"]) {
//        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kQuitEnter"];
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }else{
//        [self.navigationController popViewControllerAnimated:YES];
//    }
}

#pragma mark--点击开始游戏按钮
- (void)playGameAction {
    NSString *path = @"userMoney";
    NSDictionary *params = @{@"uid":KUID};
    [DYGHttpTool postWithURL:path params:params sucess:^(id json) {
        NSDictionary *dic = (NSDictionary *)json;
        if ([dic[@"code"] integerValue] == 200) {
            if ([dic[@"data"] intValue] >= self.model.wawa.coin) {
                [self playGame];
            }else{
                [MBProgressHUD showError:@"余额不足" toView:self.view];
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)playGame{
    if (!self.playOperationBar.superview) {
        [self.view addSubview:self.playOperationBar];
    }
    self.playOperationBar.hidden = YES;
    
    @weakify(self);
    [[WwGameManager GameMgrInstance] requestStartGameWithComplete:^(NSInteger code, NSString *msg, NSString *orderID) {
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            
            if (code == WwCodeSuccess) {
                self.playOperationBar.hidden = NO;
                self.countDownV.hidden = NO;
                [self.countDownV updateProgressTimer:30];
                
                //游戏开始 页面不可以滑动并置顶
                self.tableView.scrollEnabled = NO;
                [self.tableView setContentOffset:CGPointMake(0, -20)];
            }else{
                self.playOperationBar.hidden = YES;
                UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"上机结果"
                                                                                  message:msg
                                                                           preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定"
                                                                  style:UIAlertActionStyleDefault
                                                                handler:nil];
                [alertVC addAction:action];
                [self.navigationController presentViewController:alertVC
                                                        animated:YES
                                                      completion:nil];
            }
        });
    }];
}

#pragma mark - ZYCountDownViewDelegate
- (void)zyTimerFinish {
    [self clawAction];
}

#pragma mark - ZYPlayOperationViewDelegate
- (void)changePerspective:(BOOL)isSelect{
    
}

- (void)onPlayDirection:(PlayDirection)direction operationType:(PlayOperationType)type {
    NSMutableString *string = [NSMutableString stringWithFormat:@"单击事件，"];
    switch (type) {
        case PlayOperationType_LongPress:
            string = [NSMutableString stringWithFormat:@"长压事件，"];
            break;
        case PlayOperationType_Click:
            string = [NSMutableString stringWithFormat:@"单击事件，"];
            break;
        case PlayOperationType_Release:
            string = [NSMutableString stringWithFormat:@"释放事件，"];
            break;
        case PlayOperationType_Reverse:
            string = [NSMutableString stringWithFormat:@"撤销事件，"];
            break;
        default:
            break;
    }
    
    switch (direction) {
        case PlayDirection_Up: {
            [string appendString:@"方向 ↑"];
        }
            break;
        case PlayDirection_Down: {
            [string appendString:@"方向 ↓"];
        }
            break;
        case PlayDirection_Left: {
            [string appendString:@"方向 ←"];
        }
            break;
        case PlayDirection_Right: {
            [string appendString:@"方向 →"];
        }
            break;
        case PlayDirection_Confirm: {
            [string appendString:@"下抓"];
        }
            break;
        default:
            break;
    }
    
    if (direction == PlayDirection_Confirm) {
        [self clawAction];
    } else {
        [[WwGameManager GameMgrInstance] requestOperation:direction operationType:type withComplete:^(NSInteger code, NSString *msg) {
            NSString * result = [NSString stringWithFormat:@"%@ %@",string,code == WwCodeSuccess ? @"成功" : @"失败"];
            NSLog(@"WwSDKOperation:%@",result);
        }];
    }
}

- (void)clawAction {
    self.countDownV.status = ZYCountDownStatusRequestResultIng;
    [[WwGameManager GameMgrInstance] requestClawWithForceRelease:NO withComplete:^(NSInteger code, NSString *msg, WwGameResult *resultM) {
        //游戏结束 页面可以滑动
        self.tableView.scrollEnabled = YES;
        
        if (resultM.state == 2) {
            [self showResultPopViewWithResult:YES];
        } else {
            [self showResultPopViewWithResult:NO];
        }
        safe_async_main((^{
            self.countDownV.status = ZYCountDownStatusCountDown;
            self.countDownV.hidden = YES;
            self.playOperationBar.hidden = YES;
        }));
    }];
                                                            
}

- (void)showResultPopViewWithResult:(BOOL)isSuccess{
    if (isSuccess) {
        [self loadgetWaWaSuccessData];
    }
    [self loadPlayGameSuccessData];
    //通知个人中心 更新钻石数量
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshUserData" object:nil];
    [self loadUserInfoData];
    
    self.resultPopView = [[FXGameResultView alloc] initWithFrame:self.view.bounds];
    self.resultPopView.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.4];
    self.resultPopView.delegate = self;
    [self.tableView addSubview:self.resultPopView];
    
    [self countDownAction];
}

- (void)countDownAction{
    num = 6;
    // 获取全局队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // 创建定时器
    __block dispatch_source_t timer0 = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    _timer0 = timer0;
    dispatch_time_t start = dispatch_walltime(NULL, 0);
    
    // 重复间隔
    uint64_t interval = (uint64_t)(1.0 * NSEC_PER_SEC);
    
    // 设置定时器
    dispatch_source_set_timer(timer0, start, interval, 0);
    
    // 设置需要执行的事件
    dispatch_source_set_event_handler(timer0, ^{
        
        //在这里执行事件
        NSLog(@"%ld", (long)num);
        num--;
        
        dispatch_async(dispatch_get_main_queue(), ^{
//            self.resultPopView.cornerL.text = [NSString stringWithFormat:@"%zd",num];
        });
        
        if (num == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.resultPopView removeFromSuperview];
            });
            NSLog(@"end");
            // 关闭定时器
            dispatch_source_cancel(timer0);
            timer0 = nil;
        }
    });
    // 开启定时器
    dispatch_resume(timer0);
}

#pragma mark 玩游戏成功后的接口
- (void)loadPlayGameSuccessData{
    NSString *path = @"raw_award";
    NSDictionary *params = @{@"uid":KUID,@"type":@"march_game"};
    [DYGHttpTool postWithURL:path params:params sucess:^(id json) {
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark 抓到娃娃成功后的接口
- (void)loadgetWaWaSuccessData{
    NSString *path = @"raw_award";
    NSDictionary *params = @{@"uid":KUID,@"type":@"catch_baby"};
    [DYGHttpTool postWithURL:path params:params sucess:^(id json) {
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark FXGameResultViewDelegate -- 领取操作和再次游戏操作
- (void)receiveWawaAction{
    NSLog(@"领取操作");
    dispatch_source_cancel(_timer0);
    _timer0 = nil;
    FXSpoilsController *spoilsVC = [[FXSpoilsController alloc] init];
    [self.navigationController pushViewController:spoilsVC animated:YES];
}

- (void)gameAgainAction{
    NSLog(@"再次游戏");
    dispatch_source_cancel(_timer0);
    _timer0 = nil;
    [self.timer invalidate];
    self.timer = nil;
    [self.resultPopView removeFromSuperview];
    [self playGameAction];
}

#pragma mark commentView pop

-(void)commentViewPop{
    if (self.commentBtnStatue ==1) {
        self.comment = [[FXCommentView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, Py(80))];
        self.comment.backgroundColor = [UIColor whiteColor];
        self.comment.delegate = self;
        self.comment.commentTF.delegate = self;
        [self.view addSubview:self.comment];
        [self.comment.commentTF becomeFirstResponder];
    }
    
}
- (void)keyboardWillShow:(NSNotification *)notification {
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    self.commentBtnStatue = 0;
    DYGLog(@"%f",kbHeight);
    CGFloat offset = kbHeight+Py(80);
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    if(offset > 0) {
        [UIView animateWithDuration:duration animations:^{
            self.comment.y = kScreenHeight-offset;
        }];
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
#pragma mark ---- 当键盘消失后，视图需要恢复原状
- (void)keyboardWillHide:(NSNotification *)notify {
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    self.commentBtnStatue = 1;
    [UIView animateWithDuration:duration animations:^{
        self.comment.y = kScreenHeight;
    } completion:^(BOOL finished) {
        [self.comment removeFromSuperview];
    }];
}
-(void)popViewDismiss{
    
    [UIView animateWithDuration:0.25 animations:^{
        self.popView.y = kScreenHeight;
        self.popView.alpha=0;
    } completion:^(BOOL finished) {
        [self.popView removeFromSuperview];
    }];
}

#pragma mark --FXCommentViewDelegate
- (void)sendClick{
    if (self.comment.commentTF.text != nil && ![self.comment.commentTF.text isEqualToString:@""]) {
        [[WwGameManager GameMgrInstance] sendDamuMsg:self.comment.commentTF.text];
    }
    self.comment.commentTF.text = nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row>1) {
        return Py(75);
    }else{
        return Py(130);
    }
}

#pragma mark lazy load
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -20, kScreenWidth, kScreenHeight+20) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = YES;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"ffea00" alpha:1];
        [_tableView registerNib:[UINib nibWithNibName:@"DYGPersonInfoTbCell" bundle:nil] forCellReuseIdentifier:@"perCell"];
        _tableView.separatorColor = BGColor;
    }
    return _tableView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark---WwGameManagerDelegate实现一些回调方法
/**< 房间观众列表变更回调, 每次均会回调当前请求到的全部的用户列表*/
- (void)audienceListDidChanged:(NSArray <WwUser *>*)array{
    NSLog(@"全部的用户列表----%@",array);
    if (self.onlineView.dataArray.count > 0) {
        [self.onlineView.dataArray removeAllObjects];
    }
    for (WwUser *model in array) {
        [self.onlineView.dataArray addObject:model];
    }
    NSString *num = [NSString stringWithFormat:@"%zd人围观",array.count];
    [self.onlineView.peopleNum setTitle:num forState:UIControlStateNormal];
    [self.onlineView.peopleNum xm_setImagePosition:XMImagePositionRight titleFont:[UIFont systemFontOfSize:10] spacing:10];
    [self.onlineView.collectionView reloadData];
}

/**< 收到聊天回调*/
- (void)reciveRemoteMsg:(WwChatMessage *)chatM{
    NSLog(@"收到聊天回调----%@",chatM);
    NSMutableArray *msgArray = [NSMutableArray array];
    WwUser *model = chatM.fromUser;
    NSString *msg = [NSString stringWithFormat:@"%@:%@",model.nickname,chatM.content];
    if (![msg isEqualToString:@""] && msg != nil) {
        [msgArray addObject:msg];
        self.bulletManager.comments = [msgArray mutableCopy];
    }
}

/**< 收到 房间状态更新*/
- (void)reciveRoomUpdateData:(WwRoomDataMessage *)liveData{
    NSLog(@"收到 房间状态更新--%@",liveData);
    if (liveData.state >= 3 && liveData.state <= 6) {
        WwUser *model = liveData.user;
        self.onlineView.model = model;
        self.onlineView.gameState.text = @"玩家游戏中";
        self.onlineView.playView.userInteractionEnabled = NO;
    }else if (liveData.state == 2){
        self.onlineView.model = nil;
        self.onlineView.gameState.text = @"开始游戏";
        self.onlineView.playView.userInteractionEnabled = YES;
    }else if (liveData.state <= 0){
        self.onlineView.gameState.text = @"机器维护中";
        self.onlineView.playView.userInteractionEnabled = NO;
    }else{
        
    }
}

/**< 房间内收到 抓娃娃结果通知*/
- (void)reciveClawResult:(WwClawResultMessage *)result{
    NSLog(@"房间内收到 抓娃娃结果通知--%@",result);
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//        self.onlineView.gameState.text = @"开始游戏";
//        self.onlineView.playView.userInteractionEnabled = YES;
//    });
}

/**< 收到全平台 抓娃娃结果通知*/
- (void)reciveGlobleMessage:(WwGlobalMessage *)notify{
    NSLog(@"收到全平台 抓娃娃结果通知--%@",notify);
}

- (void)avatarTtlDidChanged:(NSInteger)ttl {
    NSString *pingStr = [NSString stringWithFormat:@"%zdms",ttl];
    [self.onlineView.pingBtn setTitle:pingStr forState:UIControlStateNormal];
    if (ttl <= 100) {
        [self.onlineView.pingBtn setImage:[UIImage imageNamed:@"wifi"] forState:UIControlStateNormal];
    }else if (ttl > 100 && ttl <= 200){
        [self.onlineView.pingBtn setImage:[UIImage imageNamed:@"wifi_warn"] forState:UIControlStateNormal];
    }else{
        [self.onlineView.pingBtn setImage:[UIImage imageNamed:@"wifi_error"] forState:UIControlStateNormal];
    }
}

- (void)gameManagerError:(UserInfoError)error{
    
}


- (void)onSlaveStreamReady{
    
}   /**< 辅摄像头的流已经加载成功了*/

// IM
- (void)reciveWatchNumber:(NSInteger)number{
    
} /**< 收到 观看人数*/
@end



