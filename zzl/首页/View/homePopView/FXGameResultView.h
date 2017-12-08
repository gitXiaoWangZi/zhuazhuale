//
//  FXGameResultView.h
//  zzl
//
//  Created by Mr_Du on 2017/11/24.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FXGameResultViewDelegate<NSObject>

- (void)receiveWawaAction;
- (void)gameAgainAction;


@end

@interface FXGameResultView : UIView

@property (nonatomic,assign) BOOL isSuccess;
@property (nonatomic,weak) id<FXGameResultViewDelegate> delegate;
@property(nonatomic,strong) UILabel * cornerL;
@property (nonatomic,strong) NSTimer *timer;

@end
