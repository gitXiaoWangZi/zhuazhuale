//
//  HRAdView.m
//  AutoAdLabelScroll
//
//  Created by 陈华荣 on 16/4/6.
//  Copyright © 2016年 陈华荣. All rights reserved.
//

#import "HRAdView.h"
#define ViewWidth  self.bounds.size.width
#define ViewHeight  self.bounds.size.height

@interface HRAdView ()
@property (nonatomic,strong) UIView *bgView;
/**
 *  文字广告条前面的图标
 */
@property (nonatomic, strong) UIImageView *headImageView;
/**
 *  背景图
 */
@property (nonatomic, strong) UIImageView *bgImageView;
/**
 *  轮流显示的两个Label
 */
@property (nonatomic, strong) UILabel *oneLabel;
@property (nonatomic, strong) UILabel *twoLabel;

/**
 *  计时器
 */

@property (nonatomic, strong) NSTimer *timer;




@end

@implementation HRAdView
{
    NSUInteger index;
    CGFloat margin;
    BOOL isBegin;
}


- (instancetype)initWithTitles:(NSArray *)titles{
    
    self = [super init];
    
    if (self) {
        margin = 0;
        self.clipsToBounds = YES;
        self.adTitles = titles;
        self.headImg = nil;
        self.labelFont = [UIFont systemFontOfSize:12];
        self.color =DYGColorFromHex(0x666666);
        self.time = 2.0f;
        self.textAlignment = NSTextAlignmentLeft;
        self.isHaveHeadImg = NO;
        self.isHaveTouchEvent = NO;
        
        index = 0;
        
        if (!_bgImageView) {
            _bgImageView = [UIImageView new];
            [self addSubview:_bgImageView];
        }
        
        if (!_headImageView) {
            _headImageView = [UIImageView new];
        }
        
        if (!_oneLabel) {
            _oneLabel = [UILabel new];
//            _oneLabel.text = @"欢迎使用U兑平台!!!";
            _oneLabel.font = self.labelFont;
            _oneLabel.textAlignment = self.textAlignment;
            
            _oneLabel.textColor = self.color;
            [self addSubview:_oneLabel];
        }
        
        if (!_twoLabel) {
            _twoLabel = [UILabel new];
            _twoLabel.font = self.labelFont;
            _twoLabel.textColor = self.color;
            _twoLabel.textAlignment = self.textAlignment;
            [self addSubview:_twoLabel];
        }
    }
    return self;
}

- (void)timeRepeat{
    if (self.adTitles.count == 0) {
        return;
    }
    if (index != self.adTitles.count-1) {
        index++;
    }else{
        index = 0;
    }
    
    
    if (index == 0) {
        
        NSDictionary * ds = self.adTitles[index];

        NSString * oldStr = [NSString stringWithFormat:@"恭喜%@用户成功抓中娃娃!",ds[@"username"]];
        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:oldStr];
        [self.oneLabel setAttributedText:noteStr];
    }else{
        switch (index%2) {
            case 0:
            {
                NSDictionary * ds = self.adTitles[index];
                NSString * oldStr = [NSString stringWithFormat:@"恭喜%@用户成功抓中娃娃!",ds[@"username"]];
                NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:oldStr];
                [self.oneLabel setAttributedText:noteStr];
            }
                break;
                
            default:
            {
                NSDictionary * ds = self.adTitles[index];
                 NSString * oldStr = [NSString stringWithFormat:@"恭喜%@用户成功抓中娃娃!",ds[@"username"]];
                NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:oldStr];
                [self.twoLabel setAttributedText:noteStr];
            }
                break;
        }
        
    }
    
    if (index%2 == 0) {
        [UIView animateWithDuration:1 animations:^{
            self.oneLabel.frame = CGRectMake(40, 0, ViewWidth, ViewHeight);
            self.twoLabel.frame = CGRectMake(40, -ViewHeight, ViewWidth, ViewHeight);
        } completion:^(BOOL finished){
            self.twoLabel.frame = CGRectMake(40, ViewHeight, ViewWidth, ViewHeight);
        }];
    }else{
        [UIView animateWithDuration:1 animations:^{
            self.twoLabel.frame = CGRectMake(40, 0, ViewWidth, ViewHeight);
            self.oneLabel.frame = CGRectMake(40, -ViewHeight, ViewWidth, ViewHeight);
        } completion:^(BOOL finished){
            self.oneLabel.frame = CGRectMake(40, ViewHeight, ViewWidth, ViewHeight);
        }];
    }
    
}

