//
//  AppDelegate.m
//  zzl
//
//  Created by Mr_Du on 2017/10/30.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "AppDelegate.h"
#import "FXTabBarController.h"
#import "FXLoginHomeController.h"
#import "WelcomeViewController.h"
#import "FXNavigationController.h"
#import <JPUSHService.h>
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#define AppID @"2017112318102887"
#define AppKey @"552b92dc67b646d5b9d1576799545f4c"

@interface AppDelegate ()<WXApiDelegate,JPUSHRegisterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    /*******娃娃机SDK注册*********/
    [[WawaSDK WawaSDKInstance] registerApp:AppID appKey:AppKey complete:^(BOOL success, int code, NSString * _Nullable message) {
        if (success == NO) {
            NSLog(@"游戏服务正在准备中,请稍后尝试");
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:kSDKNotifyKey object:nil];
        }
    }];
    
    /*******向极光推送注册*********/
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    [JPUSHService setupWithOption:launchOptions appKey:@"a07cd2a354fdb609b05196fa" channel:@"App Store" apsForProduction:1];//0是开发1是发布
    
    /*******向友盟注册  统计功能*********/
    UMConfigInstance.appKey = @"5a28eb48b27b0a2633000206";
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];
    
    /*******向MOB分享注册*********/
    [ShareSDK registerActivePlatforms:@[@(SSDKPlatformTypeSinaWeibo),
                                        @(SSDKPlatformSubTypeWechatSession),
                                        @(SSDKPlatformSubTypeWechatTimeline)] onImport:^(SSDKPlatformType platformType) {
                                            switch (platformType)
                                            {
                                                case SSDKPlatformTypeWechat:
                                                    [ShareSDKConnector connectWeChat:[WXApi class]];
                                                    break;
//                                                case SSDKPlatformTypeQQ:
//                                                    [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
//                                                    break;
                                                case SSDKPlatformTypeSinaWeibo:
                                                    [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                                                    break;
                                                default:
                                                    break;
                                            }
                                        } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
                                            switch (platformType)
                                            {
                                                case SSDKPlatformTypeSinaWeibo:
                                                    //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                                                    [appInfo SSDKSetupSinaWeiboByAppKey:@"568898243"
                                                                              appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                                                                            redirectUri:@"http://www.sharesdk.cn"
                                                                               authType:SSDKAuthTypeBoth];
                                                    break;
                                                case SSDKPlatformTypeWechat:
                                                    [appInfo SSDKSetupWeChatByAppId:WXAppID
                                                                          appSecret:WXAppSecret];
                                                    break;
                                                case SSDKPlatformTypeQQ:
                                                    [appInfo SSDKSetupQQByAppId:@"100371282"
                                                                         appKey:@"aed9b0303e3ed1e27bae87c33761161d"
                                                                       authType:SSDKAuthTypeBoth];
                                                    break;
                                                default:
                                                    break;
                                            }
                                        }];
    
    /*******向微信注册*********/
    [WXApi registerApp:WXAppID];
    
    NSString *saveVersion = [[NSUserDefaults standardUserDefaults] objectForKey:kBundleVersionKey];
    NSString *currentVersion = [[NSBundle mainBundle] infoDictionary][kBundleVersionKey];
    if ([currentVersion isEqualToString:saveVersion]) {
        if (KisLogin) {
            self.window.rootViewController = [FXTabBarController new];
        }else{
            FXNavigationController *nav = [[FXNavigationController alloc] initWithRootViewController:[FXLoginHomeController new]];
            self.window.rootViewController = nav;
        }
    }else{
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:KLoginStatus];
        WelcomeViewController *welcome = [[WelcomeViewController alloc]init];
        self.window.rootViewController = welcome;
        //保存Version
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:kBundleVersionKey];
    }
    
    
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)onReq:(BaseReq *)req{
    
}

#pragma mark --- 重写AppDelegate的handleOpenURL和openURL方法
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ORDER_ZFBPAY_NOTIFICATION" object:resultDic];
        }];
        return YES;
    }else{
        return [WXApi handleOpenURL:url delegate:self];
    }
}

-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ORDER_ZFBPAY_NOTIFICATION" object:resultDic];
        }];
        return YES;
    }else{
        return [WXApi handleOpenURL:url delegate:self];
    }
}

//如果第三方程序向微信发送了sendReq的请求，那么onResp会被回调。sendReq请求调用后，会切到微信终端程序界面。
-(void) onResp:(BaseResp*)resp{
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        if (resp.errCode == 0) {//成功授权
            //        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@""];
            if ([self.delegate respondsToSelector:@selector(loginSuccessByCode:)]) {
                SendAuthResp *resp2= (SendAuthResp*)resp;
                [self.delegate loginSuccessByCode:resp2.code];
            }
        }else{
            NSLog(@"error:%zd",resp.errCode);
            NSString *reasonStr = @"";
            if (resp.errCode == -2) {
                reasonStr = @"用户取消";
            }else if (resp.errCode == -4){
                reasonStr = @"用户拒绝授权";
            }else{
                reasonStr = @"其他";
            }
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录失败" message:[NSString stringWithFormat:@"原因 : %@",reasonStr] delegate:self cancelButtonTitle:@"取消"otherButtonTitles:@"确定",nil];
            [alert show];
        }
    }
    if ([resp isKindOfClass:[PayResp class]]) {
        if (resp.errCode == 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ORDER_PAY_NOTIFICATION" object:@"success"];
        }
    }
    
    
    
}

#pragma mark- JPUSHRegisterDelegate
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
        
        /// Required - 注册 DeviceToken
        [JPUSHService registerDeviceToken:deviceToken];
}
    
    // iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if (@available(iOS 10.0, *)) {
        if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
        }
    } else {
        // Fallback on earlier versions
    }
    if (@available(iOS 10.0, *)) {
        completionHandler(UNNotificationPresentationOptionAlert);
    } else {
        // Fallback on earlier versions
    } // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}
    
    // iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if (@available(iOS 10.0, *)) {
        if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
        }
    } else {
        // Fallback on earlier versions
    }
    completionHandler();  // 系统要求执行这个方法
}
    
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}
    
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}
@end
