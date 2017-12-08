//
//  LSJHasNetwork.m
//  zzl
//
//  Created by Mr_Du on 2017/12/1.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "LSJHasNetwork.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>

@implementation LSJHasNetwork

+ (void)lsj_hasNetwork:(void(^)(bool has))hasNet
{
    //创建网络监听对象
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    //开始监听
    [manager startMonitoring];
    //监听改变
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            case AFNetworkReachabilityStatusNotReachable:
                hasNet(NO);
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                hasNet(YES);
                break;
        }
    }];
    //结束监听
    [manager stopMonitoring];
}
@end