- (void)layoutSubviews{

    [super layoutSubviews];
        if (self.isHaveHeadImg) {
        [self addSubview:self.headImageView];
//        self.headImageView.frame = CGRectMake(0, 0, ViewHeight,ViewHeight);
            [self.headImageView sizeToFit];
            [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left).offset(20);
                make.centerY.equalTo(self.mas_centerY);
            }];
        margin = self.headImageView.bounds.size.width;
    }else{
        
        if (self.headImageView) {
            [self.headImageView removeFromSuperview];
            self.headImageView = nil;
        }
        margin = 0;
    }
    [self.oneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset(5);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@(ViewWidth));
        make.height.equalTo(@(ViewHeight));
    }];
    [self.twoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset(5);
        make.top.equalTo(self.oneLabel.mas_bottom).offset(0);
        make.width.equalTo(@(ViewWidth));
        make.height.equalTo(@(ViewHeight));
    }];
    self.bgImageView.frame = self.bounds;
}


- (NSTimer *)timer{
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:self.time target:self selector:@selector(timeRepeat) userInfo:self repeats:YES];
    }
    return _timer;
}


- (void)beginScroll{
    if (self.timer.isValid) {
        [self.timer invalidate];
        self.timer = nil;
    }
    [[NSRunLoop mainRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)closeScroll{
    
    [self.timer invalidate];
    self.timer = nil;
}



- (void)setIsHaveHeadImg:(BOOL)isHaveHeadImg{
    _isHaveHeadImg = isHaveHeadImg;
    
}

- (void)setIsHaveTouchEvent:(BOOL)isHaveTouchEvent{
    if (isHaveTouchEvent) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickEvent:)];
        [self addGestureRecognizer:tapGestureRecognizer];
    }else{
        self.userInteractionEnabled = NO;
    }
}

- (void)setTime:(NSTimeInterval)time{
    _time = time;
    if (self.timer.isValid) {
        [self.timer isValid];
        self.timer = nil;
    }
}


- (void)setHeadImg:(UIImage *)headImg{
    _headImg = headImg;
    
    self.headImageView.image = headImg;
}

- (void)setBgImg:(UIImage *)bgImg{
    _bgImg = bgImg;
    self.bgImageView.image = bgImg;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment{
    _textAlignment = textAlignment;
    
    self.oneLabel.textAlignment = _textAlignment;
    self.twoLabel.textAlignment = _textAlignment;
}

- (void)setColor:(UIColor *)color{
    _color = color;
    self.oneLabel.textColor = _color;
    self.twoLabel.textColor = _color;
}

- (void)setLabelFont:(UIFont *)labelFont{
    _labelFont = labelFont;
    self.oneLabel.font = _labelFont;
    self.twoLabel.font = _labelFont;
}


- (void)clickEvent:(UITapGestureRecognizer *)tapGestureRecognizer{
    
    
    
    [self.adTitles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (index % 2 == 0 && [self.oneLabel.text isEqualToString:obj]) {
            if (self.clickAdBlock) {
                self.clickAdBlock(index);
            }
        }else if(index % 2 != 0 && [self.twoLabel.text isEqualToString:obj]){
            if (self.clickAdBlock) {
                self.clickAdBlock(index);
            }
        }
    }];
    
}


@end
