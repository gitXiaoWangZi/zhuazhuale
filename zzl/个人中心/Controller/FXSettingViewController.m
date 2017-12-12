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
        [self cleanCaches];
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

#pragma mark - 清除缓存
- (void)cleanCaches
{
    NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
    for (NSString *p in files) {
        NSError *error;
        NSString *path = [cachPath stringByAppendingPathComponent:p];
//        float fileSize = [self sizeOfFolderAtPath:cachPath];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        }
        [MBProgressHUD showSuccess:@"清除成功" toView:self.tableView];
    }
}

- (float)sizeOfFolderAtPath:(NSString*)folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self sizeOfFileAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}


- (long long)sizeOfFileAtPath:(NSString *)filePath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]) {
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

@end
