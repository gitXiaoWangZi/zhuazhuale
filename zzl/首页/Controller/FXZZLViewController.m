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
#import "LSJGameViewController.h"
@interface FXZZLViewController ()<UIGestureRecognizerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,DYGPopViewMenuDelegate>

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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"娃娃列表";
    self.view.backgroundColor = randomColor;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
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
    [cell dealLineWithIndex:indexPath];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(((kScreenWidth - 20)/2.0),Py(210));
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(Py(0),Px(9),Py(0),Px(9));
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    LSJGameViewController *game = [[LSJGameViewController alloc] init];
    game.model = self.roomsArray[indexPath.row];
    [self.navigationController pushViewController:game animated:YES];
}

#pragma mark  Click Selector

-(void)stateBtnClick{
    self.stateBtn.selected = !self.stateBtn.selected;
    self.stateBtn.selected==YES?[self creatPopView]:[self popViewDismissWithSelf:self.popView];
    
}
-(void)creatPopView{
    self.popView = [[DYGPopViewMenu alloc]initWithFrame:CGRectMake(0, 100, kScreenWidth, 100)];
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
        flowLayout.minimumLineSpacing=0;
        flowLayout.minimumInteritemSpacing = 0;
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.width,self.view.height) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[FXRoomCell class] forCellWithReuseIdentifier:@"roomCell"];
        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        footer.stateLabel.font = [UIFont systemFontOfSize:14];
        footer.stateLabel.textColor = DYGColorFromHex(0xB4B4B4);
        [footer setTitle:@"(/≧▽≦)/伦家可是有底线的娃娃机~" forState:MJRefreshStateNoMoreData];
        _collectionView.mj_footer = footer;
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
            if (list.count < 100) {
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
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
