//
//  FXLoginController.m
//  zzl
//
//  Created by Mr_Du on 2017/12/1.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "FXLoginController.h"
#import "FXTabBarController.h"

@interface FXLoginController ()
{
    NSInteger _timerNo;
    NSTimer *_timer;
}
@property(nonatomic,strong)UIImageView * iconImg;
@property (nonatomic,strong) UITextField * numTF;
@property (nonatomic,strong) UITextField * pswTF;
@property (nonatomic,strong) UIButton * send;
@property (nonatomic,strong) UIButton *login;
@property (nonatomic,strong) NSTimer * timer;
@property (nonatomic,strong) UIView *line1;
@property (nonatomic,strong) UIView *line2;
@property (nonatomic,strong) UIButton *exit;
@property (nonatomic,strong) MBProgressHUD *hud;
@end

@implementation FXLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatUI];
}

-(void)creatUI{
    
    [self.view addSubview:self.iconImg];
    [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(Py(60));
    }];
    [self.view addSubview:self.numTF];
    [self.numTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.iconImg.mas_bottom).offset(Py(38));
        make.left.equalTo(@(40));
        make.right.equalTo(@(-40));
        make.height.equalTo(@(Py(52)));
    }];
    [self.view addSubview:self.line1];
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.numTF.mas_bottom);
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.numTF);
        make.height.equalTo(@1);
    }];
    [self.view addSubview:self.pswTF];
    [self.pswTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.line1);
        make.size.mas_equalTo(CGSizeMake(Px(117), Py(52)));
    }];
    [self.view addSubview:self.line2];
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pswTF.mas_bottom);
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.line1);
        make.height.equalTo(@1);
    }];
    [self.view addSubview:self.send];
    [self.send mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pswTF.mas_right);
        make.centerY.equalTo(self.pswTF);
        make.right.equalTo(self.line1.mas_right);
        make.bottom.equalTo(self.line2.mas_top);
        make.width.equalTo(@(100));
    }];
    [self.view addSubview:self.login];
    [self.login mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line2.mas_bottom).offset(Py(30));
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.line1);
    }];
    [self.view addSubview:self.exit];
    [self.exit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(30));
        make.left.equalTo(@(20));
        make.size.mas_equalTo(CGSizeMake(Px(40), Py(20)));
    }];
}

-(void)disMiss{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


#pragma mark lazy load


-(UIImageView *)iconImg{
    if (!_iconImg) {
        _iconImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"loginLogo"]];
    }
    return _iconImg;
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
        _exit = [UIButton buttonWithTitle:@"返回" titleColor:DYGColorFromHex(0x777777) font:18];
        [_exit addTarget:self action:@selector(disMiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exit;
}

//登录按钮
- (void)login:(UIButton *)sender{
    if ([self.numTF.text isEqualToString:@""]) {
        [MBProgressHUD showMessage:@"请输入手机号" toView:self.view];
        return;
    }
    if ([self.pswTF.text isEqualToString:@""]) {
        [MBProgressHUD showMessage:@"请输入验证码" toView:self.view];
        return;
    }
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.label.text = @"登录中";
    NSString *path = @"vLoginUser";
    NSDictionary *params = @{@"phone":[DYGEnCode EncodeWithString:self.numTF.text],@"vercode":self.pswTF.text,@"appsour":@"appStore"};
    [DYGHttpTool postWithURL:path params:params sucess:^(id json) {
        [_hud hideAnimated:YES];
        NSDictionary *dic = (NSDictionary *)json;
        if ([dic[@"code"] integerValue] == 200) {
            
            NSDictionary *userDic = dic[@"data"][0];
            NSMutableDictionary *userIngoDic = [@{@"ID":userDic[@"id"],@"name":userDic[@"username"],@"img":userDic[@"img_path"]} mutableCopy];
            [[NSUserDefaults standardUserDefaults] setObject:userIngoDic forKey:@"KWAWAUSER"];
            UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
            window.rootViewController = [[FXTabBarController alloc] init];
            [[NSUserDefaults standardUserDefaults] setObject:dic[@"data"][0][@"id"] forKey:KUser_ID];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:KLoginStatus];
            
        }else{
            [MBProgressHUD showError:dic[@"msg"] toView:self.view];
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
                [MBProgressHUD showMessage:@"您已注册" toView:self.view];
            }else if ([[dic objectForKey:@"code"] isEqualToString:@"503"]){
                [MBProgressHUD showMessage:@"手机号错误" toView:self.view];
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

- (BOOL)checkTextFieldIsNoNil{
    if (self.numTF.text.length != 11) {
        [MBProgressHUD showMessage:@"请输入正确的手机号" toView:self.view];
        return NO;
    }
    return YES;
}

@end
