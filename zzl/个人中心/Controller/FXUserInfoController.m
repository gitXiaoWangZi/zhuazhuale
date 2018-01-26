//
//  FXUserInfoController.m
//  zzl
//
//  Created by Mr_Du on 2017/11/4.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "FXUserInfoController.h"
#import "DYGPersonInfoTbCell.h"
#import "DYGActionSheetController.h"
#import "DYGAlertMessageController.h"
#import "FXAddressManageController.h"
#import "MOFSPickerManager.h"
#import "NSString+DYGAdd.h"
#import "AccountItem.h"
@interface FXUserInfoController ()<UITableViewDelegate,UITableViewDataSource,DYGActionSheetControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *cellConfigArr;
@property (nonatomic,strong) NSArray *dataArr;
@property (nonatomic,strong) NSArray * valueArray;
@property (nonatomic,strong) AccountItem *item;
@end

@implementation FXUserInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人资料";
    self.view.backgroundColor = BGColor;
    [self loadUserInfoData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellConfigArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DYGPersonInfoTbCell * cell = [[DYGPersonInfoTbCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"infoCell" WithConfigDict:self.cellConfigArr[indexPath.row]];
    cell.textLabel.textColor = DYGColorFromHex(0x3b3b3b);
    cell.textLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    cell.textLabel.text =[self.cellConfigArr[indexPath.row] objectForKey:@"title"];
    cell.detailTextLabel.text =self.dataArr[indexPath.row];
    cell.detailTextLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    cell.detailTextLabel.textColor = DYGColorFromHex(0x797979);
    if (indexPath.row == 0) {
        UIImageView *imageV = (UIImageView *)cell.detailView;
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(Px(44), Py(44)));
        }];
        imageV.contentMode = UIViewContentModeScaleAspectFill;
        imageV.clipsToBounds = YES;
        imageV.layer.cornerRadius = Py(22);
        [imageV sd_setImageWithURL:[NSURL URLWithString:_item.img_path] placeholderImage:[UIImage imageNamed:@"invite"]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return Py(15);
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 66;
    }
    return 55;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = DYGColorFromHex(0xe7e7e7);
    }
    return _tableView;
}
#pragma mark  =================tableView didSelect method============
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DYGPersonInfoTbCell * cell =[tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section==0) {
        if (indexPath.row==1) {
            [self showAlertWithTitle:@"昵称" WithMessage:nil WithIndexPath:indexPath];
        }else if (indexPath.row==0){
            DYGActionSheetController * vc = [DYGActionSheetController actionSheetVcWithArray:@[@"拍照",@"从相册选择"]];
            vc.delegate = self;
            [self presentViewController:vc animated:YES completion:nil];
        }else if (indexPath.row==3){
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选择性别" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                DYGLog(@"点击取消");
            }]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                DYGLog(@"%@",action.title);
                [self updateUserSex:@"男" cell:cell];
            }]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                DYGLog(@"%@",action.title);
                [self updateUserSex:@"女" cell:cell];
            }]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:alertController animated:YES completion:nil];
            });
        }else if (indexPath.row==5){
            [[MOFSPickerManager shareManger] showPickerViewWithDataArray:self.valueArray tag:1 title:nil cancelTitle:@"取消" commitTitle:@"确定" commitBlock:^(NSString *string) {
                [self updateUserEmotion:string cell:cell];
            } cancelBlock:^{
                
            }];
        }else if (indexPath.row==4){
            [[MOFSPickerManager shareManger] showDatePickerWithTag:1 commitBlock:^(NSDate *date) {
                NSDateFormatter *df = [NSDateFormatter new];
                df.dateFormat = @"yyyy";
                [self updateUserAge:([[NSString new]dataNowYear].intValue-[df stringFromDate:date].intValue) cell:cell];
            } cancelBlock:^{
                
            }];
        }
    }else{
        FXAddressManageController * vc = [FXAddressManageController  new];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)actionHandlerWith:(UIAlertAction *)action{
    if (([self conformsToProtocol:@protocol(UIImagePickerControllerDelegate)] && [self conformsToProtocol:@protocol(UINavigationControllerDelegate)])) {
        if (!([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] || [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])) {
            return;
        }
        UIImagePickerController *imgPickVc = [[UIImagePickerController alloc] init];
        imgPickVc.view.backgroundColor = [UIColor whiteColor];
        imgPickVc.delegate = self;
        imgPickVc.allowsEditing = YES;
        if ([action.title isEqualToString:@"拍照"]) {
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                imgPickVc.sourceType = UIImagePickerControllerSourceTypeCamera;
            }else{
                [DYGAlertMessageController showMessageWithTitle:@"提示" WithMessage:@"无法打开摄像头，请在【系统设置-隐私-相机】中打开访问权限" FromViewController:self];
            }
        }
        if([action.title isEqualToString:@"从手机相册选择"]) {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                imgPickVc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }else{
                [DYGAlertMessageController showMessageWithTitle:@"提示" WithMessage:@"无法打开相册，请在【系统设置-隐私-相机】中打开访问权限" FromViewController:self];
            }
        }
        [self presentViewController:imgPickVc animated:YES completion:^{
        }];
    }
}

