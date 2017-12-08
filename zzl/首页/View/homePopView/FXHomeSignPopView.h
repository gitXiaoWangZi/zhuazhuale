//
//  FXHomeSignPopView.h
//  zzl
//
//  Created by Mr_Du on 2017/11/23.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FXHomeSignPopView : UIView

@property (nonatomic,strong) NSDictionary *dataDic;

@property (nonatomic,copy) void(^signActionBlock)(NSString *day);
@end
