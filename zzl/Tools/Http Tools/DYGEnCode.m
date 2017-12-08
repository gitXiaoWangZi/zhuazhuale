//
//  DYGEnCode.m
//  传入字符串:把字符串的每一个字符转成 ASCII, 把ASCII由10进制转化成36进制
//  Created by Mr_Du on 2017/8/16.
//  Copyright © 2017年 Mr_Du. All rights reserved.
//

#import "DYGEnCode.h"

@implementation DYGEnCode

+(NSString *)EncodeWithString:(NSString *)string{
    NSMutableArray * array = [NSMutableArray array];
    for (int i = 0; i<string.length; i++) {
        [array addObject:[NSNumber numberWithChar:[string characterAtIndex:i]]];
    }
//    DYGLog(@"arr:%@",array);
    NSString * lastStr = @"";
    for (int i = 0; i<array.count; i++) {
        NSString * str = array[i];
        int ask = str.intValue;
        lastStr = [lastStr stringByAppendingString:[self ToHex:ask]];
    }
    
    return  lastStr;
}

+(NSString *)DecodeWithEncodeString:(NSString *)string{
//    1D1F1J1F1H1G1H1C1G1F1E
//    13735450432
    NSString * tempStr = string;
    NSMutableArray * array = [NSMutableArray array];
    for (int i = 0; i<(string.length/2); i++) {
        NSString * oldStr = [tempStr substringToIndex:2];
        tempStr = [tempStr substringFromIndex:2];
        [array addObject:oldStr];
    }
    NSMutableArray * tempArr = [NSMutableArray array];
    for (int i = 0; i<array.count; i++) {
        NSString * oldStr = array[i];
        NSString * str= @"";
        str = [oldStr substringToIndex:1];
        oldStr = [oldStr substringFromIndex:1];
        NSString * tenStr = [self ToTen:oldStr];
        NSString * lastStr =  [NSString stringWithFormat:@"%c",(str.intValue *36 + tenStr.intValue)];
        [tempArr addObject:lastStr];
    }
    NSString * lastStr = @"";
    for (int i = 0; i<tempArr.count; i++) {
        lastStr = [lastStr stringByAppendingString:tempArr[i]];
    }
    return lastStr;
}

+(NSString *)ToHex:(uint16_t)tmpid
{
    NSString *nLetterValue;
    NSString *str =@"";
    uint16_t ttmpig;
    for (int i = 0; i<36; i++) {
        ttmpig=tmpid%36;
        tmpid=tmpid/36;
        switch (ttmpig)
        {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break;
            case 16:
                nLetterValue =@"G";break;
            case 17:
                nLetterValue =@"H";break;
            case 18:
                nLetterValue =@"I";break;
            case 19:
                nLetterValue =@"J";break;
            case 20:
                nLetterValue =@"K";break;
            case 21:
                nLetterValue =@"L";break;
            case 22:
                nLetterValue =@"M";break;
            case 23:
                nLetterValue =@"N";break;
            case 24:
                nLetterValue =@"O";break;
            case 25:
                nLetterValue =@"P";break;
            case 26:
                nLetterValue =@"Q";break;
            case 27:
                nLetterValue =@"R";break;
            case 28:
                nLetterValue =@"S";break;
            case 29:
                nLetterValue =@"T";break;
            case 30:
                nLetterValue =@"U";break;
            case 31:
                nLetterValue =@"V";break;
            case 32:
                nLetterValue =@"W";break;
            case 33:
                nLetterValue =@"X";break;
            case 34:
                nLetterValue =@"Y";break;
            case 35:
                nLetterValue =@"Z";break;
            default:
                nLetterValue = [NSString stringWithFormat:@"%u",ttmpig];
                
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;
        }
    }
    return str;
}
    
+(NSString *)ToTen:(NSString *)str{
    
    NSDictionary *dict = @{@"A":@"10",@"B":@"11",@"C":@"12",@"D":@"13",@"E":@"14",@"F":@"15",@"G":@"16",@"H":@"17",@"I":@"18",@"J":@"19",@"K":@"20",@"L":@"21",@"M":@"22",@"N":@"23",@"O":@"24",@"P":@"25",@"Q":@"26",@"R":@"27",@"S":@"28",@"T":@"29",@"U":@"30",@"V":@"31",@"W":@"32",@"X":@"33",@"Y":@"34",@"Z":@"35"};
  
    NSString * reStr = dict[[NSString stringWithFormat:@"%@",str]];
    
    return reStr;
    
}

@end
