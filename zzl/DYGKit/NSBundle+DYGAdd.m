//
//  NSBundle+DYGAdd.m
//  test
//
//  Created by Mr_Du on 2017/10/29.
//  Copyright © 2017年 Mr_Du. All rights reserved.
//

#import "NSBundle+DYGAdd.h"

@implementation NSBundle (DYGAdd)

+(CGFloat)versionNum{
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    return [infoDict[@"CFBundleShortVersionString"] floatValue];
}
+(BOOL)isFirstOrUpdate{
    CGFloat cacheNum = [[NSUserDefaults standardUserDefaults] floatForKey:@"ZXCurrenVersionNum"];
    CGFloat versionNum = [self versionNum];
    [[NSUserDefaults standardUserDefaults] setFloat:versionNum forKey:@"ZXCurrenVersionNum"];
    return ! (versionNum == cacheNum);
}
@end
