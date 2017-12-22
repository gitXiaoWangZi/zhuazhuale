//
//  VisiteTools.h
//  zzl
//
//  Created by Mr_Du on 2017/12/21.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VisiteTools : NSObject

+ (instancetype)shareInstance;

- (BOOL)isVisite;
- (void)outLogin;
@end
