//
//  DYGUserInfoManger.m
//  test
//
//  Created by Mr_Du on 2017/10/29.
//  Copyright © 2017年 Mr_Du. All rights reserved.
//

#import "DYGUserInfoManger.h"
static DYGUserInfoManger * manger = nil;
@implementation DYGUserInfoManger{
    BOOL _hasLogin;
}
+(instancetype)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manger = [[DYGUserInfoManger alloc]init];
    });
    return manger;
}

-(BOOL)isLogin{
    return _hasLogin;
}
-(void)login{
    NSLog(@"登录");
    _hasLogin = YES;
}
-(void)loginOUt{
    NSLog(@"退出");
    [self clearLoginCache];
}
-(void)clearLoginCache{
    
}
@end
