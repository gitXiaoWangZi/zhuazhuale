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
@property (nonatomic,strong) NSArray *dataArr;
@property (nonatomic,strong) MBProgressHUD *hud;

@end

@implementation FXSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [self addFooterView];
}

- (NSArray *)dataArr{
    if (!_dataArr) {
        _dataArr = @[@[@{@"image":@"mine_setting_Soundeffect",@"name":@"音效"},
                          @{@"image":@"mine_setting_news",@"name":@"消息推送"}],
                        @[@{@"image":@"mine_setting_Clear",@"name":@"清除缓存"},
                          @{@"image":@"mine_setting_aboutus",@"name":@"关于我们"}]];
    }
    return _dataArr;
}

- (UIView *)addFooterView{
    UIView *bgV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, Py(130))];
    bgV.backgroundColor = [UIColor whiteColor];
    
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(12, 0, kScreenWidth-12, 0.5)];
    lineV.backgroundColor = DYGColorFromHex(0xe7e7e7);
    [bgV addSubview:lineV];
    
    UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [exitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [exitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    exitBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    exitBtn.backgroundColor = DYGColorFromHex(0xfed811);
    [exitBtn addTarget:self action:@selector(exitAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgV addSubview:exitBtn];
    [exitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bgV.mas_bottom).offset(-Py(20));
        make.centerX.equalTo(bgV.mas_centerX);
        make.width.equalTo(@(Px(180)));
        make.height.equalTo(@(Py(35)));
    }];
    exitBtn.layer.cornerRadius = 17.5f;
    return bgV;
}

- (void)exitAction:(UIButton *)sender{
    UIAlertController *alterC = [UIAlertController alertControllerWithTitle:@"确定退出登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [[WwUserInfoManager UserInfoMgrInstance] logout];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:KLoginStatus];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KUser_ID];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"KWAWAUSER"];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:Kfirstpunch];
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        FXNavigationController *nav = [[FXNavigationController alloc] initWithRootViewController:[[FXLoginHomeController alloc] init]];
        window.rootViewController = nav;
    }];
    [alterC addAction:cancelAction];
    [alterC addAction:okAction];
    [self presentViewController:alterC animated:YES completion:nil];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *tempArr = self.dataArr[section];
    return tempArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *resueId =@"";
    if (indexPath.section==0) {
        resueId= @"switchCell";
        FXSwitchCell * cell = [[FXSwitchCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:resueId];
        cell.title.text = self.dataArr[indexPath.section][indexPath.row][@"name"];
        cell.icon.image = [UIImage imageNamed:self.dataArr[indexPath.section][indexPath.row][@"image"]];
        return cell;
    }else{
        resueId =@"cell";
        UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:resueId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = self.dataArr[indexPath.section][indexPath.row][@"name"];
        cell.imageView.image = [UIImage imageNamed:self.dataArr[indexPath.section][indexPath.row][@"image"]];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = DYGColorFromHex(0x3b3b3b);
        if (indexPath.row == 0) {
            cell.detailTextLabel.text = [self getCacheSize];
        }
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section>0) {
        return Py(10);
    }
    return Py(15);
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, Py(10))];
    lineV.backgroundColor = DYGColorFromHex(0xf7f7f7);
    return lineV;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Py(55);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1&&indexPath.row==0) {
        [self clearCache];
    }
    if (indexPath.section==1&&indexPath.row==1) {
        FXAboutUsController * vc = [FXAboutUsController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = DYGColorFromHex(0xe7e7e7);
        _tableView.separatorInset=UIEdgeInsetsMake(0, 12, 0, 0);
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
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
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
