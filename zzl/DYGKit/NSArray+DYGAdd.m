//
//  NSArray+DYGAdd.m
//  test
//
//  Created by Mr_Du on 2017/10/29.
//  Copyright © 2017年 Mr_Du. All rights reserved.
//
#import "NSArray+DYGAdd.h"

@implementation NSArray (DYGAdd)

+(instancetype)elementsWithCH_CNAndEgSort:(NSArray *)sourceData{
    NSArray* fCNAlphabetArr = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
    NSMutableArray *sortArr = [NSMutableArray array];
    for (int i=0; i<fCNAlphabetArr.count; i++) {
        NSMutableArray *sectionArr = [NSMutableArray array];
        [sortArr addObject:sectionArr];
    }
    for (NSString *name in sourceData) {
        NSMutableString *str = [[NSMutableString alloc] initWithString:name];
        //汉语转拼音
        CFStringTransform((__bridge CFMutableStringRef)str, 0, kCFStringTransformMandarinLatin, NO);
        //去掉音调
        CFStringTransform((__bridge CFMutableStringRef)str, 0, kCFStringTransformStripDiacritics, NO);
        
        //获取首字母   输出字母ASCII码 A-z 65~122 %hu打印asc码
        UniChar firstAlphabetU = [str characterAtIndex:0];
        //%c ASCII码转换成字符串
        NSString *firstLetter = [NSString stringWithFormat:@"%c",firstAlphabetU];
        //小写转换成大写
        firstLetter = [firstLetter uppercaseString];
        [fCNAlphabetArr enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([firstLetter isEqualToString:obj]){
                NSMutableArray *arr = sortArr[idx];
                [arr addObject:name];
                *stop = YES;
            }
        }];
    }
    //排序
    [sortArr enumerateObjectsUsingBlock:^(NSMutableArray*  _Nonnull arr, NSUInteger i, BOOL * _Nonnull stop) {
        [arr sortUsingComparator:^NSComparisonResult(NSString * _Nonnull obj1, NSString * _Nonnull obj2) {
            if ([obj1 localizedCompare:obj2] == 1) {
                return NSOrderedDescending;
            } else {
                return NSOrderedAscending;
            }
        }];
    }];
    return sortArr.copy;
}

+(instancetype)arrayWithTwoDimensionalArray:(NSArray *)array{
    NSMutableArray *oneDArr = [NSMutableArray array];
    for (NSArray *arr in array) {
        for (id element in arr) {
            [oneDArr addObject:element];
        }
    }
    return oneDArr.copy;
}


@end
