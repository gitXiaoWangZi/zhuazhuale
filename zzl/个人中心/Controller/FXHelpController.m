//
//  FXHelpController.m
//  zzl
//
//  Created by Mr_Du on 2017/11/8.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "FXHelpController.h"
//#import "DYGTextView.h"
#import "DYGAddCell.h"
#import "DYGCollectionViewCell.h"
#import "MyTextView.h"

@interface FXHelpController ()<UIGestureRecognizerDelegate,UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,DYGDelectCellDelegate,TZImagePickerControllerDelegate>

//@property(nonatomic,strong)DYGTextView * inputTextView;
@property(nonatomic,strong)MyTextView * textV;
@property(nonatomic,strong)UICollectionView * imgCollecView;
@property(nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,strong)NSMutableArray * imgDataArray;
@property (nonatomic,strong) NSMutableArray *indexArr;
@property (nonatomic,strong) UIButton *submitBtn;
@end

@implementation FXHelpController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title =@"帮助与反馈";
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatUI];
    [self.view addSubview:self.textV];
}
-(void)creatUI{
    [self.view addSubview:self.textV];
    [self.textV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(Px(16));
        make.top.equalTo(self.view).offset(Py(13));
        make.right.equalTo(self.view).offset(-Px(16));
        make.height.equalTo(@(Py(200)));
    }];
    [self.view addSubview:self.imgCollecView];
    [self.imgCollecView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.textV);
        make.top.equalTo(self.textV.mas_bottom);
        make.height.equalTo(@(Py(108)));
    }];
    [self.view addSubview:self.submitBtn];
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgCollecView.mas_bottom).offset(Py(35));
        make.left.right.equalTo(self.imgCollecView);
        make.height.equalTo(@(Py(44)));
    }];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count+1;
}
//cell展示的内容

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString * CellIdentifier;
    if (indexPath.row==self.dataArray.count) {
        CellIdentifier = @"addCell";
        DYGAddCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        return cell;
    }else{
        CellIdentifier = @"UICollectionViewCell";
        DYGCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.delegate = self;
        cell.imgView.image = self.dataArray[indexPath.row];
        cell.tag = indexPath.row;
        //        NSDictionary * dic = self.dataArray[indexPath.row];
        //        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:dic[@"img_path"]]];
        return cell;
    }
}
//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(Px(75),Py(80));
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0,15, 0, 15) ;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==self.dataArray.count) {
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }
}
-(void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    for (UIImage * img in photos) {
        //        DYGLog(@"Data:%@",[self Image_TransForm_Data:img]);
        NSString * s =  [[self Image_TransForm_Data:img] base64EncodedStringWithOptions:0];
        NSDictionary * dict = @{@"name":s};
        [self.imgDataArray addObject:dict];
        [self.dataArray addObject:img];
    }
    [self.imgCollecView  reloadData];
}
-(void)delectImgWithTag:(NSInteger)tag{
//    [self.indexArr removeObjectAtIndex:tag];
    [self.dataArray removeObjectAtIndex:tag];
    [self.imgCollecView reloadData];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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

#pragma mark lazy load

//-(DYGTextView *)inputTextView{
//    if (!_inputTextView) {
//        _inputTextView = [[DYGTextView alloc]init];
//        _inputTextView.backgroundColor = BGColor;
//        _inputTextView.textColor = DYGColorFromHex(0x4c4c4c);
//        _inputTextView.font = [UIFont systemFontOfSize:15];
//        _inputTextView.placeholder = @"非常抱歉，由于我们的疏忽给您带来不便，请将您遇到的问题/产品建议反馈给我们。为了我们能及时修复问题，请尽量将您碰到的问题描述清楚,(包括但不限于)时间、房间、娃娃、问题说明等，非常感谢！";
//        _inputTextView.placeholderTextColor = [UIColor colorWithHexString:@"c6c6c6" alpha:1];
//    }
//    return _inputTextView;
//}
- (MyTextView *)textV{
    if (!_textV) {
        _textV = [[MyTextView alloc] init];
        _textV.backgroundColor = BGColor;
        _textV.textColor = DYGColorFromHex(0x4c4c4c);
        _textV.font = [UIFont systemFontOfSize:15];
        _textV.placeholder = @"非常抱歉，由于我们的疏忽给您带来不便，请将您遇到的问题/产品建议反馈给我们。为了我们能及时修复问题，请尽量将您碰到的问题描述清楚,(包括但不限于)时间、房间、娃娃、问题说明等，非常感谢！";
        _textV.placeholderColor = [UIColor colorWithHexString:@"c6c6c6" alpha:1];
    }
    return _textV;
}
-(UICollectionView *)imgCollecView{
    if (!_imgCollecView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _imgCollecView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 142, kScreenWidth,94) collectionViewLayout:flowLayout];
        _imgCollecView.delegate = self;
        _imgCollecView.dataSource = self;
        _imgCollecView.backgroundColor = BGColor;
        [_imgCollecView registerClass:[DYGCollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
        [_imgCollecView registerClass:[DYGAddCell class] forCellWithReuseIdentifier:@"addCell"];
        _imgCollecView.showsHorizontalScrollIndicator = NO;
    }
    return _imgCollecView;
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = @[].mutableCopy;
    }
    return _dataArray;
}
-(NSMutableArray *)imgDataArray{
    if (!_imgDataArray) {
        _imgDataArray = @[].mutableCopy;
    }
    return _imgDataArray;
}
-(NSMutableArray *)indexArr{
    if (!_indexArr) {
        _indexArr = @[].mutableCopy;
    }
    return _indexArr;
}
-(UIButton *)submitBtn{
    if (!_submitBtn) {
        _submitBtn = [UIButton buttonWithTitle:@"完成" titleColor:[UIColor whiteColor] font:16];
        [_submitBtn setBackgroundColor:systemColor];
        _submitBtn.cornerRadius = Py(22);
        _submitBtn.layer.masksToBounds = YES;
        [_submitBtn addTarget:self action:@selector(submitClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}

//提交数据
- (void)submitClick:(UIButton *)sender{
    if (self.textV.text == nil || [self.textV.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"请输入内容" toView:self.view];
        return;
    }
    NSString *path = @"submitHelp";
    NSDictionary *params = @{@"uid":KUID,@"content":self.textV.text,@"img_data":[self arrayToJSONString:self.imgDataArray],@"Os":@"ios"};
    [DYGHttpTool postWithURL:path params:params sucess:^(id json) {
        NSDictionary *dic = (NSDictionary *)json;
        if ([dic[@"code"] integerValue] == 200) {
            [MBProgressHUD showMessage:@"提交成功" toView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
@end
