//
//  FXHomePopView.h
//  zzl
//
//  Created by Mr_Du on 2017/11/23.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FXHomePopViewDelegate <NSObject>

- (void)dimiss;
- (void)gameNow;
@end

@interface FXHomePopView : UIView

@property (nonatomic,weak) id<FXHomePopViewDelegate> delegate;
@end
