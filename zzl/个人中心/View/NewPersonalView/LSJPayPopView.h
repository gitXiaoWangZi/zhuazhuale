//
//  LSJPayPopView.h
//  zzl
//
//  Created by Mr_Du on 2018/2/3.
//  Copyright © 2018年 Mr.Du. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LSJPayPopViewDelegate<NSObject>

- (void)payForType:(BOOL)isWechat num:(NSString *)num;
@end

@interface LSJPayPopView : UIView

+ (instancetype)instance;
@property (nonatomic,assign) id<LSJPayPopViewDelegate> delegate;
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) NSString *num;
@end
