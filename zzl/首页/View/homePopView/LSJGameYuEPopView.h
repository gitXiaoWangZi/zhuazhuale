//
//  LSJGameYuEPopView.h
//  zzl
//
//  Created by Mr_Du on 2018/2/5.
//  Copyright © 2018年 Mr.Du. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,gameYuEPopViewType){
    gameYuEPopViewTypeOtherPay,//代付
    gameYuEPopViewTypeSelfPay,//自己付
};

@protocol LSJGameYuEPopViewDelegate<NSObject>

- (void)clickPayBy:(gameYuEPopViewType)payType;
@end

@interface LSJGameYuEPopView : UIView

+ (instancetype)shareInstance;
@property (nonatomic,assign) id<LSJGameYuEPopViewDelegate> delegate;
@property (nonatomic,assign) gameYuEPopViewType payType;
@end
