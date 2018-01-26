//
//  LSJTaskHeaderView.m
//  zzl
//
//  Created by Mr_Du on 2018/1/12.
//  Copyright © 2018年 Mr.Du. All rights reserved.
//

#import "LSJTaskHeaderView.h"
#import "UIButton+Position.h"

@interface LSJTaskHeaderView()

@property (nonatomic,strong) UIView *topBgView;
@property (nonatomic,strong) UILabel *taskNumL;
@property (nonatomic,strong) UILabel *topzuanL;
@property (nonatomic,strong) UILabel *topTitleL;
@property (nonatomic,strong) UIImageView *topZuanImgV;

@property (nonatomic,strong) UIView *processBgView;
@property (nonatomic,strong) UIView *processView;
@property (nonatomic,strong) UIImageView *firstIcon;
@property (nonatomic,strong) UIImageView *secondIcon;
@property (nonatomic,strong) UIImageView *threeIcon;

@property (nonatomic,strong) UILabel *firL;
@property (nonatomic,strong) UILabel *secL;
@property (nonatomic,strong) UILabel *thrL;

@property (nonatomic,strong) UIButton *firBtn;
@property (nonatomic,strong) UIButton *secBtn;
@property (nonatomic,strong) UIButton *thrBtn;

@end

@implementation LSJTaskHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUpView];
    }
    return self;
}

- (void)setUpView{
    [self addSubview:self.topBgView];
    [self.topBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(Py(23));
        make.left.equalTo(self.mas_left).offset(Px(70));
        make.right.equalTo(self.mas_right).offset(Px(-70));
        make.height.equalTo(@(Py(27)));
    }];
    self.topBgView.cornerRadius = Py(13.5);
    [self.topBgView addSubview:self.taskNumL];
    [self.taskNumL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topBgView.mas_centerY);
        make.left.equalTo(self.topBgView.mas_left).offset(Px(27));
    }];
    [self.topBgView addSubview:self.topzuanL];
    [self.topzuanL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topBgView.mas_centerY);
        make.right.equalTo(self.topBgView.mas_right).offset(Px(-27));
    }];
    [self.topBgView addSubview:self.topZuanImgV];
    [self.topZuanImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topBgView.mas_centerY);
        make.right.equalTo(self.topzuanL.mas_left).offset(Px(-3));
    }];
    [self.topBgView addSubview:self.topTitleL];
    [self.topTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topBgView.mas_centerY);
        make.right.equalTo(self.topZuanImgV.mas_left).offset(Px(-3));
    }];
    
    [self addSubview:self.processBgView];
    [self.processBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBgView.mas_bottom).offset(Py(50));
        make.left.equalTo(self.mas_left).offset(Px(55));
        make.right.equalTo(self.mas_right).offset(Px(-55));
        make.height.equalTo(@(Py(4)));
    }];
    self.processBgView.cornerRadius = Py(2);
    self.processBgView.clipsToBounds = NO;
    
    [self.processBgView addSubview:self.processView];
    [self.processView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.processBgView.mas_top);
        make.left.equalTo(self.processBgView.mas_left);
        make.height.equalTo(@(Py(4)));
        make.width.equalTo(@(Px(0)));
    }];
    self.processView.cornerRadius = Py(2);
    
    CGFloat proBgViewWidth = kScreenWidth - Px(110);
    [self.processBgView addSubview:self.firstIcon];
    [self.firstIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.processBgView.mas_centerY);
        make.left.equalTo(self.processBgView.mas_left).offset(proBgViewWidth/3.0- 13);
    }];
    [self.processBgView addSubview:self.secondIcon];
    [self.secondIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.processBgView.mas_centerY);
        make.left.equalTo(self.processBgView.mas_left).offset(proBgViewWidth*2/3.0 -13);
    }];
    [self.processBgView addSubview:self.threeIcon];
    [self.threeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.processBgView.mas_centerY);
        make.left.equalTo(self.processBgView.mas_left).offset(proBgViewWidth -13);
    }];
    [self addSubview:self.firL];
    [self.firL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.firstIcon.mas_centerX);
        make.top.equalTo(self.firstIcon.mas_bottom).offset(5);
    }];
    [self addSubview:self.secL];
    [self.secL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.secondIcon.mas_centerX);
        make.top.equalTo(self.secondIcon.mas_bottom).offset(5);
    }];
    [self addSubview:self.thrL];
    [self.thrL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.threeIcon.mas_centerX);
        make.top.equalTo(self.threeIcon.mas_bottom).offset(5);
    }];
    [self addSubview:self.firBtn];
    [self.firBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.firstIcon.mas_centerX);
        make.bottom.equalTo(self.firstIcon.mas_top).offset(-5);
    }];
    [self addSubview:self.secBtn];
    [self.secBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.secondIcon.mas_centerX);
        make.bottom.equalTo(self.secondIcon.mas_top).offset(-5);
    }];
    [self addSubview:self.thrBtn];
    [self.thrBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.threeIcon.mas_centerX);
        make.bottom.equalTo(self.threeIcon.mas_top).offset(-5);
    }];
}

