//
//  FXMinePageCell.m
//  zzl
//
//  Created by Mr_Du on 2017/12/22.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "FXMinePageCell.h"

@interface FXMinePageCell()

@end

@implementation FXMinePageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.warn.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
