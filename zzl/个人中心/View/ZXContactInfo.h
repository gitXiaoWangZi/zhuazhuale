//
//  ZXContactInfo.h
//  拼音排序
//
//  Created by chris on 17/6/23.
//  Copyright © 2017年 chris. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Contacts/Contacts.h>
@interface ZXContactInfo : NSObject
@property(nonatomic,strong)NSArray<NSString *> *phoneNumbers;
//如果只有一个电话的话
@property(nonatomic,copy)NSString *phoneNumber;
//是否只有一个联系电话
@property(nonatomic,assign)BOOL onlyPhoneNum;
//姓
@property(nonatomic,copy)NSString *familyName;
//名
@property(nonatomic,copy)NSString *givenName;
//全名
@property(nonatomic,copy)NSString *fullName;
-(instancetype)initWithContact:(CNContact *)contact;
@end
