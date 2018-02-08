//
//  LSJPersonalHeaderView.h
//  zzl
//
//  Created by Mr_Du on 2017/12/28.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AccountItem;
typedef NS_ENUM(NSInteger, personalHeader) {
    personalHeaderBack = 0,            //返回
    personalHeaderMsg = 1,             //消息
    personalHeaderSetting = 2,         //设置
    personalHeaderZuanshi = 3,         //我的钻石
    personalHeaderRecharge = 4,         //充值
    personalHeaderOtherPay = 5,         //代付
    personalHeaderIcon = 6,         //头像
};


@protocol LSJPersonalHeaderViewDelegate <NSObject>

- (void)doHeaderNavAction:(personalHeader)header;
@end

@interface LSJPersonalHeaderView : UIView

+ (instancetype)shareInstance;
@property (weak, nonatomic) IBOutlet UIImageView *redPoint;
@property (nonatomic,assign) personalHeader personalHeader;
@property (nonatomic,assign) id<LSJPersonalHeaderViewDelegate> delegate;
@property (nonatomic,strong) AccountItem *item;
@end
