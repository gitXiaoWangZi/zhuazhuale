//
//  WwDataDef.h
//  WawaSDK
//
//  Copyright © 2017年 杭州阿凡达网络科技有限公司 All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WwCodeDef.h"

@class WwWawa;
@class WwUser;


/**
 * 游戏房间描述对象
 */
@interface WwRoom : NSObject

@property (nonatomic, assign) NSInteger ID;                     /**< 房间ID*/
@property (nonatomic, assign) NSInteger state;                  /**< 房间状态: 小于1:故障 1：补货 2:空闲 大于2:游戏中*/
@property (nonatomic, strong) WwWawa * wawa;                    /**< 玩具描述对象*/
@property (nonatomic, assign) NSInteger uid;                    /**< 在玩的人uid*/
@property (nonatomic, strong) WwUser * user;                    /**< 在玩的玩家*/
@property (nonatomic, strong) NSString * streamMaster;          /**< 正面摄像头流信息*/
@property (nonatomic, strong) NSString * streamSlave;           /**< 侧面摄像头流信息*/

//@property (nonatomic, strong) NSString * streamPlayer;          /**< 拉流地址*/
//@property (nonatomic, strong) NSString * stream;                /**< 推流地址*/

@end


/**
 * 玩家描述对象
 */
@interface WwUser : NSObject

@property (nonatomic, assign) NSInteger uid;                    /**< 用户ID*/
@property (nonatomic, assign) NSInteger gender;                 /**< 性别, 1男 0女*/
@property (nonatomic, strong) NSString * nickname;              /**< 昵称*/
@property (nonatomic, strong) NSString * portrait;              /**< 头像*/
@property (nonatomic, assign) NSInteger spoils;                 /**< 战利品个数*/

@end


/**
 * 娃娃玩具描述对象
 */
@interface WwWawa : NSObject

@property (nonatomic, assign) NSInteger ID;                     /**< 娃娃ID*/
@property (nonatomic, assign) NSInteger flag;                   /**< 按位与运算，0位标识是否新品娃娃，1位标识是否热门*/
@property (nonatomic, assign) NSInteger coin;                   /**< 所需金币*/
@property (nonatomic, strong) NSString * name;                  /**< 娃娃名称*/
@property (nonatomic, strong) NSString * icon;                  /**< 透明背景图*/
@property (nonatomic, strong) NSString * pic;                   /**< 不透明背景图*/
@property (nonatomic, strong) NSString * level;                    /**< 等级*/
@end

/**
 * 游戏结果
 */
@interface WwGameResult : NSObject

@property (nonatomic, assign) NSInteger ID;                     /**< id*/
@property (nonatomic, strong) NSString * dateline;              /**< 时间*/
@property (nonatomic, strong) NSString * orderId;               /**< 订单号*/
@property (nonatomic, assign) NSInteger uid;                    /**< 用户ID*/
@property (nonatomic, assign) NSInteger rid;                    /**< rid*/
@property (nonatomic, assign) NSInteger playTimes;              /**< 上机时间*/
@property (nonatomic, assign) NSInteger clawTimes;              /**< 游戏(摇爪操作)时间*/
@property (nonatomic, strong) NSString * video;                 /**< 游戏视频*/
@property (nonatomic, assign) NSInteger coin;                   /**< 话费多少金币*/
@property (nonatomic, assign) NSInteger awardFishball;          /**< 奖励积分*/
@property (nonatomic, assign) NSInteger state;                  /**< 状态, 0，1失败，2成功*/
@property (nonatomic, assign) NSInteger stage;                  /**< -1上机失败，1:上机中，2:摇杆中, 3:下抓中, 4:游戏结束, 5: 游戏申述*/
@property (nonatomic, assign) NSInteger wawaSuccess;            /**< 已有多少人抓住了娃娃*/
@property (nonatomic, strong) WwWawa * wawa;                    /**< 娃娃数据*/

@end


