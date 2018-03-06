//
//  FXGameResultView.h
//  zzl
//
//  Created by Mr_Du on 2017/11/24.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FXGameResultViewDelegate<NSObject>

- (void)gameAgainOrBringAction;
- (void)cancelOrShareAction;
- (void)dismissAction;


@end

@interface FXGameResultView : UIView

@property (nonatomic,weak) id<FXGameResultViewDelegate> delegate;
@property (nonatomic,strong) UILabel *desL;
@property (nonatomic,strong) NSTimer *timer;

- (void)showStatusView:(BOOL)isSuccess special:(BOOL)isSpecial;
@end
