//
//  FXGameDetailContentView.h
//  zzl
//
//  Created by Mr_Du on 2017/12/22.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FXGameDetailContentViewDelegate <NSObject>
- (void)jumpPageWithStatus:(NSInteger)status;

@end

@interface FXGameDetailContentView : UIView

@property (nonatomic,assign) id<FXGameDetailContentViewDelegate>delegate;
+ (instancetype)shareInstance;
- (void)updataComplainState:(BOOL)complain;
- (void)reloadDataWithModel:(WwGameHistory*)model;
@end
