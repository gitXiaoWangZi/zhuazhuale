//
//  ZXContactInfo.m
//  拼音排序
//
//  Created by chris on 17/6/23.
//  Copyright © 2017年 chris. All rights reserved.
//

#import "ZXContactInfo.h"


@implementation ZXContactInfo
-(instancetype)initWithContact:(CNContact *)contact{
    if (self = [super init]) {
        NSMutableArray *tempArr = [NSMutableArray array];
        for (CNLabeledValue *label in contact.phoneNumbers) {
            CNPhoneNumber *number = label.value;
            [tempArr addObject:number.stringValue];
        }
        if (tempArr.count == 1) {
        _onlyPhoneNum = YES;
        _phoneNumber  = tempArr.firstObject;
        }
        _familyName = contact.familyName;  //姓
        _givenName = contact.givenName;    //名
        _fullName = [contact.familyName stringByAppendingString:contact.givenName];
        _phoneNumbers = tempArr.copy;
    }
    return self;
}
-(NSString *)description{
    return [NSString stringWithFormat:@"%@==%@==%@==%@==%@==%@",self.phoneNumbers,self.phoneNumber,self.onlyPhoneNum ? @"Yes" : @"No",self.familyName,self.givenName,self.fullName];
}
@end
