//
//  FXGameWaitCell.m
//  zzl
//
//  Created by Mr_Du on 2017/11/2.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "FXGameWaitCell.h"

@interface FXGameWaitCell()

@end


@implementation FXGameWaitCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.bgImg];
        [self.bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self.contentView);
        }];
    }
    return self;
}
-(void)setFrame:(CGRect)frame {
    frame.origin.y += 7;
    frame.size.height-=7;
    frame.size.width-=14;
    frame.origin.x +=7;
    [super setFrame:frame];
    
}
-(UIImageView *)bgImg{
    if (!_bgImg) {
        _bgImg = [UIImageView new];
    }
    return _bgImg;
}

@end