#pragma mark 获取到图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo{
    
    NSString *iconBase = [[self Image_TransForm_Data:image] base64EncodedStringWithOptions:0];
    NSArray *iconArr = @[@{@"name":iconBase}];
    NSString *iconJs = [self arrayToJSONString:iconArr];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.label.text = @"正在提交";
    [self updateUserIcon:iconJs hud:hud];
}

-(void)showAlertWithTitle:(NSString *)title WithMessage:(NSString *)message WithIndexPath:(NSIndexPath*)indexPath{
    DYGPersonInfoTbCell * cell =[self.tableView cellForRowAtIndexPath:indexPath];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        DYGLog(@"点击取消");
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        DYGLog(@"%@",alertController.textFields.lastObject.text);
        [self updateUserInfo:title cell:cell alertV:alertController];
    }]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alertController animated:YES completion:nil];
    });
    
}

//修改用户昵称
- (void)updateUserInfo:(NSString *)title cell:(DYGPersonInfoTbCell *)cell alertV:(UIAlertController *)alterV{
    NSString *path = @"modName";
    NSDictionary *params = @{@"uid":KUID,@"name":alterV.textFields.lastObject.text};
    [DYGHttpTool postWithURL:path params:params sucess:^(id json) {
        NSDictionary *dic = (NSDictionary *)json;
        if ([dic[@"code"] integerValue] == 200) {
            cell.detailTextLabel.text =alterV.textFields.lastObject.text;
            _item.username = alterV.textFields.lastObject.text;
            NSMutableDictionary *userIngoDic = [[[NSUserDefaults standardUserDefaults] objectForKey:@"KWAWAUSER"] mutableCopy];
            [userIngoDic setValue:alterV.textFields.lastObject.text forKey:@"name"];
            [[NSUserDefaults standardUserDefaults] setObject:userIngoDic forKey:@"KWAWAUSER"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshUserData" object:nil];
            [MBProgressHUD showMessage:@"修改成功" toView:self.tableView];
        }
    } failure:^(NSError *error) {
        
    }];
    
}
//修改性别
- (void)updateUserSex:(NSString *)sex cell:(DYGPersonInfoTbCell *)cell{
    NSString *path = @"modSex";
    NSDictionary *params = @{@"uid":KUID,@"sex":sex};
    
    [DYGHttpTool postWithURL:path params:params sucess:^(id json) {
        NSDictionary *dic = (NSDictionary *)json;
        if ([dic[@"code"] integerValue] == 200) {
            cell.detailTextLabel.text =sex;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshUserData" object:nil];
            [MBProgressHUD showMessage:@"修改成功" toView:self.tableView];
        }
    } failure:^(NSError *error) {
        
    }];
}
//修改年龄
- (void)updateUserAge:(NSInteger)age cell:(DYGPersonInfoTbCell *)cell{
    NSString *path = @"modAge";
    NSDictionary *params = @{@"uid":KUID,@"age":@(age)};
    
    [DYGHttpTool postWithURL:path params:params sucess:^(id json) {
        NSDictionary *dic = (NSDictionary *)json;
        if ([dic[@"code"] integerValue] == 200) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%zd",age];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshUserData" object:nil];
            [MBProgressHUD showMessage:@"修改成功" toView:self.tableView];
        }
    } failure:^(NSError *error) {
        
    }];
}
//修改感情状况
- (void)updateUserEmotion:(NSString *)emotion cell:(DYGPersonInfoTbCell *)cell{
    NSString *path = @"modEmotion";
    NSDictionary *params = @{@"uid":KUID,@"emotion":emotion};
    
    [DYGHttpTool postWithURL:path params:params sucess:^(id json) {
        NSDictionary *dic = (NSDictionary *)json;
        if ([dic[@"code"] integerValue] == 200) {
            cell.detailTextLabel.text = emotion;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshUserData" object:nil];
            [MBProgressHUD showMessage:@"修改成功" toView:self.tableView];
        }
    } failure:^(NSError *error) {
        
    }];
}
//修改头像
- (void)updateUserIcon:(NSString *)data hud:(MBProgressHUD *)hud{
    NSString *path = @"upDataImg";
    NSDictionary *params = @{@"uid":KUID,@"img_file":data,@"type":@"head"};
    [DYGHttpTool postWithURL:path params:params sucess:^(id json) {
        [hud hideAnimated:YES];
        NSDictionary *dic = (NSDictionary *)json;
        if ([dic[@"code"] integerValue] == 200) {
            NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
            DYGPersonInfoTbCell *cell = (DYGPersonInfoTbCell *)[self.tableView cellForRowAtIndexPath:index];
            UIImageView *imageV = (UIImageView *)cell.detailView;
            [imageV sd_setImageWithURL:[NSURL URLWithString:dic[@"img_path"]] placeholderImage:[UIImage imageNamed:@"鱿鱼center"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshUserData" object:nil];
            
            NSMutableDictionary *userIngoDic = [[[NSUserDefaults standardUserDefaults] objectForKey:@"KWAWAUSER"] mutableCopy];
            [userIngoDic setValue:@"333" forKey:@"img"];
            [[NSUserDefaults standardUserDefaults] setObject:userIngoDic forKey:@"KWAWAUSER"];
        }
    } failure:^(NSError *error) {
        [hud hideAnimated:YES];
    }];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
#pragma mark lazy load
-(NSArray *)cellConfigArr{
    if (!_cellConfigArr) {
        _cellConfigArr = @[@{@"title":@"头像",@"accesoryType":@"indicator",@"detailView":@"UIImageView"},
                           @{@"title":@"昵称",@"accesoryType":@"indicator"},
                           @{@"title":@"ID",@"accesoryType":@"none"},
                           @{@"title":@"性别",@"accesoryType":@"indicator"},
                           @{@"title":@"年龄",@"accesoryType":@"indicator"},
                           @{@"title":@"情感状况",@"accesoryType":@"indicator"},
                           ];
    }
    return _cellConfigArr;
}

-(NSArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSArray array];
    }
    return _dataArr;
}

-(NSArray *)valueArray{
    if (!_valueArray) {
        _valueArray = @[@"单身",@"恋爱",@"保密",@"已婚",@"同性"];
    }
    return _valueArray;
}

//传入图片数组，转成json字符串
-(NSString *)arrayToJSONString:(NSArray *)array
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}
-(NSData *)Image_TransForm_Data:(UIImage *)image{
    NSData * imageData = UIImageJPEGRepresentation(image, 0.5);
    return imageData;
}

#pragma mark ---请求用户信息数据
- (void)loadUserInfoData{
    
    NSString *path = @"getUserInfo";
    NSDictionary *params = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KUser_ID]};
    [DYGHttpTool postWithURL:path params:params sucess:^(id json) {
        NSDictionary *dic = (NSDictionary *)json;
        if ([dic[@"code"] intValue] == 200) {
            _item = [AccountItem mj_objectWithKeyValues:dic[@"data"][0]];
            self.dataArr = @[@"",_item.username,_item.ID,_item.sex,_item.age,_item.emotion,_item.profession];
            [self.view addSubview:self.tableView];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}
@end










