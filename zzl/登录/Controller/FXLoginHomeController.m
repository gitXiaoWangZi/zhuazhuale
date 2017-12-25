//
//  FXLoginHomeController.m
//  zzl
//
//  Created by Mr_Du on 2017/11/10.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "FXLoginHomeController.h"
#import "FXLoginPopView.h"
#import "FXTabBarController.h"
#import "AppDelegate.h"
#import <SDWebImage/UIImage+GIF.h>
#import "FXLoginController.h"
#import "FXGameWebController.h"
#import "FXHomeBannerItem.h"

@interface FXLoginHomeController ()<wxDelegate>

@property(nonatomic,weak)AppDelegate * appdelegate;
@property(nonatomic,strong)UIImageView * bgImg;
@property(nonatomic,strong)UIImageView * gifImg;
@property (nonatomic,strong) UIButton * weChat;
@property (nonatomic,strong) UIButton * phone;
@property (nonatomic,strong) UIButton * visiteBtn;
@property (nonatomic,strong) UILabel * textLabel;
@property (nonatomic,strong) UILabel * xyLabel;
@property (nonatomic,strong) UIButton *back;
@property (nonatomic,strong) FXLoginPopView * popView;
@property (nonatomic,strong) MBProgressHUD *hud;

@end

@implementation FXLoginHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    
    [self creatUI];
    
    
    [DYGHttpTool postWithURL:@"appeal" params:nil sucess:^(id json) {
        NSDictionary *dic = (NSDictionary *)json;
        if ([dic[@"code"] integerValue] == 200) {
            if ([dic[@"data"] integerValue] == 0) {
                self.visiteBtn.hidden = YES;
            }else{
                self.visiteBtn.hidden = NO;
            }
        }
    } failure:^(NSError *error) {
        
    }];
}
-(void)creatUI{
    
    [self.view addSubview:self.bgImg];
    [self.bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
    }];
    [self.view addSubview:self.gifImg];
    [self.gifImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(Py(60)));
        make.left.equalTo(@(28));
        make.right.equalTo(@(-28));
        make.height.equalTo(@((kScreenWidth - 56) * 0.75));
    }];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"importdribbble" ofType:@"gif"];
    [self.gifImg sd_setImageWithURL:[NSURL fileURLWithPath:path]];

    
    [self.view addSubview:self.weChat];
    [self.weChat mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.gifImg);
        make.top.equalTo(self.gifImg.mas_bottom).offset(Py(68));
        make.size.mas_equalTo(CGSizeMake(Px(185), Py(72)));
    }];
    [self.view addSubview:self.phone];
    [self.phone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.weChat);
        make.top.equalTo(self.weChat.mas_bottom).offset(Py(5));
        make.size.equalTo(self.weChat);
    }];
    [self.view addSubview:self.visiteBtn];
    [self.visiteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.phone);
        make.top.equalTo(self.phone.mas_bottom).offset(Py(5));
        make.size.equalTo(self.phone);
    }];
    [self.view addSubview:self.textLabel];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(-60));
        make.centerX.equalTo(self.weChat).offset(-30);
    }];
    [self.view addSubview:self.xyLabel];
    [self.xyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.textLabel);
        make.left.equalTo(self.textLabel.mas_right).offset(2);
    }];
    self.xyLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(agreementAction:)];
    [self.xyLabel addGestureRecognizer:tap];
}

- (void)agreementAction:(UITapGestureRecognizer *)tap {
    FXHomeBannerItem *item = [FXHomeBannerItem new];
    item.title = @"用户协议";
    item.href = @"http://openapi.wawa.zhuazhuale.xin/agreement";
    FXGameWebController *web = [[FXGameWebController alloc] init];
    web.item = item;
    [self.navigationController pushViewController:web animated:YES];
}
-(void)backClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)phoneClick{
    FXLoginController *loginV = [[FXLoginController alloc] init];
    [self.navigationController pushViewController:loginV animated:YES];
}

#pragma mark -------微信登录
-(void)weChatAction {
    
//    if ([WXApi isWXAppInstalled]) {//用户已经安装微信客户端
//        //构造SendAuthReq结构体
        SendAuthReq* req =[[SendAuthReq alloc ] init ];
        req.scope = @"snsapi_userinfo" ;
        req.state = @"123" ;
        self.appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        self.appdelegate.delegate = self;
        //第三方向微信终端发送一个SendAuthReq消息结构
        [WXApi sendReq:req];
//    }else{//用户未安装微信客户端
////
//    }
    
}

