//
//  FXHomeLoginSuccessPopView.h
//  zzl
//
//  Created by Mr_Du on 2017/11/24.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FXHomeLoginSuccessPopViewDelegate <NSObject>

- (void)dealThingAfterSuccess;
@end

@interface FXHomeLoginSuccessPopView : UIView

@property (nonatomic,copy) NSString *day;
@property (nonatomic,copy) NSString *money;
@property (nonatomic,assign) id<FXHomeLoginSuccessPopViewDelegate> delegate;
@end
