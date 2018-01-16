//
//  WwUserInfoManager.h
//  WawaSDK
//
//  Copyright © 2017年 杭州阿凡达网络科技有限公司 All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WwDataDef.h"
#import "WwConstants.h"

typedef NS_OPTIONS(NSUInteger, WwWawaListType) {
    WawaList_Deposit = 1<<0,    /**< 寄存中*/
    WawaList_Deliver = 1<<1,    /**< 准备发货*/
    WawaList_Exchange = 1<<2,   /**< 已兑换*/
    WawaList_All = 1<<3,        /**< 全部*/
};

@class WwUserWawaModel;
@class UserInfo;

/**
 * WwUserInfoManager代理
 */
#pragma mark - WwUserInfoManagerDelegate
@protocol WwUserInfoManagerDelegate <NSObject>

- (void)onUserInfoManagerError:(UserInfoError)error;

@end


/**
 * WwUserInfoManager是用户个人信息管理对象，负责:
 * 1.用户信息获取与修改 
 * 2.游戏结果与游戏记录查询
 * 3.战利品查询
 * 4.娃娃列表查看与发货订单管理
 */
#pragma mark - WwUserInfoManager
@interface WwUserInfoManager : NSObject

@property (nonatomic, weak) id<WwUserInfoManagerDelegate> delegate; /**< 代理*/
@property (nonatomic, copy) UserInfo *(^userInfo)(void);            /**< 数据源*/
@property (nonatomic, strong) WwUser * myUserInfo;                  /**< 阿凡达服务器存的当前用户信息*/

/**
 * 获取WwUserInfoManager 单例
 */
+ (instancetype)UserInfoMgrInstance;

/**
 * 合作方，当用户从匿名，登陆之后，主动触发调用。
 */
- (void)loginWithComplete:(void (^)(int code, NSString *message))complete;

/**
 * 合作方，退出登录。
 */
- (void)logout;

/**
 * 请求当前登陆用户信息
 * @param complete 回调block
 */
- (void)requestMyUserInfoWithComplete:(void (^)(NSInteger code, NSString * msg,WwUser *user))complete;

/**
 * 请求用户信息
 * @param uid 要请求的用户uid, 注意, 这个uid不是接入方服务器分配的uid, 而是通过SDK接口获取的uid.
 * @param complete 回调block
 */
- (void)requestCommonUserInfoWithUid:(NSInteger)uid
                     completeHandler:(void (^)(NSInteger code, NSString * msg, WwUser *user))complete;

/**
 * 请求用户游戏记录
 * @param page 页数，从1开始
 * @param complete 回调block
 */
- (void)requestGameHistoryAtPage:(NSInteger)page
             complete:(void (^)(int code, NSString *message, NSArray<WwGameHistory *> *list))complete;


/**
 * 请求用户战利品列表
 * @param page 页数，从1开始
 * @param uid 看谁的战利品，传谁的uid.
 * @param complete 回调block
 */
- (void)requestUserWardrobeAtPage:(NSInteger)page
                           userId:(NSInteger)uid
                         complete:(void (^)(int code, NSString *message, WwWardrobe *trophy))complete;


/**
 * 请求我的娃娃列表
 * @param type 获取不同类型列表数据
 * @param complete 回调block
 */
- (void)requestMyWawaList:(WwWawaListType)type
          completeHandler:(void (^)(int code, NSString *message, WwUserWawaModel *model))complete;


/**
 * 请求发货
 * @param wawaIds 娃娃寄存项ID数组
 * @param complete 回调block
 */
- (void)requestCreateOrderWithWawaIds:(NSArray <NSString *> *)wawaIds
                              address:(WwAddress *)addressModel
                      completeHandler:(void (^)(int code, NSString *message))complete;


/**
 * 请求用户地址列表
 * @param complete 回调block
 */
- (void)requestMyAddressListWithComplete:(void (^)(int code, NSString *message, NSArray<WwAddress *> *list))complete;

