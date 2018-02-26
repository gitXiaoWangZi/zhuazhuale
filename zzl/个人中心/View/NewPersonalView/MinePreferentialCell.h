//
//  MinePreferentialCell.h
//  zzl
//
//  Created by Mr_Du on 2018/2/24.
//  Copyright © 2018年 Mr.Du. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LSJPreferentialModel;
typedef NS_ENUM(NSInteger,preferentialType) {
    preferentialTypeNone,
    preferentialTypeGo,
    preferentialTypeUsed,
    preferentialTypePass,
};

@interface MinePreferentialCell : UITableViewCell

@property (nonatomic,assign) preferentialType type;
@property (nonatomic,strong) LSJPreferentialModel *model;

- (void)updateViewWithIcon:(NSString *)icon title:(NSString *)title time:(NSString *)time;
@end