/**
 * 玩家地址信息描述对象
 */
@interface WwAddress : NSObject

@property (nonatomic, assign) NSInteger ID;                     /**< 地址ID*/
@property (nonatomic, strong) NSString * province;              /**< 省份*/
@property (nonatomic, strong) NSString * city;                  /**< 城市*/
@property (nonatomic, strong) NSString * district;              /**< 县,区*/
@property (nonatomic, strong) NSString * address;               /**< 详细地址*/
@property (nonatomic, strong) NSString * name;                  /**< 联系人*/
@property (nonatomic, strong) NSString * phone;                 /**< 手机*/
@property (nonatomic, assign) BOOL isDefault;                   /**< 是否默认地址*/

@end

@class WwReplayVideo;
@class WwGameRecordWawaItem;
/**
 * 游戏记录描述对象
 */
@interface WwGameHistory : NSObject

@property (nonatomic, strong) NSString * dateline;              /**< 游戏时间*/
@property (nonatomic, strong) NSString * orderId;               /**< 记录Id*/
@property (nonatomic, assign) NSInteger wawaId;                 /**< 娃娃ID*/
@property (nonatomic, assign) NSInteger status;                 /**< 状态 0:失败（游戏失败，如机器故障）; 1:未抓中; 2:抓中;*/
@property (nonatomic, strong) WwReplayVideo *video;             /**< 回放*/
@property (nonatomic, assign) NSInteger coin;                   /**< 消耗金币*/
@property (nonatomic, assign) NSInteger awardFishball;          /**< 奖励鱼丸*/
@property (nonatomic, strong) WwWawa *wawa;                     /**< 娃娃*/

@end

/**
 * 视频回放描述对象
 */
@interface WwReplayVideo : NSObject

@property (nonatomic, strong) NSString *machineStream;          /**< */
@property (nonatomic, strong) NSString *livekey;                /**< */
@property (nonatomic, assign) NSInteger startTime;              /**< 单位为秒，从1970-1-1 00:00:00开始*/
@property (nonatomic, assign) NSInteger duration;               /**< 单位为秒*/

@end


/**
 * 用户战利品详细信息
 */
@interface WwWardrobeItem : NSObject

@property (nonatomic, strong) NSString * dateline;
@property (nonatomic, strong) WwWawa * wawa;
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, assign) NSInteger wawaId;
@property (nonatomic, assign) NSInteger total;

@end

/*
 *
 */
@interface WwWardrobeLevel : NSObject

@property (nonatomic, assign) NSInteger level1;                 /**< 等级1的战利品数目*/
@property (nonatomic, assign) NSInteger level2;                 /**< 等级2的战利品数目*/
@property (nonatomic, assign) NSInteger level3;                 /**< 等级3的战利品数目*/
@property (nonatomic, assign) NSInteger level4;                 /**< 等级4的战利品数目*/
@property (nonatomic, assign) NSInteger level5;                 /**< 等级5的战利品数目*/
@property (nonatomic, assign) NSInteger spoils;                 /**< 战利品总数*/

@end

/*
 * 用户战利品
 */
@interface WwWardrobe : NSObject
@property (nonatomic, strong) WwWardrobeLevel * warTrophyHead;
@property (nonatomic, strong) NSArray<WwWardrobeItem *> *warTrophyInfo;

@end


/**
 * 积分商城商品信息
 */
@interface WwMallWawaItem : NSObject

@property (nonatomic, assign) NSInteger ID;                     /**< 货物ID*/
@property (nonatomic, strong) NSString * code;                  /**< 商品编号*/
@property (nonatomic, assign) NSInteger exchangeFishball;       /**< 兑换所需鱼丸*/
@property (nonatomic, assign) NSInteger flag;                   /**< 按位与运算，第3位标识是否热门，eg: flag&(1<<2) */
@property (nonatomic, strong) NSString * name;                  /**< 货物名称*/
@property (nonatomic, strong) NSString * pic;                   /**< 图片*/

