//
//  FXGameWebController.m
//  zzl
//
//  Created by Mr_Du on 2017/11/18.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "FXGameWebController.h"
#import "FXLatesRecordModel.h"
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "FXRechargeViewController.h"
#import "FXHomeBannerItem.h"
#import "LSJPayPopView.h"

@interface FXGameWebController ()<UIWebViewDelegate,LSJPayPopViewDelegate>

@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic, strong) UIView *progressView;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic,assign) BOOL isChristmasList;
@property (nonatomic,assign) BOOL isShare;
@property (nonatomic,assign) BOOL isOtherPay;

@property (nonatomic,strong) LSJPayPopView *payPopView;
@end

@implementation FXGameWebController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.payPopView) {
        [self.payPopView removeFromSuperview];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self addWebView];
}

-(void)addWebView
{
    _isChristmasList = NO;
    _isShare = NO;
    _isOtherPay = NO;
    self.webView=[[UIWebView alloc]initWithFrame:(CGRectMake(0, 0, kScreenWidth, kScreenHeight-64))];
    self.webView.delegate=self;
    self.webView.scalesPageToFit = YES;
    self.webView.backgroundColor = [UIColor whiteColor];
    self.progressView.y = self.webView.y;
    self.title = self.item.title;
    if (self.item) {
        if ([self.item.banner_type isEqualToString:@"2"]) {//分享
            _isShare = YES;
            self.item.href = [NSString stringWithFormat:@"%@?uid=%@",@"http://wawa.api.fanx.xin/share",KUID];
        }
        if ([self.item.banner_type isEqualToString:@"5"]) {//大转盘
            _isChristmasList = YES;
            self.item.href = [NSString stringWithFormat:@"%@?uid=%@",@"http://wawa.api.fanx.xin/turntable",KUID];
        }
        if ([self.item.banner_type isEqualToString:@"6"]) {//冲榜
            self.item.href = [NSString stringWithFormat:@"%@?uid=%@",@"http://wawa.api.fanx.xin/christmasList",KUID];
        }
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.item.href]];
        [self.webView loadRequest:request];
        [self.view addSubview:self.webView];
    }else{
        self.title = @"精彩视频";
        NSString *path = @"videoShare";
        NSString *orderID = @"";
        if (self.model.orderId) {
            orderID = self.model.orderId;
        }else{
            orderID = self.orderId;
        }
        NSDictionary *params = @{@"orderId":orderID};
        [DYGHttpTool postWithURL:path params:params sucess:^(id json) {
            NSDictionary *dic = (NSDictionary *)json;
            if ([dic[@"code"] integerValue] == 200) {
                
                NSURL *url = [NSURL URLWithString:dic[@"data"][@"linkurl"]];
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                [self.webView loadRequest:request];
                self.webView.allowsInlineMediaPlayback = YES;
                [self.view addSubview:self.webView];
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *urlString = request.URL.absoluteString;
    if ([urlString containsString:@"sharefriend"]) {
        [self shareActionData];
        return NO;
    }
    if ([urlString containsString:@"recharge"]) {
        FXRechargeViewController *rechargeVC= [[FXRechargeViewController alloc] init];
        [self.navigationController pushViewController:rechargeVC animated:YES];
        return NO;
    }
    if ([urlString containsString:@"friendspay"] || [urlString containsString:@"mine"]) {
        [self submitOtherPay];
        return NO;
    }
    if ([urlString containsString:@"activity"]) {
        NSCharacterSet* nonDigits =[[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        int remainSecond =[[urlString stringByTrimmingCharactersInSet:nonDigits] intValue];
        [self loadDiamondCard:remainSecond];
        return NO;
    }
    return YES;
}

#pragma mark 请求是否购买过当前卡接口
- (void)loadDiamondCard:(int)number{
    NSString *path = @"diamondCard";
    NSDictionary *params = @{@"card":@(number),@"uid":KUID};
    [DYGHttpTool postWithURL:path params:params sucess:^(id json) {
        NSDictionary *dic = (NSDictionary *)json;
        if ([dic[@"code"] integerValue] == 200) {
            if ([[dic[@"data"] stringValue] isEqualToString:@"1"]) {//未购买过
                
                [[UIApplication sharedApplication].keyWindow addSubview:self.payPopView];
                self.payPopView.num = [NSString stringWithFormat:@"%zd",number];
                self.payPopView.hidden = NO;
                
            }else{
                [MBProgressHUD showMessage:@"您已购买过当前卡" toView:self.view];
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark 代购
- (void)submitOtherPay{
    NSString *path = @"friendSharePay";
    NSDictionary *params = @{@"uid":KUID};
    [DYGHttpTool postWithURL:path params:params sucess:^(id json) {
        NSDictionary *dic = (NSDictionary *)json;
        if ([dic[@"code"] integerValue] == 200) {
            _isOtherPay = YES;
            [self shareActionWithHref:dic[@"data"][@"linkurl"] title:dic[@"data"][@"title"] content:dic[@"data"][@"conten"] imageArr:@[dic[@"data"][@"path"]]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)shareActionData{
        NSString *path = @"shares";
    NSDictionary *params = @{@"uid":KUID};
        [DYGHttpTool postWithURL:path params:params sucess:^(id json) {
            NSDictionary *dic = (NSDictionary *)json;
            if ([dic[@"code"] integerValue] == 200) {
                [self shareActionWithHref:dic[@"data"][@"linkurl"] title:dic[@"data"][@"title"] content:dic[@"data"][@"conten"] imageArr:@[dic[@"data"][@"path"]]];
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
}

- (void)shareActionWithHref:(NSString *)href title:(NSString *)title content:(NSString *)content imageArr:(NSArray *)images0{
    NSMutableDictionary *shareParams0 = [NSMutableDictionary dictionary];
    NSURL *url = [NSURL URLWithString:href];
    [shareParams0 SSDKSetupShareParamsByText:content images:images0 url:url title:title type:SSDKContentTypeAuto];
    
    [shareParams0 SSDKSetupSinaWeiboShareParamsByText:[NSString stringWithFormat:@"%@ %@",content,href] title:title images:images0 video:nil url:nil latitude:0.0 longitude:0.0 objectID:nil isShareToStory:NO type:SSDKContentTypeAuto];
    
    [shareParams0 SSDKSetupWeChatParamsByText:content title:title url:url thumbImage:nil image:images0 musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil sourceFileExtension:nil sourceFileData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatSession];
    
    [shareParams0 SSDKSetupWeChatParamsByText:content title:title url:url thumbImage:nil image:images0 musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil sourceFileExtension:nil sourceFileData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
    
//    [shareParams0 SSDKSetupQQParamsByText:content title:title url:url audioFlashURL:nil videoFlashURL:nil thumbImage:nil images:images0 type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformTypeQQ];
    
    [ShareSDK showShareActionSheet:self.view items:nil shareParams:shareParams0 onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
        switch (state) {
            case SSDKResponseStateSuccess:
            {
                [self loadShareSuccessData];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                    message:nil
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                [alertView show];
                break;
            }
            case SSDKResponseStateFail:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                message:[NSString stringWithFormat:@"%@",error]
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                [alert show];
                break;
            }
            default:
                break;
        }
    }];
}

#pragma mark 分享成功后的接口
- (void)loadShareSuccessData{
    if (_isChristmasList) {
        NSString *path = @"turntableSharing";
        NSDictionary *params = @{@"uid":KUID};
        [DYGHttpTool postWithURL:path params:params sucess:^(id json) {
            NSDictionary *dic = (NSDictionary *)json;
            if ([dic[@"code"] integerValue] == 200) {
                self.item.href = [NSString stringWithFormat:@"%@?uid=%@",@"http://wawa.api.fanx.xin/turntable",KUID];
                NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.item.href]];
                [self.webView loadRequest:request];
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }
    if (_isShare) {
        NSString *path = @"turntableSharing";
        NSDictionary *params = @{@"uid":KUID,@"type":@"2"};
        [DYGHttpTool postWithURL:path params:params sucess:^(id json) {
        } failure:^(NSError *error) {
        }];
    }
    if (_isOtherPay) {
        NSString *path = @"turntableSharing";
        NSDictionary *params = @{@"uid":KUID,@"type":@"3"};
        [DYGHttpTool postWithURL:path params:params sucess:^(id json) {
        } failure:^(NSError *error) {
        }];
    }
    NSString *path = @"raw_award";
    NSDictionary *params = @{@"uid":KUID,@"type":@"share_game"};
    [DYGHttpTool postWithURL:path params:params sucess:^(id json) {
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

#pragma mark LSJPayPopViewDelegate
- (void)payForType:(BOOL)isWechat num:(NSString *)num{
    if (isWechat) {//微信
        [self wechatPay:num];
    }else{//支付宝
        [self zhifubaoPay:num];
    }
}

- (void)zhifubaoPay:(NSString *)num{
    self.payPopView.hidden = YES;
    NSString *path = @"aliPay";
    NSDictionary *params = @{@"uid":KUID,@"money":num,@"activity":@"1"};
    [DYGHttpTool postWithURL:path params:params sucess:^(id json) {
        NSDictionary *dic = (NSDictionary *)json;
        if ([dic[@"code"] integerValue] == 200) {
            [[AlipaySDK defaultService] payOrder:dic[@"data"] fromScheme:@"zzlwwzfb" callback:^(NSDictionary *resultDic) {
            }];
            
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)wechatPay:(NSString *)num{
    self.payPopView.hidden = YES;
    NSString *path = @"pay";
    NSDictionary *params = @{@"uid":KUID,@"money":num,@"activity":@"1"};
    [DYGHttpTool postWithURL:path params:params sucess:^(id json) {
        NSDictionary *dic = (NSDictionary *)json;
        if ([dic[@"code"] integerValue] == 200) {
            PayReq *req = [[PayReq alloc] init];
            req.partnerId = dic[@"data"][@"partnerid"];
            req.prepayId = dic[@"data"][@"prepayid"];
            req.package = dic[@"data"][@"package"];
            req.nonceStr = dic[@"data"][@"noncestr"];
            req.timeStamp = [dic[@"data"][@"timestamp"] intValue];
            req.sign = dic[@"data"][@"sign"];
            if ([WXApi sendReq:req]) {
                NSLog(@"调起成功");
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - 收到支付成功的消息后作相应的处理
- (void)getOrderPayResult:(NSNotification *)notification
{
    if ([notification.object isEqualToString:@"success"]) {
        [MBProgressHUD showSuccess:@"支付成功" toView:self.view];
        [self.webView reload];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshUserData" object:nil];
    }else {
        [MBProgressHUD showSuccess:@"支付失败" toView:self.view];
    }
}

//支付宝回调
- (void)getOrderzfbPayResult:(NSNotification *)noti{
    NSDictionary *dic= noti.object;
    if ([dic[@"resultStatus"] integerValue] == 9000) {
        [MBProgressHUD showSuccess:@"支付成功" toView:self.view];
        [self.webView reload];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshUserData" object:nil];
    }else{
        [MBProgressHUD showError:@"支付失败" toView:self.view];
    }
}

- (UIView *)progressView
{
    if (!_progressView) {
        _progressView = [[UIView alloc]initWithFrame:CGRectZero];
        //进度条的y值根据导航条是否透明会有变化
        _progressView.y = 0;
        _progressView.height = 2.0;
        _progressView.backgroundColor = [UIColor greenColor];
    }
    return _progressView;
}

- (LSJPayPopView *)payPopView{
    if (!_payPopView) {
        _payPopView = [LSJPayPopView instance];
        _payPopView.delegate = self;
        _payPopView.titleL.text = @"请选择支付方式";
    }
    return _payPopView;
}
@end
