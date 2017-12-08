//
//  LSJHasNetwork.h
//  zzl
//
//  Created by Mr_Du on 2017/12/1.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSJHasNetwork : NSObject

+ (void)lsj_hasNetwork:(void(^)(bool has))hasNet;

@end
