//
//  ZXPersonInfoTbCell.m
//  FFMobileBike
//
//  Created by chris on 17/9/14.
//  Copyright © 2017年 chris. All rights reserved.
//

#import "DYGPersonInfoTbCell.h"
#import "NSDictionary+ZXAdd.h"
#import "Masonry.h"

@interface DYGPersonInfoTbCell()

@end

@implementation DYGPersonInfoTbCell{
    NSDictionary *_configDict;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithConfigDict:(NSDictionary *)dict{
    if (self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier]) {
        _configDict = dict;
        [self configAccessoryView];
        [self configDetailView];
    }
    return self;
}
-(void)configAccessoryView{
    NSString *accesoryType = _configDict[@"accesoryType"];
    if ([accesoryType isEqualToString:@"none"]) {
        self.accessoryType = UITableViewCellAccessoryNone;
    }else if ([accesoryType isEqualToString:@"indicator"]){
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
}
-(void)configDetailView{
    if ([_configDict containsKey:@"detailView"]){
        self.detailTextLabel.hidden = YES;
        Class detailV = NSClassFromString(_configDict[@"detailView"]);
        self.detailView = (UIView *)[detailV new];
        [self.contentView addSubview:self.detailView];
        [self.detailView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            if (self.accessoryView){
                make.right.equalTo(self.accessoryView.mas_left);
            }else{
                make.right.equalTo(self.contentView).offset(0);
            }
        }];
    }else{
        self.detailView = self.detailTextLabel;
    }
}
@end
