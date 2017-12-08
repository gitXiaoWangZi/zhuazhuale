//
//  NSBundle+DYGAdd.h
//  test
//
//  Created by Mr_Du on 2017/10/29.
//  Copyright © 2017年 Mr_Du. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSBundle (DYGAdd)
//短版本号 对外公开版本号
+(CGFloat)versionNum;
//第一次进入App或者更新程序
+(BOOL)isFirstOrUpdate;
@end
