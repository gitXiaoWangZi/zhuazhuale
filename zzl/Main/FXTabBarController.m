//
//  FXTabBarController.m
//  zzl
//
//  Created by Mr_Du on 2017/10/30.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "FXTabBarController.h"
#import "FXNavigationController.h"
#import "FXHomeViewController.h"
#import "FXSelfViewController.h"
#import "DYGCustomTabbar.h"
#import "FXGameWaitController.h"

@interface FXTabBarController ()<DYGCustomTabbarDelegate,UITabBarControllerDelegate>
@property(nonatomic,strong)NSArray * childControllers;
@end

@implementation FXTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.tabBar.translucent = NO;
    DYGCustomTabbar * tabbar = [[DYGCustomTabbar alloc]init];
    tabbar.myTabBarDelegate = self;
    [self setValue:tabbar forKeyPath:@"tabBar"];
    [self choiseTabbar];
}

- (void)addButtonClick:(DYGCustomTabbar *)tabBar{
    
    [LSJHasNetwork lsj_hasNetwork:^(bool hasNet) {
        if (hasNet) {
            
            if (![[VisiteTools shareInstance] isVisite]) {
                [self jumpRooms];
            }else{
                [[VisiteTools shareInstance] outLogin];
            }
        }else{
            [MBProgressHUD showMessage:@"暂无网络，请连接网络后再试" toView:self.view];
        }
    }];
}

- (void)jumpRooms{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"查找房间中……";
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        [[WwRoomManager RoomMgrInstance] requestQuickStartWithComplete:^(NSInteger code, NSString *msg, WwRoom *room) {
            if (room == nil) {
                [MBProgressHUD showError:@"没有房间可以进入" toView:[UIApplication sharedApplication].keyWindow];
            }else{
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kQuitEnter"];
                FXGameWaitController * vc = [[FXGameWaitController alloc]init];
                FXNavigationController *nav = [[FXNavigationController alloc] initWithRootViewController:vc];
                vc.model = room;
                [self presentViewController:nav animated:YES completion:nil];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
            });
        }];
        
    });
}

-(void)choiseTabbar{
    self.childControllers =@[
                         @{@"ChildController":@"FXHomeViewController",@"title":@"",@"imageName":@"home"},
                         @{@"ChildController":@"FXSelfViewController",@"title":@"",@"imageName":@"me"},
                             ];
}

-(void)setChildControllers:(NSArray *)childControllers{
    _childControllers = childControllers;
    for (NSDictionary * dict in childControllers) {
        [self setChildViewCOntrollerWithDict:dict];
    }
}

-(void)setChildViewCOntrollerWithDict:(NSDictionary *)dict{
    Class childController = NSClassFromString(dict[@"ChildController"]);
    UIViewController * childVc = [(UIViewController *)[childController alloc]init];
    FXNavigationController * navVc = [[FXNavigationController alloc]initWithRootViewController:childVc];
    childVc.tabBarItem.title = dict[@"title"];
    childVc.tabBarItem.image = [UIImage imageNamed:dict[@"imageName"]];
    childVc.tabBarItem.selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",dict[@"imageName"]]];
    childVc.tabBarItem.image = [childVc.tabBarItem.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.selectedImage  =[childVc.tabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self addChildViewController:navVc];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
    if ([viewController isKindOfClass:[FXNavigationController class]]) {
        FXNavigationController *nav = (FXNavigationController *)viewController;
        if ([nav.viewControllers[0] isKindOfClass:[FXSelfViewController class]]) {
            if (![[VisiteTools shareInstance] isVisite]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshUserData" object:@"isSlef"];
            }else{
                [[VisiteTools shareInstance] outLogin];
            }
        }
    }
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    if ([viewController isKindOfClass:[FXNavigationController class]]) {
        FXNavigationController *nav = (FXNavigationController *)viewController;
        if ([nav.viewControllers[0] isKindOfClass:[FXSelfViewController class]]) {
            if (![[VisiteTools shareInstance] isVisite]) {
                return YES;
            }else{
                [[VisiteTools shareInstance] outLogin];
                return NO;
            }
        }
    }
    return YES;
}
@end
