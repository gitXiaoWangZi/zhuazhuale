//
//  FXLoginPopView.m
//  zzl
//
//  Created by Mr_Du on 2017/11/10.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "FXLoginPopView.h"
#import "FXTabBarController.h"
#import "FXNavigationController.h"
#import "FXHomeViewController.h"
#import "AccountItem.h"

@interface FXLoginPopView()
{
    NSInteger _timerNo;
    NSTimer *_timer;
}
@property (nonatomic,strong) UITextField * numTF;
@property (nonatomic,strong) UITextField * pswTF;
@property (nonatomic,strong) UIButton * send;
@property (nonatomic,strong) UIButton *login;
@property (nonatomic,strong) NSTimer * timer;
@property (nonatomic,strong) UIView *line1;
@property (nonatomic,strong) UIView *line2;
@property (nonatomic,strong) UIButton *exit;
@property (nonatomic,strong) UIView * MView;
@property (nonatomic,strong) UILabel *titlL;
@property (nonatomic,strong) UILabel *desL;

@end

@implementation FXLoginPopView


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    [self addSubview:self.MView];
    [self.MView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(Py(135));
        make.width.equalTo(@(Px(282.5)));
        make.height.equalTo(@(Py(307)));
    }];
    [self.MView addSubview:self.titlL];
    [self.titlL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.MView.mas_top).offset(Py(33));
    }];
    [self.titlL sizeToFit];
    [self.MView addSubview:self.desL];
    [self.desL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.titlL.mas_bottom).offset(Py(5));
    }];
    [self.desL sizeToFit];
    [self.MView addSubview:self.numTF];
    [self.numTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.MView);
        make.top.equalTo(self.desL.mas_bottom).offset(Py(30));
        make.size.mas_equalTo(CGSizeMake(Px(218), Py(50)));
    }];
    [self.MView addSubview:self.line1];
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.numTF.mas_bottom);
        make.centerX.equalTo(self.MView);
        make.width.equalTo(self.numTF);
        make.height.equalTo(@1);
    }];
    [self.MView addSubview:self.pswTF];
    [self.pswTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.line1);
        make.size.mas_equalTo(CGSizeMake(Px(117), Py(50)));
    }];
    [self.MView addSubview:self.line2];
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pswTF.mas_bottom);
        make.centerX.equalTo(self.MView);
        make.width.equalTo(self.line1);
        make.height.equalTo(@1);
    }];
    [self.MView addSubview:self.send];
    [self.send mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pswTF.mas_right);
        make.centerY.equalTo(self.pswTF);
        make.right.equalTo(self.line1.mas_right);
        make.bottom.equalTo(self.line2.mas_top);
    }];
    [self.MView addSubview:self.login];
    [self.login mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line2.mas_bottom).offset(Py(28));
        make.centerX.equalTo(self.MView);
    }];
    [self addSubview:self.exit];
    [self.exit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.MView);
        make.top.equalTo(self.MView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(Px(52), Py(114)));
    }];
}

-(void)disMiss{
    [self removeFromSuperview];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}


#pragma mark lazy load
-(UILabel *)titlL{
    if (!_titlL) {
        _titlL = [[UILabel alloc] init];
        _titlL.text = @"手机登录";
        _titlL.font = [UIFont boldSystemFontOfSize:20];
        _titlL.textColor = DYGColorFromHex(0x424242);
        _titlL.textAlignment = NSTextAlignmentCenter;
    }
    return _titlL;
}

-(UILabel *)desL{
    if (!_desL) {
        _desL = [[UILabel alloc] init];
        _desL.text = @"欢迎来到抓抓乐的世界";
        _desL.font = [UIFont systemFontOfSize:13];
        _desL.textColor = DYGColorFromHex(0xd2d2d2);
        _desL.textAlignment = NSTextAlignmentCenter;
    }
    return _desL;
}

-(UITextField *)numTF{
    if (!_numTF) {
        _numTF = [[UITextField alloc]init];
        _numTF.placeholder = @"请输入手机号码";
        _numTF.font = [UIFont systemFontOfSize:16];
        _numTF.textColor = DYGColorFromHex(0xacacac);
        _numTF.leftViewMode =UITextFieldViewModeAlways;
        _numTF.keyboardType = UIKeyboardTypeNumberPad;
        UILabel * left = [UILabel labelWithMediumFont:18 WithTextColor:DYGColorFromHex(0x777777)];
        left.text = @"+86";
        left.frame = CGRectMake(0, 0, Px(40), Py(52));
        _numTF.leftView = left;
    }
    return _numTF;
}

-(UITextField *)pswTF{
    if (!_pswTF) {
        _pswTF = [[UITextField alloc]init];
        _pswTF.placeholder = @"手机验证码";
        _pswTF.keyboardType = UIKeyboardTypeNumberPad;
        _pswTF.textColor =DYGColorFromHex(0xacacac);
        _pswTF.font = [UIFont systemFontOfSize:16];
    }
    return _pswTF;
}

