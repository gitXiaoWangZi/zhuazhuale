//
//  LSJGameViewController.m
//  zzl
//
//  Created by Mr_Du on 2017/12/28.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "LSJGameViewController.h"
#import "BottomViewController.h"
#import "ZYRoomVerticalScroll.h"
#import "LSJTopView.h"
#import "LSJOperationNormalView.h"
#import "ZYPlayOperationView.h"
#import "AccountItem.h"
#import "LSJRechargeViewController.h"
#import "FXCommentView.h"
#import <AVFoundation/AVFoundation.h>
#import "BulletManager.h"
#import "UIButton+Position.h"
#import "ZYCountDownView.h"
#import "FXGameResultView.h"

@interface LSJGameViewController ()<UIScrollViewDelegate,WwGameManagerDelegate,LSJTopViewDelegate,LSJOperationNormalViewDelegate,ZYPlayOperationViewDelegate,AVAudioPlayerDelegate,FXCommentViewDelegate,UITextFieldDelegate,ZYCountDownViewDelegate,FXGameResultViewDelegate>

@property (nonatomic,strong) ZYRoomVerticalScroll *myScroV;
@property (nonatomic,strong) BottomViewController *BottomViewVC;
@property (nonatomic,strong) LSJTopView *topView;
@property (nonatomic,strong) FXCommentView *comment;//键盘

@property (nonatomic,assign) int commentBtnStatue;
@property (nonatomic,assign) int musicBtnStatue;
@property (nonatomic,strong) FXGameResultView * resultPopView;
@property (nonatomic,strong) AVAudioPlayer * player;
@property (nonatomic,strong) MBProgressHUD *hud;
@property (nonatomic,strong) UIView *playView;//视频view
@property (nonatomic, strong) ZYPlayOperationView *playOperationBar;/**< 游戏操作视图*/

@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) dispatch_source_t timer0;
@property (nonatomic,assign) BOOL isNoBack;
@end

