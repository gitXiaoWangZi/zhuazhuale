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
@property (nonatomic,strong) UIButton *gameState;
@property (nonatomic,strong) UILabel *toolsName;
@property (nonatomic,strong) UILabel *price;
@property (nonatomic,strong) UIImageView *diamond;
@property (nonatomic,strong) UIImageView *bgImgView;
@property (nonatomic,strong) UIView *downLine;
@property (nonatomic,strong) UIView *leftLine;


@end

@implementation FXRoomCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    [self addSubview:self.bgImgView];
    [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(Py(16));
        make.left.equalTo(self.mas_left).offset(Py(16));
        make.width.equalTo(@(Px(145)));
        make.height.equalTo(@(Py(140)));
    }];
    self.bgImgView.layer.cornerRadius = 8;
    self.bgImgView.layer.masksToBounds = YES;
    [self addSubview:self.gameState];
    [self.gameState mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgImgView.mas_right).offset(-Px(5));
        make.top.equalTo(self.bgImgView.mas_top).offset(Py(5));
    }];
    [self addSubview:self.toolsName];
    [self.toolsName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgImgView.mas_bottom).offset(Py(10));
        make.left.equalTo(self.bgImgView.mas_left);
    }];
    [self addSubview:self.diamond];
    [self.diamond mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgImgView.mas_left);
        make.top.equalTo(self.toolsName.mas_bottom).offset(Py(5));
    }];
    [self addSubview:self.price];
    [self.price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.diamond.mas_centerY);
        make.left.equalTo(self.diamond.mas_right);
    }];
    [self.price sizeToFit];
    [self addSubview:self.downLine];
    [self.downLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@(1));
        make.width.equalTo(self);
    }];
    [self addSubview:self.leftLine];
    [self.leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.height.equalTo(self);
        make.width.equalTo(@(1));
    }];
}

- (void)dealLineWithIndex:(NSIndexPath *)index{
    if (index.row%2 == 0) {
        self.leftLine.hidden = YES;
    }else{
        self.leftLine.hidden = NO;
    }
}

-(void)setState:(NSInteger)state{
    _state = state;
    self.price.text = [NSString stringWithFormat:@"%ld",state+30];
    switch (state/2) {
        case 0:
        {
            [_gameState setTitle:@"游戏中" forState:UIControlStateNormal];
            [_gameState setBackgroundImage:[UIImage imageNamed:@"home_room_status"] forState:UIControlStateNormal];
        }
            break;
        case 1:
        {
            [_gameState setTitle:@"补货" forState:UIControlStateNormal];
            [_gameState setBackgroundImage:[UIImage imageNamed:@"home_room_weixiu"] forState:UIControlStateNormal];
        }
            break;
        default:
        {
            [_gameState setTitle:@"空闲" forState:UIControlStateNormal];
            [_gameState setBackgroundImage:[UIImage imageNamed:@"home_room_kongxian"] forState:UIControlStateNormal];
        }
            break;
    }
}





#pragma lazy load

- (UIView *)downLine{
    if (!_downLine) {
        _downLine = [UIView new];
        _downLine.backgroundColor = DYGColorFromHex(0xffeac3);
    }
    return _downLine;
}
- (UIView *)leftLine{
    if (!_leftLine) {
        _leftLine = [UIView new];
        _leftLine.backgroundColor = DYGColorFromHex(0xffeac3);
    }
    return _leftLine;
}

-(UIImageView *)bgImgView{
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc]init];
        _bgImgView.image = [UIImage imageNamed:@"鱿鱼center"];
    }
    return _bgImgView;
}
- (UIButton *)gameState{
    if (!_gameState) {
        _gameState = [UIButton buttonWithType:UIButtonTypeCustom];
        [_gameState setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _gameState.titleLabel.font = kPingFangSC_Medium(12);
        UIImage *img = [UIImage imageNamed:@"home_room_status"];
        [_gameState setBackgroundImage:img forState:UIControlStateNormal];
        _gameState.enabled = NO;
    }
    return _gameState;
}
-(UILabel *)toolsName{
    if (!_toolsName) {
        _toolsName = [UILabel labelWithFont:15 WithTextColor:TextColor];
        _toolsName.numberOfLines = 2;
        _toolsName.text = @"小熊";
    }
    return _toolsName;
}
-(UILabel *)price{
    if (!_price) {
        _price = [UILabel labelWithFont:12 WithTextColor:DYGColorFromHex(0x2c2c2c)];
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

- (void)setModel:(WwRoom *)model{
    _model = model;
    [self.bgImgView sd_setImageWithURL:[NSURL URLWithString:model.wawa.pic] placeholderImage:[UIImage imageNamed:@"鱿鱼center"]];
    if (model.state < 1) { /**< 房间状态: 小于1:故障 1：补货 2:空闲 大于2:游戏中*/
        [self.gameState setTitle:@"故障" forState:UIControlStateNormal];
        [_gameState setBackgroundImage:[UIImage imageNamed:@"home_room_weixiu"] forState:UIControlStateNormal];
    }else if(model.state == 1){
        [self.gameState setTitle:@"补货" forState:UIControlStateNormal];
        [_gameState setBackgroundImage:[UIImage imageNamed:@"home_room_weixiu"] forState:UIControlStateNormal];
    }else if(model.state == 2){
        [self.gameState setTitle:@"空闲" forState:UIControlStateNormal];
        [_gameState setBackgroundImage:[UIImage imageNamed:@"home_room_kongxian"] forState:UIControlStateNormal];
    }else{
        [self.gameState setTitle:@"游戏中" forState:UIControlStateNormal];
        [_gameState setBackgroundImage:[UIImage imageNamed:@"home_room_status"] forState:UIControlStateNormal];
    }
    self.toolsName.text = model.wawa.name;
    self.price.text = [self getCostDescribeByWawaInfo:model.wawa];
    
}

#pragma mark - Helper
- (NSString *)getCostDescribeByWawaInfo:(WwWawa *)item {
    NSString * des = nil;
    if (item.coin > 0) {
        des = [NSString stringWithFormat:@"%zi/次", item.coin];
    }
    return des;
}
@end