@end


/**
 * 娃娃寄存对象
 */
@interface WwDepositItem : NSObject

@property (nonatomic, assign) NSInteger ID;                     /**< 记录ID*/
@property (nonatomic, assign) NSInteger wid;                    /**< 娃娃ID*/
@property (nonatomic, assign) NSInteger expTime;                /**< 寄存剩余天数*/
@property (nonatomic, strong) NSString * name;                  /**< 娃娃名称*/
@property (nonatomic, assign) NSInteger coin;                   /**< 价值*/
@property (nonatomic, strong) NSString * pic;                   /**< 图片*/
@property (nonatomic, assign) BOOL selected;                    /**< 标记选中*/

@end

/**
 * 娃娃发货订单条目
 */
@interface WwOrderItem : NSObject

@property (nonatomic, assign) NSInteger wid;                    /**< 娃娃id*/
@property (nonatomic, strong) NSString * name;                  /**< 娃娃名称*/
@property (nonatomic, strong) NSString * pic;                   /**< 娃娃图片*/
@property (nonatomic, assign) NSInteger coin;                   /**< 价值*/
@property (nonatomic, assign) NSInteger num;                    /**< 娃娃数量*/
@property (nonatomic, assign) BOOL selected;                    /**< 标记选中*/

@end


/**
 * 娃娃发货订单
 */
@interface WwOrderModel : NSObject

@property (nonatomic, strong) NSString * orderId;               /**< 订单id*/
@property (nonatomic, assign) NSInteger status;                 /**< 快递状态，0发货准备中；1运送中；2已收货 */
@property (nonatomic, strong) NSString * dateline;              /**< 申请发货时间*/
@property (nonatomic, strong) NSMutableArray <WwOrderItem *> *records; /**< 订单具体条目*/
@property (nonatomic, assign) BOOL selected;                    /**< 标记选中*/

@end

/**
 * 用户抓到娃娃与发货订单数据对象
 */
#pragma mark - WwUserWawaModel
@interface WwUserWawaModel : NSObject

@property (nonatomic, strong) NSMutableArray <WwOrderModel *> *expressList;         /**< 已发货*/
@property (nonatomic, strong) NSMutableArray <WwOrderModel *> *exchangeList;        /**< 已兑换*/
@property (nonatomic, strong) NSMutableArray <WwDepositItem *> *depositList;        /**< 寄存中*/
@property (nonatomic, assign) NSInteger expressTotalCount;      /**< 已发货总数*/
@property (nonatomic, assign) NSInteger exchangeTotalCount;     /**< 已兑换总数*/
@property (nonatomic, assign) NSInteger depositTotalCount;      /**< 寄存中总数*/

@end

/**
 房间内娃娃详细资料
 */
@interface WwWaWaDetail : NSObject

@property (nonatomic, assign) NSInteger ID;                     /**< 娃娃id*/
@property (nonatomic, strong) NSString * name;                  /**< 名称*/
@property (nonatomic, strong) NSString * size;                  /**< 尺寸*/
@property (nonatomic, assign) NSInteger coin;                   /**< 单次抓娃娃消耗金币*/
@property (nonatomic, assign) NSInteger recoverCoin;            /**< 可兑换金币数量*/
@property (nonatomic, strong) NSString * brand;                 /**< 品牌*/
@property (nonatomic, strong) NSString * suitAge;               /**< 适用年龄*/
@property (nonatomic, strong) NSString * detailPics;            /**< 娃娃详情图片,按逗号分开*/
@property (nonatomic, strong) NSString * filler;                /**< 填充物*/
@property (nonatomic, strong) NSString * material;              /**< 面料*/
@property (nonatomic, assign) NSInteger level;                  /**< 等级*/
@property (nonatomic, strong) NSString * icon;                  /**< 透明背景图*/
@property (nonatomic, strong) NSString * pic;                   /**< 不透明背景图*/

@end


