//
//  OctopusSDK.h
//  OctopusSDKIntegrateSDK
//
//  Created by Jany on 16/6/17.
//  Copyright © 2016年 ZY. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ZYGameDelegate.h"

#define DEPRECATED(_version) __attribute__((deprecated))
/**
 * 此类为对外暴露的api接口
 *
 */
@interface OctopusSDK : NSObject



/**
 *  AppDelegate中初始化
 *
 *  @return AppDelegate代理对象
 */
+ (instancetype)initSDK;

/**
 *  viewdidload初始化SDK
 *
 *  @param delegate 初始化结束后的回调代理 没有则传nil
 */
+ (void)initGame:(id<ZYGameInitDelegate>)delegate;

/**
 *  添加登录和登出的代理设置 解决自动登录代理丢失问题
 *
 *  @param loginDelegate 登录时候的回调代理
 *  @param logoutDelegate 登录时候的回调代理
 */
+ (void)addLoginDelegate:(id<ZYGameLoginDelegate>)loginDelegate logoutDelegate:(id<ZYGameLogoutDelegate>)logoutDelegate;

/**
 *  登录接口
 *
 *  @param exinfo        额外信息
 *  @param loginDelegate 登录结束后回调代理 不需要回调传nil
 */
+ (void)login:(NSString *)exinfo loginDelegate:(id<ZYGameLoginDelegate>)loginDelegate DEPRECATED(2.0);
+ (void)login:(NSString *)exinfo;

/**
 *  切换账号接口
 *
 *  @param logoutDelegate  退出的回调
 *  @param loginDelegate 切换后的登录回调
 */
+ (void)switchAccount:(id<ZYGameLogoutDelegate>)logoutDelegate loginDelegate:(id<ZYGameLoginDelegate>)loginDelegate DEPRECATED(2.0);
+ (void)switchAccount:(id<ZYGameLogoutDelegate>)logoutDelegate;



/**
 *  监听切换账号
 *
 *  @param switchDelegate 监听代理
 */
+ (void)switchListener:(id<ZYGameSwitchDelegate>)switchDelegate;

/**
 *  游戏角色已经进入游戏后，调用该方法，必须实现绑定区服
 *
 *  @param dict 该方法中相关信息的dictionary，其内应为以下key和值:
 ZYSDKRoleName:游戏角色名称(必需)
 ZYSDKRoleLevel:游戏角色等级(必需)
 ZYSDKRoleZoneId:角色区服ID(必需)
 ZYSDKRoleId:游戏角色ID(必需)
 ZYSDKVipLevel:角色VIP等级(必需)
 ZYSDKThirdGameZoneId:游戏区服Id(必需)
 ZYSDKThirdGameZoneName:游戏区服名称(必需)
 ZYSDKGuildName:公会名称(必需)
 ZYSDKSubmitType:提交类型 (必需)// 1: 进入游戏   2: 创建角色    3: 角色升级
 */
+ (void)submitEntergame:(NSDictionary *)dict;

/**
 *  注销退出
 *
 *  @param logoutDelegate 退出程序回调,在渠道SDK销毁时回调
 */
+ (void)logout:(id<ZYGameLogoutDelegate>)logoutDelegate;

/**
 *  支付接口 根据服务器配置决定使用app支付还是web支付
 *
 *  @param dict        该方法中相关信息的dictionary，其内应为以下key和值:
 ZYSDKOrderId:游戏服务器订单Id         (必需)
 ZYSDKProductId:商品Id               (必需)
 ZYSDKMoney:金额                     (必需)
 ZYSDKProductName:商品名称            (必需)
 ZYSDKServerId:游戏区服ID             (必需)
 ZYSDKRoleId:角色ID                  (必需)
 ZYSDKRoleName:角色名字               (必需)
 ZYSDKRoleLevel:角色等级              (必需)
 ZYSDKNotifyUrl:回调地址              (必需)
 ZYSDKProductDesc:商品描述 (可选)
 ZYSDKoExInfo:订单额外信息(可选)
 ZYSDKServerName:服务器名称 (可选)
 ZYSDKCount:购买数量(可选)
 ZYSDKGameName:游戏名称(可选)
 
 *  @param payDelegate 支付完成后的回调
 */
+ (void)shopping:(NSDictionary *)dict payDelegate:(id<ZYGamePayDelegate>)payDelegate;


////获取测试订单号
//+ (NSString *)getOrderID:(NSDictionary *)dict;

/**
 *  控制悬浮按钮开关
 *
 *  @param isVisible 是否可见
 */
+ (void)setHoverButtonVisible:(BOOL)isVisible;


///**
// *  分享接口
// *
// *  @param params        ZYShareParams对象,需要设定其中值
// *  @param shareDelegate 分享回调,在分享结束后调用
// */
//+ (void)share:(ZYShareParams *)params shareDelegate:(id<ZYGameShareDelegate>)shareDelegate;
//
///**
// *  点赞
// *
// *  @param params         点赞需要的参数
// *  @param pariseDelegate 点赞回调,在点赞结束后调用
// */
//+ (void)parise:(ZYPariseParams *)params pariseDelegate:(id<ZYGamePariseDelegate>)pariseDelegate;
//
///**
// *  邀请好友
// *
// *  @param params         ZYInviteParams对象,需设定其中值
// *  @param inviteDelegate 邀请好友回调,在邀请好友结束后回调
// */
//+ (void)invite:(ZYInviteParams *)params inviteDelegate:(id<ZYGameInviteDelegate>)inviteDelegate;

/**
 *  是否登录
 *
 *  @return YES:已登录 NO:未登录
 */
//+ (BOOL)isLogin;

/**
 *  是否为游客登录登录状态
 *
 *  @return YES:游客登录 NO:不是游客登录
 */
+ (BOOL)isGuestLogined;

///**
// *  得到当前用户信息
// *
// *  @return 当前用户信息
// */
//+ (instancetype)getUserInfo;

/**
 *  进入用户中心
 */
+ (void)goUserCenter;

/**
 *  游客转正:弹出游客转正注册界面
 *
 *  @param flag 预留参数
 *
 *  @return 默认返回0 返回1表示当前不是游客账户或者没有登录 不弹出游客注册页面
 */
+ (int)guestRegister:(int)flag;


/**
 防沉迷
 
 @param antiAddictionDelegate 代理
 */
+ (void)addAntiAddictionDelegate:(id<ZYGameAntiAddictionDelegate>)antiAddictionDelegate;



@end
