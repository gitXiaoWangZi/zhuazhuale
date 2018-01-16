//
//  FXRoomCell.h
//  zzl
//
//  Created by Mr_Du on 2017/11/1.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FXRoomCell : UICollectionViewCell

@property (nonatomic,assign) NSInteger state;

@property (nonatomic,strong) WwRoom *model;

- (void)dealLineWithIndex:(NSIndexPath *)index;
@end
