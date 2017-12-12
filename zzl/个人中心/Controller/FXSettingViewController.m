//
//  FXSettingViewController.m
//  zzl
//
//  Created by Mr_Du on 2017/11/8.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "FXSettingViewController.h"
#import "FXSwitchCell.h"
#import "FXExitCell.h"
#import "FXAboutUsController.h"
#import "FXLoginHomeController.h"
#import "FXNavigationController.h"
#import <FCFileManager/FCFileManager.h>


#define kSYAccompanyFolderPath [FCFileManager pathForDocumentsDirectoryWithPath:@"SYAccompany"]
@interface FXSettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong) NSArray *titleArr;
@property (nonatomic,strong) MBProgressHUD *hud;

@end

@implementation FXSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
//    self.titleArr =@[@"背景音乐",@"音效",@"消息推送",@"麦克风/照相机权限",@"清除缓存",@"关于我们"];
    self.titleArr =@[@"清除缓存",@"关于我们"];
    [self.view addSubview:self.tableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    switch (section) {
//        case 0:
//            return 4;
//            break;
//        case 1:
//            return 2;
//        default:
//            return 1;
//            break;
//    }
    switch (section) {
        case 0:
            return 2;
            break;
        default:
            return 1;
            break;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *resueId =@"";
    if (indexPath.section==0) {
        resueId =@"cell";
        UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:resueId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = self.titleArr[indexPath.row];
        cell.textLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        cell.textLabel.textColor =DYGColorFromHex(0x4c4c4c);
        if (indexPath.row == 0) {
            cell.detailTextLabel.text = [self getCacheSize];
        }
        return cell;
//        resueId= @"switchCell";
//        FXSwitchCell * cell = [[FXSwitchCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:resueId];
//        cell.title.text = self.titleArr[indexPath.row];
//        return cell;
//    }else if (indexPath.section==1){
//        resueId =@"cell";
//        UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:resueId];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.textLabel.text = self.titleArr[indexPath.row+4];
//        cell.textLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
//        cell.textLabel.textColor =DYGColorFromHex(0x4c4c4c);
//        return cell;
    }else{
        resueId =@"exitCell";
        FXExitCell * cell =[[FXExitCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:resueId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section>0) {
        return Py(10);
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section>0) {
        return [UIView new];
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Py(44);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0&&indexPath.row==0) {
        [self clearCache];
    }
    if (indexPath.section==0&&indexPath.row==1) {
        FXAboutUsController * vc = [FXAboutUsController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section==1) {
        
        UIAlertController *alterC = [UIAlertController alertControllerWithTitle:@"确定退出登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [[WwUserInfoManager UserInfoMgrInstance] logout];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:KLoginStatus];
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KUser_ID];
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"KWAWAUSER"];
            UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
            FXNavigationController *nav = [[FXNavigationController alloc] initWithRootViewController:[[FXLoginHomeController alloc] init]];
            window.rootViewController = nav;
        }];
        [alterC addAction:cancelAction];
        [alterC addAction:okAction];
        [self presentViewController:alterC animated:YES completion:nil];
    }
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = BGColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorColor =BGColor;
    }
    return _tableView;
}

- (NSString *)getCacheSize {
    NSUInteger cacheSize = ([[SDImageCache sharedImageCache] getSize] + [[FCFileManager sizeOfDirectoryAtPath:[FCFileManager pathForDocumentsDirectoryWithPath:@"SYAccompany"]] integerValue]) >> 10;
    NSString *size = @"";
    if (cacheSize<1024) {
        size = [NSString stringWithFormat:@"%dK", (int)cacheSize];
    }
    else if (cacheSize < 1024*1024) {
        size = [NSString stringWithFormat:@"%0.1fM", cacheSize/1024.0f];
    }
    else {
        size = [NSString stringWithFormat:@"%0.1fG", cacheSize/(1024*1024.0f)];
    }
    return size;
}


#pragma mark - 清除缓存
- (void)clearCache
{
    UIAlertController *actionSheetVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"确定清除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        SDImageCache *imageCache = [SDWebImageManager sharedManager].imageCache;
        [imageCache clearMemory];
        [imageCache clearDiskOnCompletion:^{
            [MBProgressHUD showMessage:@"清理完毕" toView:self.tableView];
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            [cell.detailTextLabel setText:@"0K"];
        }];
        
        [FCFileManager removeItemsInDirectoryAtPath:kSYAccompanyFolderPath];
    }];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [actionSheetVC addAction:action0];
    [actionSheetVC addAction:action1];
    [self presentViewController:actionSheetVC animated:YES completion:nil];

}
@end
