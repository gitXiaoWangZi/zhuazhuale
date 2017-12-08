//
//  DYGHttpTool.h
//  UD
//
//  Created by DoDoDo.D on 2017/5/16.
//  Copyright © 2017年 FanXing. All rights reserved.
//

#import <AFNetworking.h>

@interface DYGHttpTool : AFHTTPSessionManager

//get 请求
+(void)getWithURL:(NSString *)url params:(NSDictionary *)params sucess:(void(^)(id json))sucess failure:(void(^)(NSError * error))failure;


//post请求

+(void)postWithURL:(NSString *)url params:(NSDictionary *)params sucess:(void(^)(id json))sucess failure:(void(^)(NSError * error))failure;

@property(nonatomic,copy)NSString * endUrl;

//微信调的接口
+ (void)getWXWithPath:(NSString *)path params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure;

@end
