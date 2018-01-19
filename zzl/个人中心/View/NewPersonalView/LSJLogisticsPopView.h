//
//  LSJLogisticsPopView.h
//  zzl
//
//  Created by Mr_Du on 2018/1/17.
//  Copyright © 2018年 Mr.Du. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LSJLogisticsPopViewDelegate<NSObject>

- (void)dismissAction;
@end

@interface LSJLogisticsPopView : UIView

@property (nonatomic,strong) WwExpressInfo *model;
@property (nonatomic,assign) id<LSJLogisticsPopViewDelegate>delegate;
@end
