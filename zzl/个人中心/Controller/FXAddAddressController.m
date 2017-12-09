//
//  FXAddAddressController.m
//  zzl
//
//  Created by Mr_Du on 2017/11/7.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "FXAddAddressController.h"
#import "DYGPersonInfoTbCell.h"
#import "FXTFCell.h"
#import "FXSwitchCell.h"
#import "DYGTextView.h"
#import <ContactsUI/ContactsUI.h>
#import "MOFSPickerManager.h"
@interface FXAddAddressController ()<UITableViewDelegate,UITableViewDataSource,CNContactPickerDelegate,UITextViewDelegate>

@property(nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong) UIView * chooseView;
@property (nonatomic,strong) NSArray * titleArr;
@property (nonatomic,strong) DYGTextView * addressView;


@end

@implementation FXAddAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isAdd) {
        self.title = @"添加新地址";
    }else{
        self.title = @"修改地址";
    }
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [UIView new];
    [self creatChooseView];
    [self creatSaveBtn];
    
}

-(void)creatSaveBtn{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
}
-(void)save{
    FXTFCell *cell0 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    FXTFCell *cell1 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    UITableViewCell *cell2 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    FXSwitchCell *cell3 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    if (cell0.inputTF.text == nil || [cell0.inputTF.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"收货人为空" toView:self.view];
        return;
    }
    if (cell1.inputTF.text == nil || [cell1.inputTF.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"联系方式为空" toView:self.view];
        return;
    }
    if ([cell2.detailTextLabel.text isEqualToString:@"请选择"]) {
        [MBProgressHUD showError:@"地区为空" toView:self.view];
        return;
    }
    NSArray *adressArr = [cell2.detailTextLabel.text componentsSeparatedByString:@"-"];
    if (adressArr.count != 3) {
        [MBProgressHUD showError:@"地址有误" toView:self.view];
    }
    if ([self.addressView.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"详细地址为空" toView:self.view];
        return;
    }
    if (self.isAdd) {
        [[WwUserInfoManager UserInfoMgrInstance] addUserAddress:^(WwAddressModel *address) {
            NSLog(@"%@",address);
            address.name = cell0.inputTF.text;
            address.phone = cell1.inputTF.text;
            address.province = adressArr[0];
            address.city = adressArr[1];
            address.district = adressArr[2];
            address.address = self.addressView.text;
            address.isDefault = cell3.open.on;
        } withCompleteHandler:^(int code, NSString *message) {
            NSLog(@"%zd----%@",code,message);
            if (code == 0) {
                [MBProgressHUD showSuccess:@"添加成功" toView:self.view];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshAddress" object:nil];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }else{
                [MBProgressHUD showMessage:@"参数非法" toView:self.view];
            }
        }];
    }else{
        [[WwUserInfoManager UserInfoMgrInstance] updateUserAddress:^(WwAddressModel *upAddress) {
            upAddress.name = cell0.inputTF.text;
            upAddress.phone = cell1.inputTF.text;
            upAddress.province = adressArr[0];
            upAddress.city = adressArr[1];
            upAddress.district = adressArr[2];
            upAddress.address = self.addressView.text;
            upAddress.isDefault = cell3.open.on;
            upAddress.aID = self.model.aID;
        } withCompleteHandler:^(int code, NSString *message) {
            NSLog(@"%zd----%@",code,message);
            if (code == 0) {
                [MBProgressHUD showSuccess:@"修改成功" toView:self.view];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshAddress" object:nil];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }else{
                
                [MBProgressHUD showMessage:@"参数非法" toView:self.view];
            }
        }];
    }
    
}

