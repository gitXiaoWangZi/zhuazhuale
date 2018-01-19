//
//  FXSpoilsCell.h
//  zzl
//
//  Created by Mr_Du on 2017/11/8.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FXSpoilsCellDelegate<NSObject>

- (void)checkTheLogistics:(NSIndexPath *)indexPath;
@end

@interface FXSpoilsCell : UITableViewCell

@property (nonatomic,assign) id<FXSpoilsCellDelegate> delegate;
@property (nonatomic,assign) WwWawaListType celltype;
@property (nonatomic,strong) WwDepositItem *model;
@property (nonatomic,strong) WwOrderItem *item;
@property (nonatomic,strong) UIButton *isSelectBtn;
@property (nonatomic,strong) NSIndexPath *indexPath;
@end
