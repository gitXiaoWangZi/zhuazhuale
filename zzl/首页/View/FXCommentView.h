//
//  FXCommentView.h
//  zzl
//
//  Created by Mr_Du on 2017/11/2.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FXCommentViewDelegate<NSObject>

- (void)sendClick;
@end

@interface FXCommentView : UIView

@property (nonatomic,weak) id<FXCommentViewDelegate>delegate;
@property(nonatomic,strong) UITextField * commentTF;
@end