-(void)creatChooseView{
    self.chooseView =[UIView new];
    self.chooseView.backgroundColor =[UIColor whiteColor];
    self.chooseView.borderColor = BGColor;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseUser)];
    [self.chooseView addGestureRecognizer:tap];
    self.chooseView.layer.borderWidth = 1;
    [self.view addSubview:self.chooseView];
    [self.chooseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(Px(83), Py(88)));
    }];
    UIImageView *img=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"contact"]];
    [img sizeToFit];
    [self.chooseView addSubview:img];
    UILabel * label = [UILabel labelWithMediumFont:13 WithTextColor:DYGColorFromHex(0x4c4c4c)];
    label.text = @"选择联系人";
    [self.chooseView addSubview:label];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.chooseView);
        make.top.equalTo(self.chooseView).offset(Py(21));
    }];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.chooseView);
        make.top.equalTo(img.mas_bottom).offset(Py(8));
    }];
    
}
-(void)chooseUser{
    CNContactPickerViewController *contactPickerViewController = [[CNContactPickerViewController alloc] init];
    contactPickerViewController.delegate = self;
    [self presentViewController:contactPickerViewController animated:YES completion:nil];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact {
    [self printContactInfo:contact];
}
- (void)printContactInfo:(CNContact *)contact {
    NSString *givenName = contact.givenName;
    NSString *familyName = contact.familyName;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    FXTFCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.inputTF.text = [NSString stringWithFormat:@"%@%@",familyName,givenName];
    NSArray * phoneNumbers = contact.phoneNumbers;
    for (CNLabeledValue<CNPhoneNumber*>*phone in phoneNumbers) {
        CNPhoneNumber *phonNumber = (CNPhoneNumber *)phone.value;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        FXTFCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.inputTF.text = phonNumber.stringValue;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 3;
            break;
        default:
            return 1;
            break;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if (indexPath.row>1) {
            UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell1"];
            cell.textLabel.text =@"所在地区";
            cell.textLabel.textColor = DYGColorFromHex(0x4c4c4c);
            cell.textLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
            cell.detailTextLabel.textColor = DYGColorFromHex(0x999999);
            cell.detailTextLabel.font =[UIFont fontWithName:@"PingFangSC-Medium" size:14];
            
            if (self.isAdd) {
                cell.detailTextLabel.text =@"请选择";
            }else{
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@-%@-%@",self.model.province,self.model.city,self.model.district];
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            FXTFCell * cell = [[FXTFCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.leftLabel.text = self.titleArr[indexPath.row];
            if (!self.isAdd) {
                if (indexPath.row == 0) {
                    cell.inputTF.text = self.model.name;
                }else{
                    cell.inputTF.text = self.model.phone;
                }
            }
            return cell;
        }
    }else{
        FXSwitchCell * cell = [[FXSwitchCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"switch"];
        if (!self.isAdd) {
            [cell.open setOn:self.model.isDefault];
        }
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section==0&&indexPath.row==2) {
        [self.view endEditing:YES];
        [[MOFSPickerManager shareManger] showMOFSAddressPickerWithDefaultAddress:nil title:@"" cancelTitle:@"取消" commitTitle:@"确定" commitBlock:^(NSString *address, NSString *zipcode) {
            cell.detailTextLabel.text = address;
        } cancelBlock:^{
            
        }];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return Py(44);
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==0) {
        self.addressView = [[DYGTextView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, Py(85))];
        self.addressView.placeholder =@"请填写详细地址";
        self.addressView.returnKeyType = UIReturnKeyDone;
        self.addressView.delegate = self;
        if (!self.isAdd) {
            self.addressView.text = self.model.address;
        }
        self.addressView.placeholderTextColor =DYGColorFromHex(0x999999);
        self.addressView.textColor = DYGColorFromHex(0x999999);
        self.addressView.tintColor = systemColor;
        self.addressView.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        return self.addressView;
    }
    return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        return Py(85);
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==1) {
        return Py(10);
    }
    return 0;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [self.view endEditing:YES];
        return NO;
    }
    return YES;
}

#pragma mark lazy load

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.separatorColor = BGColor;
    }
    return _tableView;
}
-(NSArray *)titleArr{
    if (!_titleArr) {
        _titleArr = @[@"收货人",@"联系方式"];
    }
    return _titleArr;
}

@end
