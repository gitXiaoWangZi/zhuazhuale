//
//  AdManager.m
//  zzl
//
//  Created by Mr_Du on 2018/1/4.
//  Copyright © 2018年 Mr.Du. All rights reserved.
//

#import "AdManager.h"
#import "XHLaunchAd.h"

@implementation AdManager

+(void)load{
    [self shareManager];
}

+(AdManager *)shareManager{
    static AdManager *instance = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken,^{
        instance = [[AdManager alloc] init];
    });
    return instance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        //在UIApplicationDidFinishLaunching时初始化开屏广告,做到对业务层无干扰,当然你也可以直接在AppDelegate didFinishLaunchingWithOptions方法中初始化
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            //初始化开屏广告
            [self setupXHLaunchAd];
        }];
    }
    return self;
}

#pragma mark - 视频开屏广告-网络数据-示例
//视频开屏广告 - 网络数据
-(void)setupXHLaunchAd{
    
    //设置你工程的启动页使用的是:LaunchImage 还是 LaunchScreen.storyboard(不设置默认:LaunchImage)
    [XHLaunchAd setLaunchSourceType:SourceTypeLaunchImage];
    //配置广告数据
    XHLaunchVideoAdConfiguration *videoAdconfiguration = [XHLaunchVideoAdConfiguration defaultConfiguration];
    videoAdconfiguration.videoNameOrURLString = @"app_start.mp4";
    videoAdconfiguration.videoCycleOnce = YES;
    videoAdconfiguration.skipButtonType = SkipTypeNone;
    [XHLaunchAd videoAdWithVideoAdConfiguration:videoAdconfiguration delegate:self];
    
//    //广告frame
//    videoAdconfiguration.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
//    //广告视频URLString/或本地视频名(请带上后缀)
//    videoAdconfiguration.videoNameOrURLString = @"app_start.mp4";
//    //是否只循环播放一次
//    videoAdconfiguration.videoCycleOnce = YES;
//    //广告显示完成动画
//    videoAdconfiguration.showFinishAnimate =ShowFinishAnimateFadein;
//    //广告显示完成动画时间
//    videoAdconfiguration.showFinishAnimateTime = 0.8;
//    //后台返回时,是否显示广告
//    videoAdconfiguration.showEnterForeground = NO;
//    //跳过按钮类型
//
//    [XHLaunchAd videoAdWithVideoAdConfiguration:videoAdconfiguration delegate:self];
    
}

- (void)sdd{
    //设置你工程的启动页使用的是:LaunchImage 还是 LaunchScreen.storyboard(不设置默认:LaunchImage)
    [XHLaunchAd setLaunchSourceType:SourceTypeLaunchImage];
    
    //配置广告数据
    XHLaunchImageAdConfiguration *imageAdconfiguration = [XHLaunchImageAdConfiguration new];
    //广告停留时间
    imageAdconfiguration.duration = 2;
    //广告frame
    imageAdconfiguration.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height * 0.8);
    //广告图片URLString/或本地图片名(.jpg/.gif请带上后缀)
    imageAdconfiguration.imageNameOrURLString = @"login_backImg.png";
    //设置GIF动图是否只循环播放一次(仅对动图设置有效)
    imageAdconfiguration.GIFImageCycleOnce = NO;
    //图片填充模式
    imageAdconfiguration.contentMode = UIViewContentModeScaleAspectFill;
    //广告点击打开页面参数(openModel可为NSString,模型,字典等任意类型)
//    imageAdconfiguration.openModel = @"http://www.it7090.com";
    //广告显示完成动画
    imageAdconfiguration.showFinishAnimate =ShowFinishAnimateFlipFromLeft;
    //广告显示完成动画时间
//    imageAdconfiguration.showFinishAnimateTime = 0.8;
    //跳过按钮类型
    imageAdconfiguration.skipButtonType = SkipTypeNone;
    //后台返回时,是否显示广告
    imageAdconfiguration.showEnterForeground = NO;
    //设置要添加的子视图(可选)
    //imageAdconfiguration.subViews = [self launchAdSubViews];
    //显示开屏广告
    [XHLaunchAd imageAdWithImageAdConfiguration:imageAdconfiguration delegate:self];
}
@end