-(UIButton *)send{
    if (!_send) {
        _send = [UIButton buttonWithTitle:@"发送验证码" titleColor:systemColor font:16];
        [_send setTitle:@"发送验证码" forState:UIControlStateDisabled];
        [_send addTarget:self action:@selector(sendMsg:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _send;
}

-(UIButton *)login{
    if (!_login) {
        _login = [UIButton buttonWithImage:@"login" WithHighlightedImage:@"login"];
        _login.size = _login.currentImage.size;
        [_login addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _login;
}
-(UIView *)line1{
    if (!_line1) {
        _line1 = [UIView new];
        _line1.backgroundColor = BGColor;
    }
    return _line1;
}
-(UIView *)line2{
    if (!_line2) {
        _line2 = [UIView new];
        _line2.backgroundColor = BGColor;
    }
    return _line2;
}
-(UIButton *)exit{
    if (!_exit) {
        _exit =[UIButton buttonWithImage:@"delete_ready" WithHighlightedImage:@"delete_ready"];
        [_exit addTarget:self action:@selector(disMiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exit;
}

-(UIView *)MView{
    if (!_MView) {
        _MView = [UIView new];
        _MView.backgroundColor = [UIColor whiteColor];
        _MView.cornerRadius = 10;
        _MView.layer.masksToBounds = YES;
    }
    return _MView;
}

//登录按钮
- (void)login:(UIButton *)sender{
    if ([self.numTF.text isEqualToString:@""]) {
        [MBProgressHUD showText:@"请输入手机号"];
        return;
    }
    if ([self.pswTF.text isEqualToString:@""]) {
        [MBProgressHUD showText:@"请输入验证码"];
        return;
    }
    NSString *path = @"vLoginUser";
    NSDictionary *params = @{@"phone":[DYGEnCode EncodeWithString:self.numTF.text],@"vercode":self.pswTF.text,@"appsour":@"appStore"};
    [DYGHttpTool postWithURL:path params:params sucess:^(id json) {
        NSDictionary *dic = (NSDictionary *)json;
        if ([[dic objectForKey:@"code"] integerValue] == 200) {
            [MobClick event:@"phone_login"];
            NSNumber *alias = dic[@"data"][0][@"id"];
            [JPUSHService setTags:nil alias:[alias stringValue] fetchCompletionHandle:nil];
            NSDictionary *userDic = dic[@"data"][0];
            NSMutableDictionary *userIngoDic = [@{@"ID":userDic[@"id"],@"name":userDic[@"username"],@"img":userDic[@"img_path"]} mutableCopy];
            [[NSUserDefaults standardUserDefaults] setObject:userIngoDic forKey:@"KWAWAUSER"];
            UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
            FXNavigationController *nav = [[FXNavigationController alloc] initWithRootViewController:[FXHomeViewController new]];
            window.rootViewController = nav;
            [[NSUserDefaults standardUserDefaults] setObject:dic[@"data"][0][@"id"] forKey:KUser_ID];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:KLoginStatus];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kWChatLoginType];
            AccountItem *account = [AccountItem mj_objectWithKeyValues:dic[@"data"][0]];
            [[NSUserDefaults standardUserDefaults] setObject:account.firstpunch forKey:Kfirstpunch];
            
        }else{
            [MBProgressHUD showText:[dic objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
}


//发送验证码
- (void)sendMsg:(UIButton *)btn {
    
    if ([self checkTextFieldIsNoNil]) {
        [self startSendAuthcode:btn];
        NSString *path = @"getLoginVercode";
        NSDictionary *params = @{@"phone":[DYGEnCode EncodeWithString:self.numTF.text]};
        [DYGHttpTool postWithURL:path params:params sucess:^(id json) {
            NSDictionary *dic = (NSDictionary *)json;
            if ([[dic objectForKey:@"code"] integerValue] == 200) {
            }else if ([[dic objectForKey:@"code"] isEqualToString:@"201"]){
                [MBProgressHUD showText:@"您已注册"];
            }else if ([[dic objectForKey:@"code"] isEqualToString:@"503"]){
                [MBProgressHUD showText:@"手机号错误"];
            }else{
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }
}

-(void)startSendAuthcode:(UIButton *)btn{//计时器
    _timerNo = 60;
    btn.enabled = NO;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}
//定时器
- (void)timerAction:(NSTimer *)timer{
    _timerNo--;
    self.send.titleLabel.text = [NSString stringWithFormat:@"(%zd)重新验证",_timerNo];
    [self.send setTitle:[NSString stringWithFormat:@"(%zd)重新验证",_timerNo] forState:UIControlStateDisabled];
    if (_timerNo == 0) {
        [timer invalidate];
        self.send.enabled = YES;
        self.send.titleLabel.text = @"(60)重新验证";
        [self.send setTitle:@"(60)重新验证" forState:UIControlStateDisabled];
    }
}

- (void)changeMainViewController{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    window.rootViewController = [[FXTabBarController alloc] init];
}

- (BOOL)checkTextFieldIsNoNil{
    if (self.numTF.text.length != 11) {
        [MBProgressHUD showError:@"请输入正确的手机号"];
        return NO;
    }
    return YES;
}



@end





























