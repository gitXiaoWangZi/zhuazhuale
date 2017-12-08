//
//  WelcomeViewController.m
//  TJProperty
//
//  Created by Remmo on 15/6/22.
//  Copyright (c) 2015年 bocweb. All rights reserved.
//

#import "WelcomeViewController.h"

#import "FXTabBarController.h"
#import "FXNavigationController.h"
#import "FXLoginHomeController.h"

#define kPage 3

#define kStartBtnHeight 30

@interface WelcomeViewController ()<UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;

@end

@implementation WelcomeViewController

- (void)loadView
{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(kScreenWidth * kPage, 0);
    self.view = scrollView;
    self.scrollView = scrollView;
    self.scrollView.bounces = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addScrollImages];
}

- (void)addScrollImages
{
    for (int i = 0; i < kPage; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        // 1.显示图片
        NSString *name = [NSString stringWithFormat:@"welcome_%d", i];
        imageView.image = [UIImage imageNamed:name];
        imageView.userInteractionEnabled = YES;
        // 2.设置frame
        imageView.frame = CGRectMake(self.view.width * i, 0, self.view.width, self.view.height);
        [self.scrollView addSubview:imageView];
        
        if (i == kPage - 1) {
            UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [startBtn setBackgroundImage:[UIImage imageNamed:@"welcome_btn"] forState:UIControlStateNormal];
            startBtn.frame = CGRectMake(0, kScreenHeight - 100, kScreenWidth - 40, 40);
            startBtn.centerX = self.view.centerX;
            [startBtn addTarget:self action:@selector(startBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:startBtn];
        }
    }
}

- (void)startBtnClicked:(UIButton *)sender
{
    FXLoginHomeController *logInVC = [[FXLoginHomeController alloc]init];
    FXNavigationController *nav = [[FXNavigationController alloc] initWithRootViewController:logInVC];
    self.view.window.rootViewController = nav;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (scrollView.contentOffset.x > kScreenWidth*(kPage - 1)) {
//        FXLoginHomeController *logInVC = [[FXLoginHomeController alloc]init];
//        self.view.window.rootViewController = logInVC;
//    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
