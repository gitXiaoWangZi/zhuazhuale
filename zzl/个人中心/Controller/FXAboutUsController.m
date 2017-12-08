//
//  FXAboutUsController.m
//  zzl
//
//  Created by Mr_Du on 2017/11/9.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "FXAboutUsController.h"
#import "FXGameWebController.h"

@interface FXAboutUsController ()

@property(nonatomic,strong)UIImageView * icon;
@property (nonatomic,strong) UILabel *name;
@property (nonatomic,strong) UILabel *version;
@property (nonatomic,strong) UILabel * Tk;
@property (nonatomic,strong) UIImageView *footerImg;

@end

@implementation FXAboutUsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"关于我们";
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatUI];
}

-(void)creatUI{
    [self.view addSubview:self.icon];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(Py(82));
    }];
    [self.view addSubview:self.name];
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.icon.mas_bottom).offset(Px(10));
    }];
    [self.view addSubview:self.footerImg];
    [self.footerImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-Py(35));
    }];
    [self.view addSubview:self.Tk];
    [self.Tk mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.footerImg.mas_top).offset(-Py(13));
    }];
    [self.view addSubview:self.version];
    [self.version mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.Tk.mas_top).offset(-Py(20));
    }];
}


#pragma mark lazy load

-(UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"aboutLogo"]];
        [_icon sizeToFit];
    }
    return _icon;
}
-(UILabel *)name{
    if (!_name) {
        _name = [UILabel labelWithMediumFont:16 WithTextColor:systemColor];
        _name.text = @"抓抓乐";
        _name.textAlignment = NSTextAlignmentCenter;
    }
    return _name;
}
-(UILabel *)version{
    if (!_version) {
        _version = [UILabel labelWithMediumFont:14 WithTextColor:DYGColorFromHex(0x4c4c4c)];
        _version.text = @"V1.0";
        _version.textAlignment = NSTextAlignmentCenter;
    }
    return _version;
}
-(UILabel *)Tk{
    if (!_Tk) {
        _Tk = [UILabel labelWithFont:14 WithTextColor:DYGColorFromHex(0x777777)];
        _Tk.textAlignment = NSTextAlignmentCenter;
        NSString *textStr =@"使用条款和隐私条款";
        NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:textStr attributes:attribtDic];
        _Tk.attributedText =attribtStr;
        _Tk.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clikWeb:)];
        [_Tk addGestureRecognizer:tap];
    }
    return _Tk;
}
-(UIImageView *)footerImg{
    if (!_footerImg) {
        _footerImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"footer"]];
        [_footerImg sizeToFit];
    }
    return _footerImg;
}

- (void)clikWeb:(UITapGestureRecognizer *)tap {
    FXGameWebController *web = [[FXGameWebController alloc] init];
    web.titleName = @"用户协议";
    web.url = @"http://openapi.wawa.zhuazhuale.xin/agreement";
    [self.navigationController pushViewController:web animated:YES];
}
@end









