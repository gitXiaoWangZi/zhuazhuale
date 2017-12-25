//
//  FXZZLViewController.m
//  zzl
//
//  Created by Mr_Du on 2017/11/1.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "FXZZLViewController.h"
#import "FXRoomCell.h"
#import "DYGPopViewMenu.h"
#import "FXGameWaitController.h"
@interface FXZZLViewController ()<UIGestureRecognizerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,DYGPopViewMenuDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) UIButton *priceBtn;
@property (nonatomic,strong) UIButton *stateBtn;
@property (nonatomic,strong) UIView *topView;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) DYGPopViewMenu *popView;

@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,strong)  NSMutableArray *roomsArray;

@end

@implementation FXZZLViewController

#pragma ======================controller life cycle======================

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([viewController isKindOfClass:[self class]]) {
        [navigationController setNavigationBarHidden:NO animated:YES];
    }else {
        [navigationController setNavigationBarHidden:YES animated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"抓抓乐";
    self.view.backgroundColor = randomColor;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.delegate = self;
    [self creatTopView];
    [self loadNewData];
}

-(void)creatTopView{
    self.topView = [UIView viewWithFrame:CGRectMake(0, 0, kScreenWidth, Py(40)) WithBackGroundColor:BGColor];
    [self.view addSubview:self.topView];
    self.collectionView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64);
    [self.view addSubview:self.collectionView];
    
//    [self.topView addSubview:self.priceBtn];
//    [self.topView addSubview:self.stateBtn];
//    [@[self.priceBtn,self.stateBtn]mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
//    [@[self.priceBtn,self.stateBtn]mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(self.topView);
//    }];
//    [_stateBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -_stateBtn.imageView.bounds.size.width, 0, _stateBtn.imageView.bounds.size.width)];
//    [_stateBtn setImageEdgeInsets:UIEdgeInsetsMake(0, _stateBtn.titleLabel.bounds.size.width, 0, -_stateBtn.titleLabel.bounds.size.width-10)];
//    [_priceBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -_priceBtn.imageView.bounds.size.width, 0, _priceBtn.imageView.bounds.size.width)];
//    [_priceBtn setImageEdgeInsets:UIEdgeInsetsMake(0, _priceBtn.titleLabel.bounds.size.width, 0, -_priceBtn.titleLabel.bounds.size.width-10)];
// creat collectionView
//    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.equalTo(self.view);
//        make.top.equalTo(self.topView.mas_bottom);
//    }];
}

#pragma  ========================system Delegae========================

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.roomsArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * reuserId= @"roomCell";
    FXRoomCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuserId forIndexPath:indexPath];
    cell.model = self.roomsArray[indexPath.row];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(Px(164),Py(164));
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(Py(15),Px(16),Py(15),Px(16));
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    FXGameWaitController * vc= [[FXGameWaitController alloc]init];
    vc.model = self.roomsArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark  Click Selector

-(void)stateBtnClick{
    self.stateBtn.selected = !self.stateBtn.selected;
    self.stateBtn.selected==YES?[self creatPopView]:[self popViewDismissWithSelf:self.popView];
    
}
-(void)creatPopView{
    self.popView = [[DYGPopViewMenu alloc]initWithFrame:CGRectMake(0, 100, kScreenWidth, 100)];
//    self.popView.lineNum = 3;
    self.popView.titleArr = @[@"游戏中",@"空闲中",@"补货中"];
    self.popView.delegate= self;
    [self.view addSubview:self.popView];
    [self.popView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}
-(void)priceBtnClick{
    self.priceBtn.selected = !self.priceBtn.selected;
}
//弹出视图取消
-(void)popViewDismissWithSelf:(DYGPopViewMenu *)menu{
    self.stateBtn.selected = NO;
    menu.isHidPopView = YES;
}


#pragma  ========================lazy load======================
-(UIButton *)priceBtn{
    if (!_priceBtn) {
        
        _priceBtn = [UIButton buttonWithImage:@"high" WithTitle:@"价格" WithColor:TextColor WithFont:16];
        [_priceBtn setImage:[UIImage imageNamed:@"low"] forState:UIControlStateSelected];
        [_priceBtn addTarget:self action:@selector(priceBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _priceBtn;
}
-(UIButton *)stateBtn{
    if (!_stateBtn) {
        _stateBtn = [UIButton buttonWithImage:@"down" WithTitle:@"机器状态" WithColor:TextColor WithFont:16];
        [_stateBtn setImage:[UIImage imageNamed:@"up"] forState:UIControlStateSelected];
        [_stateBtn addTarget:self action:@selector(stateBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _stateBtn;
}
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumLineSpacing=Py(15);
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.width,self.view.height) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[FXRoomCell class] forCellWithReuseIdentifier:@"roomCell"];
        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        _collectionView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}
- (NSMutableArray *)roomsArray {
    if (!_roomsArray) {
        _roomsArray = [NSMutableArray array];
    }
    return _roomsArray;
}

#pragma mark --- 请求房间列表数据
- (void)loadNewData{
    _currentPage = 1;
    [self loadDataWithPage:_currentPage];
}

- (void)loadMoreData{
    _currentPage ++;
    [self loadDataWithPage:_currentPage];
}

- (void)loadDataWithPage:(NSInteger)page{
    [[WwRoomManager RoomMgrInstance] requestRoomList:page size:100 withComplete:^(NSInteger code, NSString *message, NSArray<WwRoom *> *list) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        if (!code) {
            // 成功
            if (page == 1) {
                [self.roomsArray removeAllObjects];
            }
            for (WwRoom *model in list) {
                [self.roomsArray addObject:model];
            }
            [self.collectionView reloadData];
            DYGLog(@"查找房间成功");
        }
        else {
            // 失败
            DYGLog(@"查找房间失败---%@",message);
        }
    }];
}

@end
