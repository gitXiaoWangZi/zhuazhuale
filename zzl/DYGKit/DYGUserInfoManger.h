//
//  DYGUserInfoManger.h
//  test
//
//  Created by Mr_Du on 2017/10/29.
//  Copyright © 2017年 Mr_Du. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DYGUserInfoManger : NSObject
+(instancetype)shareManager;
-(BOOL)isLogin;
-(void)login;
-(void)loginOUt;
@end
