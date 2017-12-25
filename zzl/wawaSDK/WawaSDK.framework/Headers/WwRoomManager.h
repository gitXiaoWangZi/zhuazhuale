//
//  WwRoomManager.h
//  WawaSDK
//
//  Copyright © 2017年 杭州阿凡达网络科技有限公司 All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WwDataDef.h"

@protocol WwRoomManagerDelegate <NSObject>

/**
 * 通知接入方客户端，当前房间列表首页数据有变化(主要是房间状态)
 */
- (void)onRoomListChange:(NSArray <WwRoom *> *)roomList;


/**
 * 通知接入方客户端，当前进入房间的观众列表数据有变化
 * @param userList 首页观众列表
 */
- (void)onViewerListChange:(NSArray <WwUser *> *)userList;

@end

/**
 * WwRoomManager是房间列表管理对象，负责:
 * 1.获取游戏房间列表
 * 2.订阅游戏房间状态
 */

@interface WwRoomManager : NSObject

/**
 * WwRoomManager 的代理对象
 */
@property (nonatomic, weak) id<WwRoomManagerDelegate> delegate;

/**< 首页房间列表刷新timer间隔，默认15s，通过代理方法onRoomListChange:通知出去
 * Note: 当修改roomRefreshInterval时，会销毁当前刷新定时器并重新创建
 */
@property (nonatomic, readonly) NSTimeInterval roomRefreshInterval;

/**
 * 观众列表刷新timer间隔，默认5s，通过代理方法onViewerListChange:通知出去
 */
@property (nonatomic, readonly) NSTimeInterval viewerRefreshInterval;

/**
 * 获取 WwRoomManager 单例
 */
+ (instancetype)RoomMgrInstance;

#pragma mark - Room List
/**
 * 请求房间列表
 * @param page 请求列表页，从1开始
 * @param size 每页个数
 * @param complete 回调block: code 返回码，message 返回信息，list 返回房间数据列表
 */
- (void)requestRoomList:(NSInteger)page
                   size:(NSInteger)size
           withComplete:(void (^)(NSInteger code, NSString *message, NSArray<WwRoom *> *list))complete;

/**
 * 请求指定房间信息
 * @param ids 房间ID列表
 * @param complete 回调block: code 返回码，message 返回信息，list 返回房间数据列表
 */
- (void)requestRoomListByIds:(NSArray <NSString *>*)ids
                withComplete:(void (^)(NSInteger code, NSString *message, NSArray<WwRoom *> *list))complete;

/**
 * 启动首页数据刷新定时器
 * Note: 该方法首先会销毁当前刷新定时器，并根据当前period重新创建新的刷新定时器
 * @param period 定时器触发间隔，单位S, 最小5S
 */
- (void)startRequestRoomTimer:(NSTimeInterval)period;

/**
 * 停止首页数据刷新定时器
 * Note: 该方法会立即停止当前激活的刷新定时器
 */
- (void)cancelRequestRoomTimer;

/*
 * 快速上机请求, 无需传入参数, 会根据当前的机器空闲情况自动为用户分配可使用的机器
 * 特别注意: 此接口只是分配一个空闲中的房间给用户, 用户需要自己做 enterRoom 动作
 */
- (void)requestQuickStartWithComplete:(void(^)(NSInteger code ,NSString * msg, WwRoom * room))block;

#pragma mark - Room Info
/*
 * 获取房间信息与状态接口, 需要接入方注入房间ID字段,
 * SDK内部会对传入数据进行判空处理,如果判断传入的房间ID为空会直接回调失败block并返回
 * 必要字段有: roomId
 */
- (void)requestRoomInfo:(NSInteger)roomId
           withComplete:(void(^)(NSInteger code, NSString *message, WwRoom *roomInfo))complete;

#pragma mark - Viewer
/*
 * 观众列表获取, 需要传入房间ID, 页数
 * SDK内部会对传入数据进行判空处理,如果判断传入的房间ID为空会直接回调失败block并返回
 * 必要字段有: roomId
 */
- (void)requestViewerWithRoomId:(NSInteger)roomId
                           page:(NSInteger)page
                   withComplete:(void(^)(NSInteger code, NSString *message, NSArray <WwUser *>* userList))complete;

/**
 * 开启定时刷新观众列表定时器，房间默认为当前进入的房间
 * @param period 定时器触发间隔，单位S, 最小10S
 */
- (void)startRequestViewerTimer:(NSTimeInterval)period;

/**
 * 取消刷新观众列表定时器
 */
- (void)cancelRequestViewerTimer;

/**
 * 娃娃详情查询, 需要传入娃娃ID字段
 * SDK内部会对传入数据做判空处理,如果判断传入的娃娃ID为空会直接回调失败block并返回
 * @param wid 娃娃id
 * @param complete 回调
 */
- (void)requestWawaDetail:(NSInteger)wid
             withComplete:(void(^)(NSInteger code, NSString *message, WwWaWaDetail *waInfo))complete;


/**
 * 查询房间最近抓中记录
 * @param roomId 房间ID
 * @param page 请求第几页数据
 * @param block 回调
 */
- (void)requestCatchHistory:(NSInteger)roomId
                     atPage:(NSInteger)page
               withComplete:(void(^)(NSInteger code, NSString *message, NSArray<WwRoomCatchRecordItem *> *list))block;

/**
 * 请求回放中 游戏操作信息
 * @param roomId 房间ID
 * @param startTimeSecond 游戏开始时间，单位S
 * @param piece 第几片数据 从1开始，1片30s
 */
- (void)requestReplayVideoMessage:(NSInteger)roomId
                        startTime:(NSTimeInterval)startTimeSecond
                            piece:(NSInteger)piece
                     withComplete:(void(^)(NSInteger code, NSString *message, NSArray <NSDictionary *> *list))complete;

/*
 * 工具接口: 获取当前的服务器时间
 * 说明: 此接口用于分享游戏的时候获取服务器时间戳, 用于前端获取分享时间点, 进而获取分享时间点前后的游戏视频流
 */
- (void)requestServerTime:(void(^)(NSTimeInterval))block;

@end
