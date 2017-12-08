//
//  DYGPopViewMenu.h
//  zzl
//
//  Created by Mr_Du on 2017/11/1.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DYGPopViewMenu;
@protocol DYGPopViewMenuDelegate<NSObject>

@optional

-(void)popViewDismissWithSelf:(DYGPopViewMenu *)menu;

@end

@interface DYGPopViewMenu : UIView

@property (nonatomic,strong) NSArray *titleArr;
//@property (nonatomic,assign) NSInteger lineNum;
@property (nonatomic,weak) id<DYGPopViewMenuDelegate> delegate;
@property (nonatomic,assign) BOOL isHidPopView;
@end
