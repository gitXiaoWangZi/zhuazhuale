//
//  DYGHomeHeaderView.m
//  CS2.1
//
//  Created by Mr_Du on 2017/8/4.
//  Copyright © 2017年 Mr_Du. All rights reserved.
//

#import "DYGHomeHeaderView.h"
#import "DYGTapGestureRecognizer.h"
#import "HRAdView.h"

@interface DYGHomeHeaderView()<UIScrollViewDelegate>

@property(nonatomic,strong)UIScrollView * MyScrollView;
@property(nonatomic,weak)UIPageControl *paegController;
@property(nonatomic,weak)UIButton * selectBtn;
@property (nonatomic,strong) HRAdView *adView;
@property (nonatomic,strong) UIImageView *defaultImgV;
@property (nonatomic,strong) UIImageView *clawsImgV;

@end

@implementation DYGHomeHeaderView

-(instancetype)init{
    if (self = [super init]) {
        [self creatSubViews];
    }
    return self;
}
-(void)creatSubViews{
    self.MyScrollView = [UIScrollView new];
    self.MyScrollView.pagingEnabled = YES;
    self.MyScrollView.delegate = self;
    self.MyScrollView.backgroundColor = [UIColor whiteColor];
    self.MyScrollView.frame = CGRectMake(0, 0, self.width, Py(100));
    self.MyScrollView.layer.cornerRadius = 20;
    [self addSubview:self.MyScrollView];
    
    if (self.adArray.count == 0) {
        self.defaultImgV = [UIImageView new];
        self.defaultImgV.frame = self.MyScrollView.bounds;
        self.defaultImgV.image = [UIImage imageNamed:@"home_banner_default"];
        [self addSubview:self.defaultImgV];
    }else{
        self.MyScrollView.contentSize = CGSizeMake(self.adArray.count*self.width, Py(100));
        self.MyScrollView.showsHorizontalScrollIndicator = NO;
        for (int i = 0; i<self.adArray.count; i++) {
            self.scrollImage = [[UIImageView alloc]initWithFrame:CGRectMake(i*self.width, 0, self.width, self.MyScrollView.height)];
            NSString * urlStr = self.adArray[i];
            [self.scrollImage sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"home_banner_default"]];
            self.scrollImage.tag = i;
            self.scrollImage.userInteractionEnabled = YES;
            DYGTapGestureRecognizer * tap = [[DYGTapGestureRecognizer alloc]initWithTarget:self action:@selector(imgDidClick:)];
            tap.tag = i;
            [self.scrollImage addGestureRecognizer:tap];
            [self.MyScrollView addSubview:self.scrollImage];
        }
    }
    
    UIPageControl * page = [[UIPageControl alloc]init];
    self.paegController = page;
    page.numberOfPages = self.adArray.count;
    page.pageIndicatorTintColor = [UIColor whiteColor];
    page.currentPageIndicatorTintColor = [UIColor orangeColor];
    [self addSubview:page];
    CGFloat h = (CGFloat )16/1334;
    [page mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.MyScrollView.mas_bottom).offset(kScreenHeight * h);
        make.centerX.equalTo(self.mas_centerX);
    }];
    self.adView = [[HRAdView alloc]initWithTitles:self.scrollAdArr];
    self.adView.isHaveHeadImg = YES;
    self.adView.headImg = [UIImage imageNamed:@"home_notice"];
    self.adView.bgImg = [UIImage imageNamed:@"home_notice_bg"];
    self.adView.labelFont = [UIFont systemFontOfSize:12];
    self.adView.color = DYGColorFromHex(0xefa300);
    [self beginScroll];
    [self addSubview:self.adView];
    [self.adView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.MyScrollView.mas_bottom).offset(Py(8));
        make.left.equalTo(self.mas_left).offset(Px(35.5));
        make.right.equalTo(self.mas_right).offset(Px(-35.5));
        make.height.equalTo(@(Py(34)));
    }];
    self.adView.clipsToBounds = YES;
    
    self.clawsImgV = [[UIImageView alloc] init];
    self.clawsImgV.image = [UIImage imageNamed:@"home_banner_claws"];
    self.clawsImgV.frame = CGRectMake(kScreenWidth/2.0-19, Py(68), 38.5, 53);
    self.clawsImgV.centerX = [UIScreen mainScreen].bounds.size.width/2.0;
    [self addSubview:self.clawsImgV];
    [self sendSubviewToBack:self.clawsImgV];
}
-(void)beginScroll{
    [self.adView beginScroll];
}
-(void)stopScroll{
    [self.adView closeScroll];
}
-(void)imgDidClick:(DYGTapGestureRecognizer *)tap{
    [self.timer invalidate];
    self.timer = nil;
    if ([self.delegate respondsToSelector:@selector(loadWebViewWithImgIndex:)]) {
        [self.delegate loadWebViewWithImgIndex:tap.tag];
    }
    
}

//滑动的方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    int page = (self.MyScrollView.contentOffset.x + self.MyScrollView.frame.size.width * 0.5 )/self.MyScrollView.frame.size.width;
    self.paegController.currentPage = page;
    
}

-(void)changeScrollView{
    
    if (self.MyScrollView.contentOffset.x >=self.MyScrollView.bounds.size.width * (self.adArray.count-1)) {
        [self.MyScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }else{
        CGPoint offset = self.MyScrollView.contentOffset;
        offset.x += self.MyScrollView.frame.size.width;
        [self.MyScrollView setContentOffset:offset animated:YES];
    }
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
        [self starTimer];
}
//设置定时器;
-(void)starTimer{
    
    NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(changeScrollView) userInfo:nil repeats:YES];
    self.timer = timer;
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

//当手指按上去的时候，移除定时器
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //    让定时器失效， 当定时器失效 再去调用fire无法重新开启。
    [self.timer invalidate];
    
    self.timer = nil;
}
-(void)setAdArray:(NSArray *)adArray{
    _adArray =adArray;
    for (UIView * v in self.subviews) {
        [v removeFromSuperview];
    }
    [self creatSubViews];
}
-(void)setScrollAdArr:(NSArray *)scrollAdArr{
    _scrollAdArr = scrollAdArr;
    for (UIView * v in self.subviews) {
        [v removeFromSuperview];
    }
    [self creatSubViews];
}

@end
