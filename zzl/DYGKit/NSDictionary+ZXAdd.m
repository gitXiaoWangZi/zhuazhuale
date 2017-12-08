//
//  NSDictionary+ZXAdd.m
//  FFMobileBike
//
//  Created by chris on 17/9/14.
//  Copyright © 2017年 chris. All rights reserved.
//

#import "NSDictionary+ZXAdd.h"

@implementation NSDictionary (ZXAdd)
-(BOOL)containsKey:(NSString *)key{
    for (NSString *someKey in [self allKeys]) {
        if ([key isEqualToString:someKey]) {
            return YES;
        }
    }
    return NO;
}
@end
