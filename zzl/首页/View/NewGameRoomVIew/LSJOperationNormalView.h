//
//  LSJOperationNormalView.h
//  zzl
//
//  Created by Mr_Du on 2017/12/30.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,OperationNormalView) {
    OperationNormalViewView = 0, //视角
    OperationNormalViewGame = 1, //游戏
    OperationNormalViewMsg = 2, //消息
};

@protocol LSJOperationNormalViewDelegate <NSObject>

- (void)dealWithbottomViewBy:(OperationNormalView)operation button:(UIButton *)sender;
@end

@interface LSJOperationNormalView : UIView

@property (nonatomic,strong) UIButton *gameBtn;
@property (nonatomic,assign) OperationNormalView operationNormalView;
@property (nonatomic,assign) id<LSJOperationNormalViewDelegate> delegate;
@end