- (void)loginSuccessByCode:(NSString *)code{
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.label.text = @"登录中";
    NSLog(@"code %@",code);
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:WXAppID forKey:@"appid"];
    [params setObject:WXAppSecret forKey:@"secret"];
    [params setObject:code forKey:@"code"];
    [params setObject:@"authorization_code" forKey:@"grant_type"];
    [DYGHttpTool getWXWithPath:@"https://api.weixin.qq.com/sns/oauth2/access_token" params:params success:^(id responseObj) {
        NSDictionary *dic = responseObj;
        NSString *accessToken = [dic valueForKey:@"access_token"];
        NSString *openID = [dic valueForKey:@"openid"];
        [weakSelf requestUserInfoByToken:accessToken andOpenid:openID];
    } failure:^(NSError *error) {
        [_hud hideAnimated:YES];
        NSLog(@"error %@",error);
    }];
}

-(void)requestUserInfoByToken:(NSString*)token andOpenid:(NSString*)openID{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:token forKey:@"access_token"];
    [params setObject:openID forKey:@"openid"];
    [DYGHttpTool getWXWithPath:@"https://api.weixin.qq.com/sns/userinfo" params:params success:^(id responseObj) {
        NSDictionary *dic = responseObj;
        NSLog(@"%@",dic);
        [self wxLoginDataWithOpenid:dic[@"unionid"] name:dic[@"nickname"] img:dic[@"headimgurl"]];

    } failure:^(NSError *error) {
        [_hud hideAnimated:YES];
        NSLog(@"error %@",error);
    }];
}

- (void)wxLoginDataWithOpenid:(NSString *)openID name:(NSString *)name img:(NSString *)img{
    NSString *path = @"wxLoginUser";
    NSDictionary *params = @{@"openid":openID,@"username":name,@"img":img};
    [DYGHttpTool postWithURL:path params:params sucess:^(id json) {
        [_hud hideAnimated:YES];
        NSDictionary *dic = (NSDictionary *)json;
        if ([dic[@"code"] integerValue] == 200) {
            //微信登录成功后
            NSDictionary *userDic = dic[@"data"][0];
            NSMutableDictionary *userIngoDic = [@{@"ID":userDic[@"id"],@"name":userDic[@"username"],@"img":userDic[@"img_path"]} mutableCopy];
            [[NSUserDefaults standardUserDefaults] setObject:userIngoDic forKey:@"KWAWAUSER"];
            UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
            window.rootViewController = [[FXTabBarController alloc] init];
            [[NSUserDefaults standardUserDefaults] setObject:dic[@"data"][0][@"id"] forKey:KUser_ID];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:KLoginStatus];
        }
    } failure:^(NSError *error) {
        [_hud hideAnimated:YES];
    }];
}

#pragma mark lazy load
-(UIImageView *)gifImg{
    if (!_gifImg) {
        _gifImg = [[UIImageView alloc] init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"importdribbble.gif" ofType:nil];
        NSData *data = [NSData dataWithContentsOfFile:path];
        UIImage *image = [UIImage sd_animatedGIFWithData:data];
        _gifImg.image = image;
    }
    return _gifImg;
}
-(UIImageView *)bgImg{
    if (!_bgImg) {
        _bgImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"loginBG"]];
    }
    return _bgImg;
}
-(UIButton *)weChat{
    
    if (!_weChat) {
        _weChat = [UIButton buttonWithImage:@"weChatLogin" WithHighlightedImage:@"weChatLogin"];
        [_weChat addTarget:self action:@selector(weChatAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _weChat;
}
-(UIButton *)phone{
    if (!_phone) {
        _phone = [UIButton buttonWithImage:@"numLogin" WithHighlightedImage:@"numLogin"];
        [_phone addTarget:self action:@selector(phoneClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _phone;
}
-(UIButton *)visiteBtn{
    if (!_visiteBtn) {
        _visiteBtn = [UIButton buttonWithTitle:@"游客登录" titleColor:DYGColorFromHex(0x999999) font:14];
        [_visiteBtn addTarget:self action:@selector(visiteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _visiteBtn;
}
-(UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [UILabel labelWithFont:13 WithTextColor:DYGColorFromHex(0x999999)];
        _textLabel.text = @"登录代表您同意抓抓乐";
    }
    return _textLabel;
}

-(UILabel *)xyLabel{
    if (!_xyLabel) {
        _xyLabel = [UILabel labelWithMediumFont:13 WithTextColor:systemColor];
        _xyLabel.text = @"用户协议";
    }
    return _xyLabel;
}
-(UIButton *)back{
    if (!_back) {
        _back = [UIButton buttonWithImage:@"backArrow" WithHighlightedImage:@"backArrow"];
        _back.size = _back.currentImage.size;
        [_back addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _back;
}

- (void)visiteBtnClick{
    NSString *path = @"vLoginUser";
    NSDictionary *params = @{@"phone":[DYGEnCode EncodeWithString:@"15223439862"],@"vercode":@"123456",@"appsour":@"appStore"};
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
@end
