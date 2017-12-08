//
//  FXRoomCell.m
//  zzl
//
//  Created by Mr_Du on 2017/11/1.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "FXRoomCell.h"

#define freeColor DYGColorFromHex(0x6ce0ff)
#define wrongColor  DYGColorFromHex(0xb3b3b3)

@interface FXRoomCell()
@property(nonatomic,strong)UILabel * gameState;
@property (nonatomic,strong) UILabel *toolsName;
@property (nonatomic,strong) UILabel *price;
@property (nonatomic,strong) UIImageView *diamond;
@property (nonatomic,strong) UIImageView *bgImgView;


@end

@implementation FXRoomCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self creatUI];
        self.layer.cornerRadius = 8;
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 1;
    }
    return self;
}

-(void)creatUI{
    [self addSubview:self.bgImgView];
    [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    [self addSubview:self.gameState];
    [self.gameState mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-Px(10));
        make.top.equalTo(self).offset(Py(10));
    }];
    [self addSubview:self.toolsName];
    [self.toolsName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(Px(10));
        make.bottom.equalTo(self).offset(-Py(12));
    }];
    [self addSubview:self.diamond];
    [self.diamond mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.toolsName);
        make.right.equalTo(self).offset(-Px(10));
        make.width.equalTo(@(Px(14)));
        make.height.equalTo(@(Py(12.5)));
    }];
    [self addSubview:self.price];
    [self.price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.diamond.mas_centerY);
        make.left.equalTo(self.toolsName.mas_right);
        make.right.equalTo(self.diamond.mas_left).offset(-Px(5));
        make.width.equalTo(@(Px(30)));
    }];
}

-(void)setState:(NSInteger)state{
    _state = state;
    self.price.text = [NSString stringWithFormat:@"%ld",state+30];
    switch (state/2) {
        case 0:
            self.layer.borderColor = systemColor.CGColor;
            self.gameState.text = @"游戏中";
            self.gameState.textColor = systemColor;
            break;
        case 1:
            self.layer.borderColor = wrongColor.CGColor;
            self.gameState.text = @"补货中";
            self.gameState.textColor = wrongColor;
            break;
        default:
            self.layer.borderColor = freeColor.CGColor;
            self.gameState.text =@"空闲中";
            self.gameState.textColor = freeColor;
            break;
    }
}





#pragma lazy load

-(UIImageView *)bgImgView{
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc]init];
        _bgImgView.image = [UIImage imageNamed:@"鱿鱼center"];
    }
    return _bgImgView;
}
-(UILabel *)gameState{
    if (!_gameState) {
        _gameState = [UILabel labelWithFont:12 WithTextColor:systemColor];
        _gameState.text =@"游戏中";
//       空闲 6ce0ff   补货中 b3b3b3
    }
    return _gameState;
}
-(UILabel *)toolsName{
    if (!_toolsName) {
        _toolsName = [UILabel labelWithFont:14 WithTextColor:TextColor];
        _toolsName.numberOfLines = 2;
        _toolsName.text = @"小熊";
    }
    return _toolsName;
}
-(UILabel *)price{
    if (!_price) {
        _price = [UILabel labelWithFont:14 WithTextColor:systemColor];
        _price.textAlignment = NSTextAlignmentRight;
        _price.text = @"39";
    }
    return _price;
}
-(UIImageView *)diamond{
    if (!_diamond) {
        _diamond = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"price"]];
        [_diamond sizeToFit];
    }
    return _diamond;
}

- (void)setModel:(WwRoomModel *)model{
    _model = model;
    [self.bgImgView sd_setImageWithURL:[NSURL URLWithString:model.wawa.pic] placeholderImage:[UIImage imageNamed:@"鱿鱼center"]];
    if (model.state < 1) { /**< 房间状态: 小于1:故障 1：补货 2:空闲 大于2:游戏中*/
        self.gameState.text = @"故障";
    }else if(model.state == 1){
        self.gameState.text = @"补货";
        self.layer.borderColor = wrongColor.CGColor;
        self.gameState.textColor = wrongColor;
    }else if(model.state == 2){
        self.gameState.text = @"空闲";
        self.layer.borderColor = freeColor.CGColor;
        self.gameState.textColor = freeColor;
    }else{
        self.gameState.text = @"游戏中";
        self.layer.borderColor = systemColor.CGColor;
        self.gameState.textColor = systemColor;
    }
    self.toolsName.text = model.wawa.name;
    self.price.text = [self getCostDescribeByWawaInfo:model.wawa];
    
}

#pragma mark - Helper
- (NSString *)getCostDescribeByWawaInfo:(WwWawaItem *)item {
    NSString * des = nil;
    if (item.coin > 0) {
        des = [NSString stringWithFormat:@"%zi", item.coin];
    }
    else if (item.fishball > 0) {
        des = [NSString stringWithFormat:@"%zi", item.fishball];
    }
    else if (item.coupon > 0){
        des = [NSString stringWithFormat:@"%zi", item.coupon];
    }
    return des;
}
@end
