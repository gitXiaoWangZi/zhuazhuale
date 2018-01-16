//
//  WawaInfoHeaderView.h
//  MyTabbar
//
//  Created by Mr_Du on 2017/12/26.
//  Copyright © 2017年 Mr.Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WawaInfoHeaderView : UIView

+ (instancetype)shareInstance;
- (void)refreshHeaderWithmodel:(WwWaWaDetail *)model;
@end
