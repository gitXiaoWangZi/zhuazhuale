//
//  LSJKoulingPopView.h
//  zzl
//
//  Created by Mr_Du on 2018/1/5.
//  Copyright © 2018年 Mr.Du. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSJKoulingPopView : UIView

+(instancetype)shareInstance;
@property (nonatomic,copy) void(^sendKoulingClock) (NSString *msg);
@end