- (void)refershViewWithTaskNum:(NSString *)taskNum zuanshiNum:(NSString *)zuanNum{
    CGFloat proBgViewWidth = kScreenWidth - Px(110);
    self.topzuanL.text = zuanNum;
    self.taskNumL.text = [NSString stringWithFormat:@"今日完成任务:%@",taskNum];
    NSInteger num = [taskNum integerValue];
    if (num == 0) {
        [self.processView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.processBgView.mas_top);
            make.left.equalTo(self.processBgView.mas_left);
            make.height.equalTo(@(Py(4)));
            make.width.equalTo(@(0));
        }];
    }else if (num == 1){
        [self.processView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.processBgView.mas_top);
            make.left.equalTo(self.processBgView.mas_left);
            make.height.equalTo(@(Py(4)));
            make.width.equalTo(@(proBgViewWidth/6.0));
        }];
    }else if (num == 2){
        [self.processView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.processBgView.mas_top);
            make.left.equalTo(self.processBgView.mas_left);
            make.height.equalTo(@(Py(4)));
            make.width.equalTo(@(proBgViewWidth/3.0));
        }];
        self.firstIcon.image = [UIImage imageNamed:@"mine_task_yes"];
    }else if (num == 3){
        [self.processView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.processBgView.mas_top);
            make.left.equalTo(self.processBgView.mas_left);
            make.height.equalTo(@(Py(4)));
            make.width.equalTo(@(proBgViewWidth/2.0));
        }];
        self.firstIcon.image = [UIImage imageNamed:@"mine_task_yes"];
    }else if (num == 4){
        [self.processView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.processBgView.mas_top);
            make.left.equalTo(self.processBgView.mas_left);
            make.height.equalTo(@(Py(4)));
            make.width.equalTo(@(proBgViewWidth*2/3.0));
        }];
        self.firstIcon.image = [UIImage imageNamed:@"mine_task_yes"];
        self.secondIcon.image = [UIImage imageNamed:@"mine_task_yes"];
    }else if (num == 5){
        [self.processView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.processBgView.mas_top);
            make.left.equalTo(self.processBgView.mas_left);
            make.height.equalTo(@(Py(4)));
            make.width.equalTo(@(proBgViewWidth*5/6.0));
        }];
        self.firstIcon.image = [UIImage imageNamed:@"mine_task_yes"];
        self.secondIcon.image = [UIImage imageNamed:@"mine_task_yes"];
    }else if (num == 6){
        [self.processView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.processBgView.mas_top);
            make.left.equalTo(self.processBgView.mas_left);
            make.height.equalTo(@(Py(4)));
            make.width.equalTo(@(proBgViewWidth));
        }];
        self.firstIcon.image = [UIImage imageNamed:@"mine_task_yes"];
        self.secondIcon.image = [UIImage imageNamed:@"mine_task_yes"];
        self.threeIcon.image = [UIImage imageNamed:@"mine_task_yes"];
    }
//    }else if (num == 7){
//        [self.processView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.processBgView.mas_top);
//            make.left.equalTo(self.processBgView.mas_left);
//            make.height.equalTo(@(Py(4)));
//            make.width.equalTo(@(proBgViewWidth*5/7.0));
//        }];
//        self.firstIcon.image = [UIImage imageNamed:@"mine_task_yes"];
//        self.secondIcon.image = [UIImage imageNamed:@"mine_task_yes"];
//        self.threeIcon.image = [UIImage imageNamed:@"mine_task_yes"];
//    }else if (num == 8){
//        [self.processView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.processBgView.mas_top);
//            make.left.equalTo(self.processBgView.mas_left);
//            make.height.equalTo(@(Py(4)));
//            make.width.equalTo(@(proBgViewWidth*6/7.0));
//        }];
//        self.firstIcon.image = [UIImage imageNamed:@"mine_task_yes"];
//        self.secondIcon.image = [UIImage imageNamed:@"mine_task_yes"];
//        self.threeIcon.image = [UIImage imageNamed:@"mine_task_yes"];
//    }else if (num == 9){
//        [self.processView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.processBgView.mas_top);
//            make.left.equalTo(self.processBgView.mas_left);
//            make.height.equalTo(@(Py(4)));
//            make.width.equalTo(@(proBgViewWidth));
//        }];
//        self.firstIcon.image = [UIImage imageNamed:@"mine_task_yes"];
//        self.secondIcon.image = [UIImage imageNamed:@"mine_task_yes"];
//        self.threeIcon.image = [UIImage imageNamed:@"mine_task_yes"];
//    }
}

