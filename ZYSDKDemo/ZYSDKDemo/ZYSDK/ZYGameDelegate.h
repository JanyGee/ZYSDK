//
//  ZYGameDelegate.h
//  OctopusIntegrateSDK
//
//  Created by Jany on 16/7/16.
//  Copyright © 2016年 ZY. All rights reserved.
//
#import <UIKit/UIApplication.h>

@protocol ZYGameLoginDelegate <NSObject>
@optional
/**
 *  游戏登录成功代理
 *
 *  @param result 返回参数模型:
 advChannel:渠道号
 channelName:渠道名称
 subChannel:子渠道
 appId:appId
 sdkVersion:sdk版本
 operatorOs:操作系统
 deviceNo:设备号(IDFV)
 device:设备号(IDFA)
 thirdId:thirdAppId
 userId:用户Id
 token:token
 extension:扩展字段
 */
- (void)loginSuccess:(NSDictionary *)result;
/**
 *  游戏登录失败代理
 */
- (void)loginFail;


@end

@protocol ZYLoginDelegate <NSObject>
@optional
/**
 *  渠道sdk登录成功代理
 *
 *  @param result 返回参数模型
 */
- (void)sdkLoginSuccess:(NSDictionary *)result;
/**
 *  渠道登录失败代理
 */
- (void)sdkLoginFail;

@end

@protocol ZYGamePayDelegate <NSObject>
@optional
/**
 *  支付成功
 */
- (void)gamePaySuccess;
/**
 *  支付失败
 */
- (void)gamePayFail;
/**
 *  支付取消
 */
- (void)gamePayCancel;
/**
 *  返回订单号
 */
- (void)gamePayOrder:(NSString *)orderID;

@end

@protocol ZYGameSwitchDelegate <NSObject>

/**
 *  1.注销游戏角色 2.返回登录界面 3.同时弹出登录窗口
 */
- (void)doSwitch;

@end

@protocol ZYGameLogoutDelegate <NSObject>
@optional
/**
 *  注销成功
 */
- (void)logoutSuccess;
/**
 *  注销失败
 *
 *  @param reason 失败原因
 */
- (void)logoutFail:(NSString *)reason;
/**
 *  取消注销
 */
- (void)logoutCancel;

@end

/**
 *  订单查询代理
 */
@protocol ZYGameCheckDelegate <NSObject>

typedef enum{
    
    ZYPayCheckStatusReady       = 0,    /* 待支付（已经创建第三方充值订单，但未支付）*/
    
    ZYPayCheckStatusSuccess     = 1,    /* 成功 */
    
    ZYPayCheckStatusExpired     = 2,    /* 过期失效 */
    
    ZYPayCheckStatusNotExist    = 3,    /* 订单不存在（或未完成支付流程） */
    
    ZYPayCheckStatusFail        = 4,    /* 支付失败 */
    
    ZYPayCheckStatusPaying      = 5,    /* 充值中（用户支付成功，正在通知开发者服务器，未收到处理结果） */
    
}ZYPayCheckStatus;

@optional

/**
 *  查询成功回调
 *
 *  @param params NSDictionary:
 ZYOrderId:订单ID
 ZYMoney:订单金额
 ZYStatus:订单状态ZYPayCheckStatus枚举类型
 
 */
- (void)checkSuccess:(NSDictionary *)params;

- (void)checkFail:(NSString *)orderId;

@end

/**
 *  游戏加载完成后调用插件初始化的回调
 */
@protocol ZYGameInitDelegate <NSObject>

@optional

- (void)initSuccess;

- (void)initFail;

@end

/**
 *  游戏防沉迷回调
 */
@protocol ZYGameAntiAddictionDelegate <NSObject>

@optional

//实名制了而且已经成年，正常游戏娱乐
- (void)onVerifiedSuccess;
//实名了但未成年以及未实名制但还允许游戏时都需要通知游戏做相应的防沉迷提醒机制
- (void)doAntiAddiction;
//未实名且不允许该类用户体验游戏，需游戏方处理退出游戏操作
- (void)onFail;

@end

#pragma mark - ---Appdelegate协议---
@protocol ZYPluginProtocol <NSObject>
@required
- (instancetype)initWithParams:(NSDictionary *)params;
@optional
- (BOOL) isInitCompleted;
- (void)setupWithParams:(NSDictionary *)params;

// UIApplicationDelegate事件
//当用户通过其它应用启动本应用的时,会调用这个方法
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options;
//同上
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url;
//当应用程序启动时(不包括已在后台的情况下转到前台),调用此回调.
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

//当应用从活动状态主动到非活动状态的应用程序时会调用这个方法。
- (void)applicationWillResignActive:(UIApplication *)application;
//当用户从台前状态转入后台时，调用此方法。
- (void)applicationDidEnterBackground:(UIApplication *)application;
//当应用在后台状态，将要进行动前台运行状态时，会调用此方法。
- (void)applicationWillEnterForeground:(UIApplication *)application;
//当应用程序全新启动，或者在后台转到前台，完全激活时，都会调用这个方法。
- (void)applicationDidBecomeActive:(UIApplication *)application;
//当应用退出，并且进程即将结束时会调到这个方法
- (void)applicationWillTerminate:(UIApplication *)application;

//客户端注册远程通知时,会调用下面两个方法
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;

//当应用收到本地通知时会调用这个方法,下面两个方法类似.
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification;
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo;

//屏幕旋转
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window;

@end


