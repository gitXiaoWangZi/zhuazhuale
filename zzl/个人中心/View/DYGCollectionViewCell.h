//
//  DYGCollectionViewCell.h
//  CS2.1
//
//  Created by Mr_Du on 2017/8/10.
//  Copyright © 2017年 Mr_Du. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DYGDelectCellDelegate <NSObject>

@optional

-(void)delectImgWithTag:(NSInteger)tag;


@end

@interface DYGCollectionViewCell : UICollectionViewCell
@property(nonatomic,strong)UIImageView *imgView;
@property (nonatomic,weak) id<DYGDelectCellDelegate> delegate;

@end
