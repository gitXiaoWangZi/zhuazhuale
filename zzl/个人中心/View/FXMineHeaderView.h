//
//  FXSelfHeaderView.h
//  zzl
//
//  Created by Mr_Du on 2017/11/6.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AccountItem;
@protocol FXMineHeaderViewDelegate<NSObject>

@optional

-(void)editBtnDidClick;
-(void)viewTouchWithTag:(NSInteger)tag;

@end

@interface FXMineHeaderView : UIView

@property (nonatomic,weak) id<FXMineHeaderViewDelegate> delegate;
@property (nonatomic,strong) AccountItem *item;
@end

