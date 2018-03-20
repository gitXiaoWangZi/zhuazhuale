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
#import "FXNavigationController.h"
#import "FXHomeViewController.h"
#import "FXHomeBannerItem.h"
#import "AccountItem.h"

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
@property (weak, nonatomic) IBOutlet UIImageView *downImagV;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
@property (weak, nonatomic) IBOutlet UIButton *wechatBtn;
@property (weak, nonatomic) IBOutlet UIImageView *domnImgV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneRightCons;

@end

@implementation FXLoginHomeController

- (void)viewWillAppear:(BOOL)animated{
    if (![WXApi isWXAppInstalled]) {//用户没有安装微信客户端
        //构造SendAuthReq结构体
        self.wechatBtn.hidden = YES;
        self.phoneRightCons.constant = 58 - (kScreenWidth - 40)/2;
    }else{//用户安装微信客户端
        self.wechatBtn.hidden = NO;
        self.phoneRightCons.constant = -21;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    
    [self.view addSubview:self.visiteBtn];
    [self.visiteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneBtn.mas_bottom).offset(30);
        make.centerX.equalTo(self.view);
    }];
    
    self.downImagV.layer.cornerRadius = 10;
    
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

- (IBAction)weixinAction:(UIButton *)sender {
    [self weChatAction];
}

- (IBAction)phoneAction:(UIButton *)sender {
    
    [self.view addSubview:self.popView];
}

#pragma mark -------微信登录
-(void)weChatAction {
    
    if ([WXApi isWXAppInstalled]) {//用户已经安装微信客户端
        //构造SendAuthReq结构体
        SendAuthReq* req =[[SendAuthReq alloc ] init ];
        req.scope = @"snsapi_userinfo" ;
        req.state = @"123" ;
        self.appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        self.appdelegate.delegate = self;
        //第三方向微信终端发送一个SendAuthReq消息结构
        [WXApi sendReq:req];
    }else{//用户未安装微信客户端
//
    }
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
        [self wxLoginDataWithOpenid:dic[@"unionid"] name:dic[@"nickname"] img:dic[@"headimgurl"] sex:dic[@"sex"]];

    } failure:^(NSError *error) {
        [_hud hideAnimated:YES];
        NSLog(@"error %@",error);
    }];
}

- (void)wxLoginDataWithOpenid:(NSString *)openID name:(NSString *)name img:(NSString *)img sex:(NSString *)sex{
    NSString *path = @"wxLoginUser";
    NSString *sexStr = [sex integerValue] == 0 ? @"女" : @"男";
    NSDictionary *params = @{@"openid":openID,@"username":name,@"img":img,@"sex":sexStr};
    [DYGHttpTool postWithURL:path params:params sucess:^(id json) {
        [_hud hideAnimated:YES];
        NSDictionary *dic = (NSDictionary *)json;
        if ([dic[@"code"] integerValue] == 200) {
            NSNumber *alias = dic[@"data"][0][@"id"];
            [JPUSHService setTags:nil alias:[alias stringValue] fetchCompletionHandle:nil];
            //微信登录成功后
            NSDictionary *userDic = dic[@"data"][0];
            NSMutableDictionary *userIngoDic = [@{@"ID":userDic[@"id"],@"name":userDic[@"username"],@"img":userDic[@"img_path"]} mutableCopy];
            [[NSUserDefaults standardUserDefaults] setObject:userIngoDic forKey:@"KWAWAUSER"];
            UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
            FXNavigationController *nav = [[FXNavigationController alloc] initWithRootViewController:[FXHomeViewController new]];
            window.rootViewController = nav;
            [[NSUserDefaults standardUserDefaults] setObject:dic[@"data"][0][@"id"] forKey:KUser_ID];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:KLoginStatus];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kWChatLoginType];
        }
    } failure:^(NSError *error) {
        [_hud hideAnimated:YES];
    }];
}

#pragma mark lazy load
- (FXLoginPopView *)popView{
    if (!_popView) {
        _popView = [[FXLoginPopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _popView.backgroundColor = DYGAColor(0, 0, 0, 0.5);
    }
    return _popView;
}


-(UIButton *)visiteBtn{
    if (!_visiteBtn) {
        _visiteBtn = [UIButton buttonWithTitle:@"游客登录" titleColor:DYGColorFromHex(0xd27300) font:15];
        [_visiteBtn addTarget:self action:@selector(visiteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _visiteBtn;
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
            FXNavigationController *nav = [[FXNavigationController alloc] initWithRootViewController:[FXHomeViewController new]];
            window.rootViewController = nav;
            [[NSUserDefaults standardUserDefaults] setObject:dic[@"data"][0][@"id"] forKey:KUser_ID];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:KLoginStatus];
            AccountItem *account = [AccountItem mj_objectWithKeyValues:dic[@"data"][0]];
            [[NSUserDefaults standardUserDefaults] setObject:account.firstpunch forKey:Kfirstpunch];
        }else{
            [MBProgressHUD showError:dic[@"msg"] toView:self.view];
        }
    } failure:^(NSError *error) {
        
    }];
}
@end
