//
//  NSArray+DYGAdd.h
//  test
//
//  Created by Mr_Du on 2017/10/29.
//  Copyright © 2017年 Mr_Du. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (DYGAdd)
//数组元素按照A-Z首字母分组并排序
+(instancetype)elementsWithCH_CNAndEgSort:(NSArray *)sourceData;
//二维数组转换成一维数组
+(instancetype)arrayWithTwoDimensionalArray:(NSArray *)array;
@end
