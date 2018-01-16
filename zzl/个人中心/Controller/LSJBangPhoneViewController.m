//
//  LSJBangPhoneViewController.m
//  zzl
//
//  Created by Mr_Du on 2018/1/3.
//  Copyright © 2018年 Mr.Du. All rights reserved.
//

#import "LSJBangPhoneViewController.h"

@interface LSJBangPhoneViewController ()
{
    NSInteger _timerNo;
    NSTimer *_timer;
}
@property (nonatomic,strong) UITextField * numTF;
@property (nonatomic,strong) UITextField * pswTF;
@property (nonatomic,strong) UIButton * send;
@property (nonatomic,strong) UIView *line1;
@property (nonatomic,strong) UIView *line2;
@property (nonatomic,strong) UIButton *footerBtn;
@end

@implementation LSJBangPhoneViewController

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"绑定手机";
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatUI];
}


-(void)creatUI{
    [self.view addSubview:self.numTF];
    [self.numTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(Py(30));
        make.left.equalTo(self.view.mas_left).offset(Px(20));
        make.right.equalTo(self.view.mas_right).offset(Px(-120));
    }];
    [self.view addSubview:self.line1];
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.numTF.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view.mas_left).offset(Px(20));
        make.right.equalTo(self.view.mas_right).offset(Px(-20));
        make.height.equalTo(@1);
    }];
    [self.view addSubview:self.send];
    [self.send mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.numTF);
        make.right.equalTo(self.line1.mas_right);
        make.bottom.equalTo(self.line1.mas_top);
        make.width.equalTo(@(Px(100)));
    }];
    [self.view addSubview:self.pswTF];
    [self.pswTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.line1);
        make.size.mas_equalTo(CGSizeMake(Px(218), Py(50)));
    }];
    [self.view addSubview:self.line2];
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pswTF.mas_bottom);
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.line1);
        make.height.equalTo(@1);
    }];
    
    
    [self.view addSubview:self.footerBtn];
    [self.footerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line2.mas_bottom).offset(Py(70));
        make.left.equalTo(self.view.mas_left).offset(Px(20));
        make.right.equalTo(self.view.mas_right).offset(Px(-20));
        make.centerX.equalTo(self.view);
        make.height.equalTo(@(50));
    }];
    self.footerBtn.layer.borderColor = DYGColorFromHex(0xcccccc).CGColor;
    self.footerBtn.layer.borderWidth = 1.0f;
    self.footerBtn.layer.cornerRadius = 25;
    self.footerBtn.layer.masksToBounds = YES;
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

- (BOOL)checkTextFieldIsNoNil{
    if (self.numTF.text.length != 11) {
        [MBProgressHUD showError:@"请输入正确的手机号"];
        return NO;
    }
    return YES;
}

- (void)bangAccount:(UIButton *)sender{
    if ([self.numTF.text isEqualToString:@""]) {
        [MBProgressHUD showText:@"请输入手机号"];
        return;
    }
    if ([self.pswTF.text isEqualToString:@""]) {
        [MBProgressHUD showText:@"请输入验证码"];
        return;
    }
    NSString *path = @"bindingPhone";
    NSDictionary *params = @{@"phone":[DYGEnCode EncodeWithString:self.numTF.text],@"vercode":self.pswTF.text,@"uid":KUID};
    [DYGHttpTool postWithURL:path params:params sucess:^(id json) {
        NSDictionary *dic = (NSDictionary *)json;
        if ([dic[@"code"] integerValue] == 200) {
            [MBProgressHUD showMessage:@"绑定成功" toView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [MBProgressHUD showText:[dic objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark lazyload
-(UITextField *)numTF{
    if (!_numTF) {
        _numTF = [[UITextField alloc]init];
        _numTF.placeholder = @"请输入手机号码";
        _numTF.font = [UIFont systemFontOfSize:16];
        _numTF.textColor = DYGColorFromHex(0xacacac);
        _numTF.leftViewMode =UITextFieldViewModeAlways;
        _numTF.keyboardType = UIKeyboardTypeNumberPad;
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

- (UIButton *)footerBtn{
    if (!_footerBtn) {
        _footerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _footerBtn.backgroundColor = DYGColorFromHex(0xfafafa);
        [_footerBtn setTitle:@"确认绑定" forState:UIControlStateNormal];
        [_footerBtn setTitleColor:DYGColorFromHex(0x9b7000) forState:UIControlStateNormal];
        _footerBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [_footerBtn addTarget:self action:@selector(bangAccount:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerBtn;
}
@end