#pragma mark lazyload
- (UIView *)topBgView{
    if (!_topBgView) {
        _topBgView = [[UIView alloc] init];
        _topBgView.backgroundColor = DYGColorFromHex(0xF6F4F1);
    }
    return _topBgView;
}
- (UILabel *)taskNumL{
    if (!_taskNumL) {
        _taskNumL = [[UILabel alloc] init];
        _taskNumL.textColor = DYGColorFromHex(0x9d7000);
        _taskNumL.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _taskNumL.text = @"今日完成任务:9";
    }
    return _taskNumL;
}
- (UILabel *)topzuanL{
    if (!_topzuanL) {
        _topzuanL = [[UILabel alloc] init];
        _topzuanL.textColor = DYGColorFromHex(0x9d7000);
        _topzuanL.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _topzuanL.text = @"231";
    }
    return _topzuanL;
}
- (UIImageView *)topZuanImgV{
    if (!_topZuanImgV) {
        _topZuanImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jewel_task"]];
    }
    return _topZuanImgV;
}
- (UILabel *)topTitleL{
    if (!_topTitleL) {
        _topTitleL = [[UILabel alloc] init];
        _topTitleL.textColor = DYGColorFromHex(0x9d7000);
        _topTitleL.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _topTitleL.text = @"已领取:";
    }
    return _topTitleL;
}
- (UIView *)processBgView{
    if (!_processBgView) {
        _processBgView = [[UIView alloc] init];
        _processBgView.backgroundColor = DYGColorFromHex(0xEEE7E0);
    }
    return _processBgView;
}
- (UIView *)processView{
    if (!_processView) {
        _processView = [[UIView alloc] init];
        _processView.backgroundColor = DYGColorFromHex(0xffbc43);
    }
    return _processView;
}
- (UIImageView *)firstIcon{
    if (!_firstIcon) {
        _firstIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_task_no"]];
    }
    return _firstIcon;
}
- (UIImageView *)secondIcon{
    if (!_secondIcon) {
        _secondIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_task_no"]];
    }
    return _secondIcon;
}
- (UIImageView *)threeIcon{
    if (!_threeIcon) {
        _threeIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_task_no"]];
    }
    return _threeIcon;
}
- (UILabel *)firL{
    if (!_firL) {
        _firL = [[UILabel alloc] init];
        _firL.textColor = DYGColorFromHex(0x9b7000);
        _firL.font = [UIFont fontWithName:@"STYuanti-SC-Regular" size:13];
        _firL.text = @"2";
        _firL.textAlignment = NSTextAlignmentCenter;
    }
    return _firL;
}
- (UILabel *)secL{
    if (!_secL) {
        _secL = [[UILabel alloc] init];
        _secL.textColor = DYGColorFromHex(0x9b7000);
        _secL.font = [UIFont fontWithName:@"STYuanti-SC-Regular" size:13];
        _secL.text = @"4";
        _secL.textAlignment = NSTextAlignmentCenter;
    }
    return _secL;
}
- (UILabel *)thrL{
    if (!_thrL) {
        _thrL = [[UILabel alloc] init];
        _thrL.textColor = DYGColorFromHex(0x9b7000);
        _thrL.font = [UIFont fontWithName:@"STYuanti-SC-Regular" size:13];
        _thrL.text = @"6";
        _thrL.textAlignment = NSTextAlignmentCenter;
    }
    return _thrL;
}

- (UIButton *)firBtn{
    if (!_firBtn) {
        _firBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_firBtn setTitle:@"200" forState:UIControlStateNormal];
        [_firBtn setTitleColor:DYGColorFromHex(0x9b7000) forState:UIControlStateNormal];
        [_firBtn setImage:[UIImage imageNamed:@"jewel_task"] forState:UIControlStateNormal];
        _firBtn.titleLabel.font = [UIFont fontWithName:@"STYuanti-SC-Regular" size:13];
        [_firBtn xm_setImagePosition:XMImagePositionLeft titleFont:[UIFont fontWithName:@"STYuanti-SC-Regular" size:13] spacing:3];
        _firBtn.enabled = NO;
    }
    return _firBtn;
}
- (UIButton *)secBtn{
    if (!_secBtn) {
        _secBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_secBtn setTitle:@"500" forState:UIControlStateNormal];
        [_secBtn setTitleColor:DYGColorFromHex(0x9b7000) forState:UIControlStateNormal];
        [_secBtn setImage:[UIImage imageNamed:@"jewel_task"] forState:UIControlStateNormal];
        _secBtn.titleLabel.font = [UIFont fontWithName:@"STYuanti-SC-Regular" size:13];
        [_secBtn xm_setImagePosition:XMImagePositionLeft titleFont:[UIFont fontWithName:@"STYuanti-SC-Regular" size:13] spacing:3];
        _secBtn.enabled = NO;
    }
    return _secBtn;
}
- (UIButton *)thrBtn{
    if (!_thrBtn) {
        _thrBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_thrBtn setTitle:@"1500" forState:UIControlStateNormal];
        [_thrBtn setTitleColor:DYGColorFromHex(0x9b7000) forState:UIControlStateNormal];
        [_thrBtn setImage:[UIImage imageNamed:@"jewel_task"] forState:UIControlStateNormal];
        _thrBtn.titleLabel.font = [UIFont fontWithName:@"STYuanti-SC-Regular" size:13];
        [_thrBtn xm_setImagePosition:XMImagePositionLeft titleFont:[UIFont fontWithName:@"STYuanti-SC-Regular" size:13] spacing:3];
        _thrBtn.enabled = NO;
    }
    return _thrBtn;
}
@end