@implementation LSJGameViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (!self.isNoBack) {
        //销毁房间, 离开房间时务必调用, 否则会影响之后的逻辑
        [[WwGameManager GameMgrInstance] exitRoom];
        self.topView.normalView.gameBtn.userInteractionEnabled = YES;
    }
    [self.player stop];
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    [self stop];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.isNoBack = YES;
    if (self.player && self.player.isPlaying) {
        [self play];
    } else {
        if (self.musicBtnStatue == 2) {
            [self.player play];
        }else{
            [self.player pause];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.commentBtnStatue = 1;
    self.musicBtnStatue = 1;
    //搭建页面
    [self setUpUI];
    //请求接口
    [self loadData];

}

- (void)loadData{
    
    //请求最近抓中记录数据
    [self loadLatesRecordData];
    //刷新娃娃详情的数据
    [self.BottomViewVC refrshWaWaDetailsWithModel:self.model];
    [self.topView refrshWaWaDetailsWithModel:self.model];
    //更新钻石数量
    [self loadUserInfoData];
}

- (void)setUpUI{
    [self.view addSubview:self.myScroV];
    self.myScroV.backgroundColor = DYGColorFromHex(0xffe353);
    self.myScroV.contentSize = CGSizeMake(kScreenWidth, 2 * kScreenHeight - 30);
    self.myScroV.bounces = NO;
    self.myScroV.delegate = self;
    self.myScroV.pagingEnabled = YES;
    self.myScroV.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    
    [self.myScroV addSubview:self.topView];
    self.topView.normalView.delegate = self;
    self.topView.countDownV.delegate = self;
    
    self.BottomViewVC = [[BottomViewController alloc] init];
    self.BottomViewVC.ganeViewC = self;
    self.BottomViewVC.view.frame = CGRectMake(10, kScreenHeight - 10, kScreenWidth-20, kScreenHeight);
    self.BottomViewVC.view.layer.cornerRadius = 5;
    self.BottomViewVC.view.layer.masksToBounds = YES;

    __weak typeof(self) weakSelf = self;
    self.BottomViewVC.diselectBlock = ^{
        weakSelf.musicBtnStatue = 1;
    };
    [self.myScroV addSubview:self.BottomViewVC.view];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    //音乐
    [self setMusicPayer];
    
    //添加视频View
    [self configRtcPlayer];
}

-(void)setMusicPayer{
    NSURL * url = [[NSBundle mainBundle]URLForResource:@"gameWait.mp3" withExtension:nil];
    self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    self.player.numberOfLoops = -1;
    self.player.delegate = self;
    [self.player play];
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

#pragma mark --FXCommentViewDelegate
- (void)sendClick{
    
    if (self.comment.commentTF.text != nil && ![self.comment.commentTF.text isEqualToString:@""]) {
        [[WwGameManager GameMgrInstance] sendDamuMsg:self.comment.commentTF.text];
        [self loadMsgDanmuDataWithContent:self.comment.commentTF.text];
    }
    self.comment.commentTF.text = nil;
}

#pragma mark 统计弹幕数据
- (void)loadMsgDanmuDataWithContent:(NSString *)content{
    NSString *path = @"barrage";
    NSDictionary *params = @{@"uid":KUID,@"content":content,@"itemCode":@(self.model.wawa.ID),@"roomid":@(self.model.ID)};
    [DYGHttpTool postWithURL:path params:params sucess:nil failure:nil];
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

- (void)configRtcPlayer{
    _hud = [MBProgressHUD showHUDAddedTo:self.topView.playView animated:YES];
    _hud.mode = MBProgressHUDModeCustomView;
    UIImageView *imageV= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"game_load"]];
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    anima.toValue = @(M_PI * 2);
    anima.duration = 1.0f;
    anima.repeatCount = 50;
    [imageV.layer addAnimation:anima forKey:nil];
    _hud.customView = imageV;
    _hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    _hud.bezelView.color = [UIColor clearColor];
    _hud.animationType = MBProgressHUDAnimationFade;
    _hud.backgroundColor = [UIColor clearColor];
    [WwGameManager GameMgrInstance].delegate = self;
    
    //添加视频流View
    self.playView = [[WwGameManager GameMgrInstance] enterRoomWith:self.model];
    self.playView.hidden = YES;
    if (self.playView) {
        [self.playView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin];
        [self.topView.playView insertSubview:self.playView atIndex:0];
    } else {
        // 进入房间失败了
        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:nil message:@"进入房间失败" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            [self popToView];
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

#pragma mark ---游戏操作处理开始----------------------------------------
#pragma mark --- 对视频View进行约束（三方代理方法）
- (void)onMasterStreamReady{
    self.playView.backgroundColor = DYGColorFromHex(0xffea00);
    self.playView.frame = CGRectMake(0, 0, self.topView.playView.width, self.topView.playView.height);
    self.playView.hidden = NO;
    [_hud hideAnimated:YES];
}


#pragma mark ---游戏操作处理结束----------------------------------------

#pragma mark loaddata
#pragma mark ---请求最近抓中记录数据
- (void)loadLatesRecordData{
    [[WwRoomManager RoomMgrInstance] requestCatchHistory:self.model.ID atPage:1 withComplete:^(NSInteger code, NSString *message, NSArray<WwRoomCatchRecordItem *> *list) {
        [self.BottomViewVC refrshCatchHistoryWithArr:list];
    }];
}

#pragma mark lazyload
-(FXGameResultView *)resultPopView{
    if (!_resultPopView) {
        _resultPopView = [[FXGameResultView alloc] initWithFrame:self.view.bounds];
        _resultPopView.backgroundColor = DYGAColor(0, 0, 0, 0.5);
        _resultPopView.delegate = self;
    }
    return _resultPopView;
}
- (UIScrollView *)myScroV {
    if (!_myScroV) {
        _myScroV = [[ZYRoomVerticalScroll alloc] init];
        _myScroV.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        _myScroV.needCheckTable = YES;
    }
    return _myScroV;
}

- (LSJTopView *)topView{
    if (!_topView) {
        _topView = [[LSJTopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 10)];
        _topView.backgroundColor = DYGColorFromHex(0xFEE354);
        _topView.delegate = self;
    }
    return _topView;
}

- (ZYPlayOperationView *)playOperationBar {
    if (!_playOperationBar) {
        _playOperationBar = [[ZYPlayOperationView alloc] initWithFrame:CGRectZero];
        _playOperationBar.hidden = NO;
        CGFloat height = Py(118);
        CGRect rect = CGRectMake(0, kScreenHeight - height, kScreenWidth, height);
        _playOperationBar.frame = rect;
        _playOperationBar.delegate = self;
        _playOperationBar.backgroundColor = [UIColor clearColor];
    }
    return _playOperationBar;
}

#pragma mark LSJTopViewDelegate  LSJOperationNormalViewDelegate ZYPlayOperationViewDelegate
- (void)dealWithTopViewBy:(TopView)top button:(UIButton *)sender{
    if (self.player.isPlaying) {
        self.musicBtnStatue = 2;
    } else {
        self.musicBtnStatue = 1;
    }
    switch (top) {
        case TopViewBack:
            {
                self.isNoBack = NO;
                [self.navigationController popViewControllerAnimated:YES];
            }
            break;
        case TopViewRecharge:
        {
            self.isNoBack = YES;
            [MobClick event:@"game_pay"];
            NSString *firstPunch = [[NSUserDefaults standardUserDefaults] objectForKey:Kfirstpunch];
            LSJRechargeViewController *rechargeVC = [[LSJRechargeViewController alloc] init];
            rechargeVC.firstpunch = firstPunch;
            [self.navigationController pushViewController:rechargeVC animated:YES];
        }
            break;
        case TopViewMusic:
        {
            if (sender.selected) {
                NSLog(@"音乐");
                [self.player pause];
            }else{
                NSLog(@"不要音乐");
                [self.player play];
            }
        }
            break;
        case TopViewBarrage:
        {
            if (sender.selected) {
                NSLog(@"不要弹幕");
                [self.topView stopScroll];
            }else{
                NSLog(@"弹幕");
                [self.topView start];
            }
        }
            break;
        default:
            break;
    }
}

- (void)dealWithbottomViewBy:(OperationNormalView)operation button:(UIButton *)sender{
    switch (operation) {
        case OperationNormalViewView:
        {
            [[WwGameManager GameMgrInstance] cameraSwitchIsFront:!sender.selected];
            self.playOperationBar.cameraDir = sender.selected ? CameraDirection_Right : CameraDirection_Front;
        }
            break;
        case OperationNormalViewGame:
        {
            sender.enabled = NO;
            [self playGameAction:sender];
        }
            break;
        case OperationNormalViewMsg:
        {
            [self commentViewPop];
        }
            break;
        default:
            break;
    }
}

#pragma mark--点击开始游戏按钮
- (void)playGameAction:(UIButton *)sender {
    NSString *path = @"userMoney";
    NSDictionary *params = @{@"uid":KUID};
    [DYGHttpTool postWithURL:path params:params sucess:^(id json) {
        NSDictionary *dic = (NSDictionary *)json;
        if ([dic[@"code"] integerValue] == 200) {
            sender.enabled = YES;
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
        [self.myScroV addSubview:self.playOperationBar];
    }
    self.playOperationBar.hidden = YES;
    
    @weakify(self);
    [[WwGameManager GameMgrInstance] requestStartGameWithComplete:^(NSInteger code, NSString *msg, NSString *orderID) {
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            
            if (code == WwCodeSuccess) {
                self.topView.normalView.gameBtn.userInteractionEnabled = NO;
                self.playOperationBar.hidden = NO;
                self.topView.normalView.hidden = YES;
                self.topView.countDownV.hidden = NO;
                [self.topView.countDownV updateProgressTimer:30];
                
                //游戏开始 页面不可以滑动并置顶
                self.myScroV.scrollEnabled = NO;
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

//改变视角
- (void)changePerspective:(BOOL)isSelect{
    [[WwGameManager GameMgrInstance] cameraSwitchIsFront:!isSelect];
    self.playOperationBar.cameraDir = isSelect ? CameraDirection_Right : CameraDirection_Front;
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
    self.topView.countDownV.status = ZYCountDownStatusRequestResultIng;
    [[WwGameManager GameMgrInstance] requestClawWithForceRelease:NO withComplete:^(NSInteger code, NSString *msg, WwGameResult *resultM) {
        //游戏结束 页面可以滑动
        self.myScroV.scrollEnabled = YES;
        
        if (resultM.state == 2) {
            [self showResultPopViewWithResult:YES];
        } else {
            [self showResultPopViewWithResult:NO];
        }
        safe_async_main((^{
            self.topView.countDownV.status = ZYCountDownStatusCountDown;
            self.topView.countDownV.hidden = YES;
            self.playOperationBar.hidden = YES;
            self.topView.normalView.hidden = NO;
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
    
    //添加弹出视图
    [self.view addSubview:self.resultPopView];
    [self.resultPopView showStatusView:isSuccess];
    [self countDownAction];
}

#pragma mark ---请求用户信息数据
- (void)loadUserInfoData{
    [self.topView.perPayBtn setTitle:[NSString stringWithFormat:@"%zd/次",self.model.wawa.coin] forState:UIControlStateNormal];
    NSString *path = @"getUserInfo";
    NSDictionary *params = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KUser_ID]};
    [DYGHttpTool postWithURL:path params:params sucess:^(id json) {
        NSDictionary *dic = (NSDictionary *)json;
        if ([dic[@"code"] intValue] == 200) {
            AccountItem *item = [AccountItem mj_objectWithKeyValues:dic[@"data"][0]];
            self.topView.zuanshiNumL.text = item.money;
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)countDownAction{
    __block int num = 10;
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
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.resultPopView.desL.text = [NSString stringWithFormat:@"%zds内投币继续",num];
            num--;
        });
        
        if (num <= 0 || num > 10) {
            // 关闭定时器
            dispatch_source_cancel(timer0);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.resultPopView removeFromSuperview];
            });
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
    NSString *path = @"luckyRecode";
    NSDictionary *params = @{@"uid":KUID,@"dollname":self.model.wawa.name,@"money":@(self.model.wawa.coin),@"itemCode":@(self.model.wawa.ID)};
    [DYGHttpTool postWithURL:path params:params sucess:nil failure:nil];
}

#pragma mark FXGameResultViewDelegate
- (void)gameAgainAction{
    
    dispatch_source_cancel(_timer0);
    [self playGame];
}

- (void)cancelAction{
    if (self.timer) {
        [self.timer invalidate];
    }
    
    dispatch_source_cancel(_timer0);
    _timer0 = nil;
    self.topView.normalView.gameBtn.userInteractionEnabled = YES;
}

#pragma mark---WwGameManagerDelegate实现一些回调方法
- (void)reciveWatchNumber:(NSInteger)number{
    [self.topView refreshAudienceWithWwUserNum:number withModel:self.model];
}

/**< 收到聊天回调*/
- (void)reciveRemoteMsg:(WwChatMessage *)chatM{
    NSLog(@"收到聊天回调----%@",chatM);
    NSMutableArray *msgArray = [NSMutableArray array];
    WwUser *model = chatM.fromUser;
    NSString *msg = [NSString stringWithFormat:@"%@:%@",model.nickname,chatM.content];
    if (![msg isEqualToString:@""] && msg != nil) {
        [msgArray addObject:msg];
        self.topView.bulletManager.comments = [msgArray mutableCopy];
    }
}

/**< 收到 房间状态更新*/
- (void)reciveRoomUpdateData:(WwRoomDataMessage *)liveData{
    NSLog(@"收到 房间状态更新--%@",liveData);
    if (liveData.state >= 3 && liveData.state <= 6) {
        WwUser *model = liveData.user;
        [self.topView refreGameUserByUser:model];
        self.topView.statusImgV.hidden = YES;
    }else if (liveData.state == 2){//开始游戏
        [self.topView refreGameUserByUser:nil];
        self.topView.statusImgV.hidden = NO;
    }else if (liveData.state <= 0){//机器维护中
        [self.topView refreGameUserByUser:nil];
        self.topView.statusImgV.hidden = YES;
    }else{

    }
}

/**< 房间内收到 抓娃娃结果通知*/
- (void)reciveClawResult:(WwClawResultMessage *)result{
    NSLog(@"房间内收到 抓娃娃结果通知--%@",result);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(9 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.topView.normalView.gameBtn.userInteractionEnabled = YES;
    });
}

/**< 收到全平台 抓娃娃结果通知*/
- (void)reciveGlobleMessage:(WwGlobalMessage *)notify{
    NSLog(@"收到全平台 抓娃娃结果通知--%@",notify);
}

- (void)avatarTtlDidChanged:(NSInteger)ttl {
//    NSString *pingStr = [NSString stringWithFormat:@"%zdms",ttl];
//    [self.onlineView.pingBtn setTitle:pingStr forState:UIControlStateNormal];
//    if (ttl <= 100) {
//        [self.onlineView.pingBtn setImage:[UIImage imageNamed:@"wifi"] forState:UIControlStateNormal];
//    }else if (ttl > 100 && ttl <= 200){
//        [self.onlineView.pingBtn setImage:[UIImage imageNamed:@"wifi_warn"] forState:UIControlStateNormal];
//    }else{
//        [self.onlineView.pingBtn setImage:[UIImage imageNamed:@"wifi_error"] forState:UIControlStateNormal];
//    }
}

- (void)gameManagerError:(UserInfoError)error{
    
}


- (void)onSlaveStreamReady{
    
}   /**< 辅摄像头的流已经加载成功了*/

@end
