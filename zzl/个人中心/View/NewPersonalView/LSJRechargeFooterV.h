//
//  LSJRechargeFooterV.h
//  zzl
//
//  Created by Mr_Du on 2018/1/11.
//  Copyright © 2018年 Mr.Du. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,RechargePayType) {
    RechargePayTypeNil,
    RechargePayTypeWechat,
    RechargePayTypeZhifubao,
};

@protocol LSJRechargeFooterVDelegate <NSObject>

- (void)payActionWithType:(RechargePayType)type;
@end

@interface LSJRechargeFooterV : UIView

@property (nonatomic,assign) id<LSJRechargeFooterVDelegate> delegate;
@property (nonatomic,assign) RechargePayType paytype;

@end
