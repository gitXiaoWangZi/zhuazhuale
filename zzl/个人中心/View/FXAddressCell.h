//
//  FXAddressCell.h
//  zzl
//
//  Created by Mr_Du on 2017/11/7.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol FXAddressCellDelegate <NSObject>
@optional
- (void)editAction:(NSIndexPath *)path;
- (void)deleteAction:(NSIndexPath *)path;
@end

@interface FXAddressCell : UITableViewCell

@property (nonatomic,weak) id<FXAddressCellDelegate> delegate;

@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,strong) WwAddress *model;
@property (nonatomic,strong) UIView *botoomV;
@end
