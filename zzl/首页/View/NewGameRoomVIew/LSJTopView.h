//
//  LSJTopView.h
//  zzl
//
//  Created by Mr_Du on 2017/12/29.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LSJOperationNormalView,ZYPlayOperationView,BulletManager,BulletBackgroudView,ZYCountDownView;
typedef NS_ENUM(NSInteger,TopView) {
    TopViewRecharge = 0, //充值
    TopViewMusic = 1, //音乐
    TopViewBarrage = 2, //弹幕
    TopViewBack = 3 //返回
};

@protocol LSJTopViewDelegate <NSObject>

- (void)dealWithTopViewBy:(TopView)top button:(UIButton *)sender;
@end

@interface LSJTopView : UIView

@property (nonatomic,strong) UIView *playView;
@property (nonatomic,strong) NSArray *dataArray;

@property (nonatomic,strong) UIButton *perPayBtn;
@property (nonatomic,strong) UIButton *currentPayBtn;
@property (nonatomic, strong) ZYCountDownView *countDownV;          /**< 倒计时视图*/
@property (nonatomic,strong) LSJOperationNormalView *normalView;
@property (nonatomic, strong) BulletManager *bulletManager;//弹幕
@property (nonatomic, strong) BulletBackgroudView *bulletBgView;//弹幕背景
@property (nonatomic,assign) TopView topView;
@property (nonatomic,strong) UILabel *countdownL;
@property (nonatomic,strong) UIImageView *statusImgV;
@property (nonatomic,strong) UILabel *zuanshiNumL;

@property (nonatomic,assign) id<LSJTopViewDelegate> delegate;

- (void)refreshAudienceWithWwUserNum:(NSInteger)num withModel:(WwRoom*)model;
- (void)refreGameUserByUser:(WwUser *)user;
- (void)refrshWaWaDetailsWithModel:(WwRoom *)model;
- (void)refreshViewWithOrigin:(NSInteger )price Credits:(NSString *)credits time:(NSString *)time;
- (void)stopCountDownAction;
- (void)refeshClock:(BOOL)isActive;

- (void)start;
- (void)stopScroll;

@end
