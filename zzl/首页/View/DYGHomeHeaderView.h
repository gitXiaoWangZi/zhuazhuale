//
//  DYGHomeHeaderView.h
//  CS2.1
//
//  Created by Mr_Du on 2017/8/4.
//  Copyright © 2017年 Mr_Du. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RMBMeButton;
@protocol DYGHeaderImageViewDelegate <NSObject>

@optional

-(void)loadWebViewWithImgIndex:(NSInteger)index;

@end


@interface DYGHomeHeaderView : UIView

@property(nonatomic,weak)NSTimer * timer;
@property (nonatomic,strong) NSArray * adArray;
@property (nonatomic,strong) UIImageView * scrollImage;
@property (nonatomic,weak) id<DYGHeaderImageViewDelegate> delegate;
@property (nonatomic,strong) NSArray *scrollAdArr;
-(void)starTimer;
-(void)beginScroll;
-(void)stopScroll;

@end
