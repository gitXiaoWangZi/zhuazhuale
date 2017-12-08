//
//  FXCollecTBCell.h
//  zzl
//
//  Created by Mr_Du on 2017/11/8.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FXColecTBCellDelegate<NSObject>

@optional

-(void)cellDidClickWithIndexPath:(NSIndexPath *)indexPath;

@end


@interface FXCollecTBCell : UICollectionViewCell

@property (nonatomic,weak) id<FXColecTBCellDelegate> delegate;
@property (nonatomic,assign) BOOL isShow;
@property (nonatomic,assign) WwWawaListType colectType;
@property (nonatomic,strong) NSArray *dataArray;
@property(nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong) NSMutableArray *selectArray;

@end
