//
//  FXGameWebController.h
//  zzl
//
//  Created by Mr_Du on 2017/11/18.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FXLatesRecordModel;
@class FXHomeBannerItem;
@interface FXGameWebController : UIViewController

@property (nonatomic,strong) FXLatesRecordModel *model;
@property (nonatomic,strong) FXHomeBannerItem *item;
@property (nonatomic,copy) NSString *orderId;
@end