/**
 * 房间内最近抓中游戏记录
 */
@interface WwRoomCatchRecordItem : NSObject

@property (nonatomic, strong) NSString * dateline;              /**< 抓中时间*/
@property (nonatomic, strong) NSString * orderId;               /**< 游戏编号*/
@property (nonatomic, strong) WwReplayVideo * video;            /**< 回放数据*/
@property (nonatomic, assign) NSInteger wawaId;                 /**< 娃娃ID*/
@property (nonatomic, strong) WwUser * user;                    /**< 抓中的人*/

@end


/*
 * 物流详情
 */
@class WwExpressItem;
@interface WwExpressInfo : NSObject

@property (nonatomic, strong) NSString * number;                /**< 单号*/
@property (nonatomic, strong) NSString * type;                  /**< 快递类型*/
@property (nonatomic, strong) NSString * company;               /**< 快递公司名称*/
@property (nonatomic, assign) NSInteger deliverystatus;         /**< 1.在途中 2. 派送中 3. 已签收 4. 派送失败或者拒收*/
@property (nonatomic, assign) NSInteger issign;                 /**< */
@property (nonatomic, strong) NSArray<WwExpressItem *> * list;  /**< 物流跟踪信息*/
@property (nonatomic, strong) WwWawa * wawa;                    /**< 娃娃信息*/
@property (nonatomic, assign) NSInteger wawaNum;                /**< 娃娃数量*/
@property (nonatomic, strong) NSString * tel;                   /**< 官方电话号码*/

- (NSString *)deliverDescription;

@end


/*
 * 物流追踪信息
 */
@interface WwExpressItem : NSObject

@property (nonatomic, strong) NSString * status;
@property (nonatomic, strong) NSString * time;

//mock
@property (nonatomic, assign) BOOL isFirst;                     /**< 是不是第一个list数据 mock*/
@property (nonatomic, assign) BOOL isLast;                      /**< 是不是最后一个list数据 mock*/

@end

/*
 * 游戏申诉原因
 */
@interface WwComplainReason : NSObject

@property (nonatomic, assign) NSInteger ID;                     /**< 原因ID*/
@property (nonatomic, strong) NSString * reason;                /**< 原因*/

@end

@interface WwComplainResult : NSObject

@property (nonatomic, assign) WwComplainResultType state;       /**< 申诉状态*/

@end


#pragma mark - SocketModel
/**
 * 聊天
 */
@interface WwChatMessage : NSObject

@property (nonatomic, strong) WwUser * fromUser;                /**< 发言者*/
@property (nonatomic, strong) NSString * content;               /**< 发言内容*/
@property (nonatomic, strong) NSArray <WwUser *> * mentions;    /**< @的用户*/

@end

/*
 * 房间基本信息
 */
@interface WwRoomUpdateMessage : NSObject

@property (nonatomic, assign) NSInteger online;                 /**< 在线人数*/

@end


/**
 * 房间游戏状态更新
 */
@interface WwRoomDataMessage : NSObject

@property(nonatomic, strong) WwUser * user;                     /**< 玩家，没人玩 nil*/
@property(nonatomic, assign) NSInteger state;                   /** -100:机器回收, -1:机器下架, 0:机器故障,  1:补货中，2: 空闲, 3:开始游戏, 4: 移动中, 5:下抓(等待结果), 6: 等待重新上机 */
@property(nonatomic, strong) NSString * streamPlayer;           /** 上机者流地址(暂未提供游戏者推流)*/

@end


/**
 * 娃娃抓取结果通知
 */
@interface WwClawResultMessage : NSObject

@property(nonatomic, strong) WwUser * user;                     /** 用户 */
@property(nonatomic, assign) NSInteger status;                  /** 1:未抓中; 2:抓中; */

@end

/**
 * 全局通知
 */
@interface WwGlobalMessage: NSObject
@property(nonatomic, strong) NSString * content;                /** 文本消息内容 */
@end


