//
//  DYGHttpTool.m
//  UD
//
//  Created by DoDoDo.D on 2017/5/16.
//  Copyright © 2017年 FanXing. All rights reserved.
//

#import "DYGHttpTool.h"
#import <CommonCrypto/CommonDigest.h>
#import "DYGGetUrl.h"
static AFHTTPSessionManager * mgr;

@implementation DYGHttpTool


+(void)getWithURL:(NSString *)url params:(NSDictionary *)params sucess:(void (^)(id))sucess failure:(void (^)(NSError *))failure{
    
    NSString * baseUrl =@"http://openapi.wawa.zhuazhuale.xin/";
    url = [baseUrl stringByAppendingString:url];
//    NSString * endUrl = [DYGGetUrl connectUrl:[self encryptSign:params].mutableCopy url:url];
    
    mgr = [AFHTTPSessionManager manager];
    [mgr.requestSerializer
     setValue:@"application/octet-stream"
     forHTTPHeaderField:@"Content-Type"];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    [mgr GET:url parameters:[self encryptSign:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (sucess) {
            sucess(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
            
        }
    }];
}

+(void)postWithURL:(NSString *)url params:(NSDictionary *)params sucess:(void (^)(id))sucess failure:(void (^)(NSError *))failure{
    
    NSString * baseUrl =@"http://openapi.wawa.zhuazhuale.xin/";
    url = [baseUrl stringByAppendingString:url];
    mgr = [AFHTTPSessionManager manager];
//    [mgr.requestSerializer
//     setValue:@"application/x-www-form-urlencoded"
//     forHTTPHeaderField:@"Content-Type"];
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    mgr.requestSerializer.timeoutInterval = 10;
    [mgr POST:url parameters:[self encryptSign:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //获得access_token，然后根据access_token获取用户信息请求。
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dic);
        if (sucess) {
            sucess(dic);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(failure){
            failure(error);
           
        }
    }];
}
//params传入的参数字典
+(NSDictionary *)encryptSign:(NSDictionary *)params{
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
    
    NSDictionary * versionDict = [NSBundle mainBundle].infoDictionary;
    NSString * version = versionDict[@"CFBundleShortVersionString"];
    
   NSMutableDictionary *dict =@{@"appid":@"2017081014329854",@"appsecret":@"IOS02bca5a9db076ee14aa841ab60735e74",@"timestamp":timeSp,@"os":@"ios",@"version":version}.mutableCopy;
    [dict addEntriesFromDictionary:params];
    NSMutableArray *keyArr = [NSMutableArray array];
    [dict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString *  _Nonnull obj, BOOL * _Nonnull stop) {
        [keyArr addObject:key];
    }];
    ///排序
    [keyArr sortUsingSelector:@selector(compare:)];
    NSMutableString *signStr = [NSMutableString string];
    for (NSString *key in keyArr) {
        NSString *str = [NSString stringWithFormat:@"%@=%@",key,dict[key]];
        ///拼接sign
        [signStr appendString:str];
    }
    NSMutableDictionary *dict2 = @{@"timestamp":timeSp,@"os":@"ios"}.mutableCopy;
    [dict2 addEntriesFromDictionary:params];
    [dict2 addEntriesFromDictionary:@{@"sign":[self sha1:signStr]}];
    
    return  dict2.copy;
}

+(NSString *)sha1:(NSString *)input{

    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

//微信请求
+ (void)getWXWithPath:(NSString *)path params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];//请求
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",@"text/plain",nil];
    
    //对url进行处理
    path = [NSString stringWithFormat:@"%@?",path];
    for (NSString *key in [params allKeys]) {
        path = [path stringByAppendingString:[NSString stringWithFormat:@"%@=%@&",key,[params objectForKey:key]]];
    }
    path = [path substringToIndex:path.length-1];
    
    [manager GET:path parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //获得access_token，然后根据access_token获取用户信息请求。
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"%@",dic);
        if (success) {
            success(dic);
        }
        /*
         access_token   接口调用凭证
         expires_in access_token接口调用凭证超时时间，单位（秒）
         refresh_token  用户刷新access_token
         openid 授权用户唯一标识
         scope  用户授权的作用域，使用逗号（,）分隔
         unionid     当且仅当该移动应用已获得该用户的userinfo授权时，才会出现该字段
         */
        //            NSString *accessToken = [dic valueForKey:@"access_token"];
        //
        //            NSString *openID = [dic valueForKey:@"openid"];
        //
        //            [weakSelf requestUserInfoByToken:accessToken andOpenid:openID];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error %@",error.localizedFailureReason);
    }];
}
@end
