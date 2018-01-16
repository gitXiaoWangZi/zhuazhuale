//
//  FXHelpController.m
//  zzl
//
//  Created by Mr_Du on 2017/11/8.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "FXHelpController.h"
#import "DYGAddCell.h"
#import "DYGCollectionViewCell.h"
#import "MyTextView.h"

@interface FXHelpController ()<UIGestureRecognizerDelegate,UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,DYGDelectCellDelegate,TZImagePickerControllerDelegate>

@property(nonatomic,strong)UIView * bgView;
@property(nonatomic,strong)MyTextView * textV;
@property(nonatomic,strong)UICollectionView * imgCollecView;
@property(nonatomic,strong)UILabel * warnLabel;
@property(nonatomic,strong)UIImageView * QRCodeImgV;
@property(nonatomic,strong)UILabel * desLabel;
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
}
-(void)creatUI{
    [self.view addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(Py(10));
        make.left.equalTo(self.view.mas_left).offset(Px(10));
        make.right.equalTo(self.view.mas_right).offset(-Px(10));
        make.height.equalTo(@(Py(235)));
    }];
    self.bgView.layer.cornerRadius = 5;
    [self.bgView addSubview:self.textV];
    [self.textV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(Px(5));
        make.top.equalTo(self.bgView.mas_top).offset(Py(5));
        make.right.equalTo(self.bgView.mas_right).offset(-Px(5));
        make.height.equalTo(@(Py(113)));
    }];
    [self.bgView addSubview:self.imgCollecView];
    [self.imgCollecView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left);
        make.right.equalTo(self.bgView.mas_right);
        make.top.equalTo(self.textV.mas_bottom);
        make.height.equalTo(@(Py(122)));
    }];
    [self.view addSubview:self.warnLabel];
    [self.warnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgCollecView.mas_bottom).offset(Py(12));
        make.left.right.equalTo(self.imgCollecView);
    }];
    [self.view addSubview:self.submitBtn];
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.warnLabel.mas_bottom).offset(Py(42));
        make.centerX.equalTo(self.textV.mas_centerX);
        make.width.equalTo(@(Px(180)));
        make.height.equalTo(@(Py(35)));
    }];
    [self.view addSubview:self.desLabel];
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-Py(20));
        make.left.right.equalTo(self.imgCollecView);
    }];
    [self.view addSubview:self.QRCodeImgV];
    [self.QRCodeImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.desLabel.mas_top).offset(-Py(27));
        make.centerX.equalTo(self.desLabel.mas_centerX);
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
        NSString * s =  [[self Image_TransForm_Data:img] base64EncodedStringWithOptions:0];
        NSDictionary * dict = @{@"name":s};
        [self.imgDataArray addObject:dict];
        [self.dataArray addObject:img];
    }
    [self.imgCollecView  reloadData];
}
-(void)delectImgWithTag:(NSInteger)tag{
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
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = DYGColorFromHex(0xf7f7f7);
        _bgView.layer.shadowColor = DYGColorFromHex(0xececec).CGColor;
        _bgView.layer.shadowOffset = CGSizeMake(5, 5);
        _bgView.layer.shadowOpacity = 0.8;
        _bgView.layer.shadowRadius = 4;
    }
    return _bgView;
}

- (MyTextView *)textV{
    if (!_textV) {
        _textV = [[MyTextView alloc] init];
        _textV.backgroundColor = DYGColorFromHex(0xf7f7f7);
        _textV.textColor = DYGColorFromHex(0x4c4c4c);
        _textV.font = [UIFont systemFontOfSize:15];
        _textV.placeholder = @"反馈问题......";
        _textV.placeholderColor = [UIColor colorWithHexString:@"797979" alpha:1];
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
        _imgCollecView.backgroundColor = DYGColorFromHex(0xf7f7f7);
        [_imgCollecView registerClass:[DYGCollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
        [_imgCollecView registerClass:[DYGAddCell class] forCellWithReuseIdentifier:@"addCell"];
        _imgCollecView.showsHorizontalScrollIndicator = NO;
    }
    return _imgCollecView;
}

- (UILabel *)warnLabel{
    if (!_warnLabel) {
        _warnLabel = [[UILabel alloc] init];
        _warnLabel.text = @"温馨提示：请如实反馈，拒接恶意虚假信息";
        _warnLabel.textColor = DYGColorFromHex(0x797979);
        _warnLabel.font = [UIFont systemFontOfSize:15];
        _warnLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _warnLabel;
}

- (UILabel *)desLabel{
    if (!_desLabel) {
        _desLabel = [[UILabel alloc] init];
        _desLabel.text = @"如遇到问题还可联系微信客服：chaoxiangk";
        _desLabel.textColor = DYGColorFromHex(0x797979);
        _desLabel.font = [UIFont systemFontOfSize:12];
        _desLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _desLabel;
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
        _submitBtn = [UIButton buttonWithTitle:@"提交" titleColor:[UIColor whiteColor] font:17];
        [_submitBtn setBackgroundColor:DYGColorFromHex(0xfed811)];
        _submitBtn.cornerRadius = Py(17.5);
        _submitBtn.layer.masksToBounds = YES;
        [_submitBtn addTarget:self action:@selector(submitClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}
-(UIImageView *)QRCodeImgV{
    if (!_QRCodeImgV) {
        _QRCodeImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_help_QRcode"]];
    }
    return _QRCodeImgV;
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
