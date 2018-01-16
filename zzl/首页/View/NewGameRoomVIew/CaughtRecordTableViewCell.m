//
//  CaughtRecordTableViewCell.m
//  MyTabbar
//
//  Created by Mr_Du on 2017/12/26.
//  Copyright © 2017年 Mr.Liu. All rights reserved.
//

#import "CaughtRecordTableViewCell.h"

@interface CaughtRecordTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *date;

@end

@implementation CaughtRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.icon.layer.cornerRadius = 23.5;
    self.icon.layer.masksToBounds = YES;
}

- (void)dataWithItem:(WwRoomCatchRecordItem *)item{
    self.name.text = item.user.nickname;
    self.date.text = item.dateline;
    [self.icon sd_setImageWithURL:[NSURL URLWithString:item.user.portrait] placeholderImage:[UIImage imageNamed:@""]];
}
@end
