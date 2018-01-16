//
//  WwGameManager.h
//  WawaSDK
//
//  Copyright © 2017年 杭州阿凡达网络科技有限公司 All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WwDataDef.h"
#import "WwConstants.h"

@protocol WwGameManagerDelegate <NSObject>

// game
- (void)gameManagerError:(UserInfoError)error;

// stream
- (void)onMasterStreamReady;  /**< 主摄像头的流已经加载成功了*/
- (void)onSlaveStreamReady;   /**< 辅摄像头的流已经加载成功了*/

// rtmp
- (void)pushStatusDidChanged:(WwRtmpPush)status;  /**< 推流状态发生了变化*/
- (void)playStatusDidChanged:(WWRtmpPlay)status;  /**< 拉流状态发生了变化*/

// IM
- (void)reciveRemoteMsg:(WwChatMessage *)chatM; /**< 收到聊天回调*/
- (void)reciveWatchNumber:(NSInteger)number; /**< 收到 观看人数*/
- (void)reciveRoomUpdateData:(WwRoomDataMessage *)liveData; /**< 收到 房间状态更新*/
- (void)reciveClawResult:(WwClawResultMessage *)result; /**< 房间内收到 抓娃娃结果通知*/
- (void)reciveGlobleMessage:(WwGlobalMessage *)notify; /**< 收到全平台 抓娃娃结果通知*/

// Tool
- (void)avatarTtlDidChanged:(NSInteger)ttl; /**< ping游戏服务器延迟变更, 每2s ping一次*/

@end


typedef NS_ENUM(NSInteger, PlayDirection) {
    PlayDirection_None = -1, // 未知
    PlayDirection_Up,   // 上
    PlayDirection_Left,// 左
    PlayDirection_Down,// 下
    PlayDirection_Right,// 右
    PlayDirection_Confirm,// 下抓
};

typedef NS_ENUM(NSInteger, PlayOperationType) {
    PlayOperationType_Click,    // 点击
    PlayOperationType_LongPress,// 长按
    PlayOperationType_Release, // 抬起
    PlayOperationType_Reverse, // 撤销长按
};


/**
 * WwGameManager是房间内游戏管理对象，负责:
 * 1.加入房间: 包含加入房间的数据完整性校验
 * 2.房间信息获取：包括当前房间信息与状态，娃娃详情查询
 * 3.观众列表获取与定时刷新
 * 4.发送弹幕、接收弹幕
 * 5.上机请求
 * 6.发送操作指令、切换摄像头等游戏操作
 * 7.接收游戏结果
 */

@interface WwGameManager : NSObject

@property (nonatomic, weak) id<WwGameManagerDelegate> delegate;

@property (nonatomic, strong) WwRoom * currentRoom;                 /**< 当前的房间信息*/

/**
 * 获取WwGameManager 单例
 */
+ (instancetype)GameMgrInstance;

/*
 * 加入房间, 需要传入房间列表页给接入方的room字段,
 * SDK内部会对必要数据进行校验,如果校验不通过会直接返回nil
 * 必要字段有: ID, streamMaster, streamSlave
 */
- (UIView *)enterRoomWith:(WwRoom *)room;



/*
 * 开始推流
 * 此动作必须要在上机成功之后执行, 否则会失败
 */
- (UIView *)startPushRtmpWithIsAudioOnly:(BOOL)isAudioOnly;

/*
 * 停止推流
 */
- (void)endPushRtmp;

/*
 * 开始拉取游戏者的流,需要传入拉流地址吗,
 * SDK内部会对必要数据进行校验,如果校验不通过会直接返回nil
 * 必要字段有: playUrl
 */
- (UIView *)startPlayRtmp:(NSString *)playUrl isAudioOnly:(BOOL)isAudioOnly;

/*
 * 停止拉流
 */
- (void)endPlayRtmp;



/*
 * 销毁房间, 离开房间时务必调用, 否则会影响之后的逻辑
 */
- (void)exitRoom;

/*
 * 开始播放娃娃机视频流换面
 */
- (void)startGamePlayer;

/*
 * 停止播放娃娃机视频流换面
 */
- (void)stopGamePlayer;

/*
 * 特别注意: 在调用此接口前, 请确保用户信息已经注入到SDK用户信息回调中, 否则上机操作会直接失败
 * SDK内部会对传入数据进行判空处理,如果判断传入的房间ID为空会直接回调失败block并返回
 */
- (void)requestStartGameWithComplete:(void(^)(NSInteger code, NSString * msg, NSString * orderID))block;

/*
 * 游戏操作, 上下左右操作
 */
- (void)requestOperation:(PlayDirection)direction
           operationType:(PlayOperationType)operationType
            withComplete:(void(^)(NSInteger code, NSString *msg))complete;

/*
 * 游戏操作, 下爪操作
 * 注: 下爪操作涉及到硬件上的判断娃娃到底有没有抓到, 所以结果回调需要相对较长的时间
 * 参数说明: 要不要强制释放上机锁定(例如:用户点击了下爪之后,在结果回来之前就离开了房间,就放弃了再来一局的机会,需要传入YES来释放等待用户8s选择是否再来一局的必要)
 */
- (void)requestClawWithForceRelease:(BOOL)forceRelease
                       withComplete:(void(^)(NSInteger code, NSString * msg, WwGameResult * resultM))block;


/*
 * 发送弹幕, 需要传入要发送的字符串
 * SDK内部会对传入的数据进行判空处理,如果判断传入的参数不为NSString类型或为nil或长度为空,会直接返回
 */
- (void)sendDamuMsg:(NSString *)msg;

/*
 * 切换摄像头
 * 参数说明 isMaster:是否要切换到正面摄像头, 传入YES会切换到正面摄像头, 传入NO则会切换到侧面摄像头
 */
- (void)cameraSwitchIsFront:(BOOL)isFront;



#pragma mark - Tool

/*
 * 工具接口: ping游戏服务器
 * 说明: 此接口用于ping游戏服务器, 来观察延迟用于提示用户是否可以上机, 默认不会开启的
 */
- (void)enablePing:(BOOL)enable;

@end
