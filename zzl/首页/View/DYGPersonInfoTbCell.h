//
//  ZXPersonInfoTbCell.h
//  FFMobileBike
//
//  Created by chris on 17/9/14.
//  Copyright © 2017年 chris. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DYGPersonInfoTbCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;
@property (weak, nonatomic) IBOutlet UILabel *nickNameL;
@property(nonatomic,strong)UIView *detailView;
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithConfigDict:(NSDictionary *)dict;
@end