/**
 * 新加入一个收货地址
 * @param address 联系人,电话,省,市,县/区,详细地址为必要参数
 * @param complete 请求结果回调
 */
- (void)requestAddAddress:(WwAddress *)address
      complete:(void (^)(int code, NSString *message))complete;

/**
 * 编辑修改一个收货地址,
 * @param address 需要修改的地址信息
 * @param complete 回调
 }];
 */
- (void)requestUpdateAddress:(WwAddress *)address
         complete:(void (^)(int code, NSString *message))complete;

/**
 * 设置已有一个地址为默认地址
 * @param aId 地址ID
 * @param completeHandle 回调
 */
- (void)requestSetDefaultAddress:(NSInteger)aId
                        complete:(void (^)(int code, NSString *message))completeHandle;


/**
 * 删除一个收货地址
 * @param aID address ID
 * @param complete 回调
 */
- (void)requestDeleteAddress:(NSInteger)aID
         complete:(void (^)(int code, NSString *message))complete;

#pragma mark - 物流查询
/**
 * 物流查询
 * @param orderId 订单ID
 */
- (void)requestExpressInfo:(NSString *)orderId
       complete:(void (^)(int code, NSString *message, WwExpressInfo *model))complete;

#pragma mark - 确认收货与物流接口
/**
 * 确认收货接口
 * @param orderId 订单ID
 */
- (void)requestConfirmReceived:(NSString *)orderId
           complete:(void (^)(int code, NSString *message))complete;


#pragma mark - 兑换我的娃娃

/**
 * 将娃娃兑换成金币
 * @param IDs 寄存中的娃娃ID数组, 可为空
 * @param orderIds 发货准备中的订单号数组, 可为空
 */
- (void)requestExchangeWawaWithDepositIds:(NSArray <NSString *>*)IDs
                               deliverIds:(NSArray <NSString *>*)orderIds
                                 complete:(void (^)(int code, NSString *message))complete;

/**
 * 请求积分商城列表
 */
- (void)requestMallListAtPage:(NSInteger)page
                    complete:(void(^)(NSInteger code,NSString * message,NSArray <WwMallWawaItem *>* arr))complete;


/**
 * 积分兑换娃娃
 * @param wid 兑换娃娃，id
 * @param complete 回调
 */
- (void)requestMallExchangeWithWWID:(NSInteger)wid
              complete:(void (^)(int code, NSString *message))complete;

#pragma mark - 申诉游戏
/*
 * 请求申诉原因接口
 */
- (void)requestComplainReasonListWith:(void(^)(NSInteger code, NSString * msg, NSArray <WwComplainReason *> * list))complete;

/**
 * 请求申述游戏
 * @param orderID 游戏订单号, 使用列表页请求到的订单信息
 * @param reasonID 原因ID, 请使用requestComplainReasonListWith接口请求到的ID, 自定义原因, ID传0
 * @param reason 原因, 不能为空
 */
- (void)requestComplainGame:(NSString *)orderID
                   reasonId:(NSInteger)reasonID
                     reason:(NSString *)reason
                   complete:(void(^)(NSInteger code, NSString * msg))complete;

/**
 * 游戏申诉状态
 * @param orderID 游戏编号
 * @param complete 回调 isComplain
 */
- (void)requestComplainResultWithOrderID:(NSString *)orderID
                     complete:(void (^)(int code, BOOL isComplain, NSString *message))complete;


#pragma mark - 用户举报
/**
 * 举报某个用户
 */
- (void)requestReportUser:(NSInteger)uid
                     type:(WwReportType)type
                 complete:(void(^)(NSInteger code, NSString * msg))complete;


@end


/**
 * 当前第三方用户信息
 */
#pragma mark - UserInfo
@interface UserInfo : NSObject

@property (nonatomic, copy) NSString *uid;      /**< 用户ID*/
@property (nonatomic, copy) NSString *name;     /**< 用户昵称*/
@property (nonatomic, copy) NSString *avatar;   /**< 用户头像*/

@end


