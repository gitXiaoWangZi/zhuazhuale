//
//  FXOnlineView.h
//  zzl
//
//  Created by Mr_Du on 2017/11/2.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DYGOnlineCommentDelegate<NSObject>

@optional

-(void)playGameAction;

-(void)commentViewPop;

-(void)rechargeBtnDidClick;

-(void)cameraBtnDidClick:(UIButton *)sender;

-(void)popToView;
@end


@interface FXOnlineView : UIView

@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,weak) id<DYGOnlineCommentDelegate> delegate;
@property (nonatomic,assign) NSInteger roomID;

@property (nonatomic,strong) UILabel *balance;
@property (nonatomic,strong) UIButton *price;
@property (nonatomic,strong) UIButton *peopleNum;
@property (nonatomic,strong) UIButton *pingBtn;
@property (nonatomic,strong) UILabel *gameState;
@property (nonatomic,strong) UIView *playView;

@property (nonatomic,strong) WwUser *model;
/*
 *围观列表数组
 */
@property (nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,strong) UICollectionView * collectionView;
@property (nonatomic,strong) UIView *defaultPlayView;
@end
