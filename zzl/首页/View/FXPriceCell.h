//
//  FXPriceCell.h
//  zzl
//
//  Created by Mr_Du on 2017/11/3.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FXPriceCell : UICollectionViewCell

@property (nonatomic,strong) UILabel *money;
@property (nonatomic,strong) UIButton *pay;
@property(nonatomic,strong) UIImageView * firstIcon;
@property (nonatomic,copy) NSString *isFirst;
@end
