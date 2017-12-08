//
//  DYGPopDetailView.h
//  zzl
//
//  Created by Mr_Du on 2017/11/2.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol DYGPopDetailViewDelegate<NSObject>

@optional

-(void)popViewDismiss;

@end


@interface DYGPopDetailView : UIView

@property (nonatomic,strong) WwRoomModel *model;
@property (nonatomic,weak) id<DYGPopDetailViewDelegate> delegate;
@end
