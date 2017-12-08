//
//  NSData+DYGAdd.m
//  test
//
//  Created by Mr_Du on 2017/10/29.
//  Copyright © 2017年 Mr_Du. All rights reserved.
//

#import "NSData+DYGAdd.h"

@implementation NSData (DYGAdd)
+(NSString *)dateString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd|HH:mm";
    return [formatter stringFromDate:[NSDate date]];
}
+(NSString *)currentDateString{
    return [[[self dateString] componentsSeparatedByString:@"|"] firstObject];
}
+(NSString *)currentTimeString{
    return [[[self dateString] componentsSeparatedByString:@"|"] lastObject];
}
@end
