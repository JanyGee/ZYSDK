//
//  AppDelegate.m
//  ZYSDKDemo
//
//  Created by zhangyu on 2019/4/11.
//  Copyright © 2019年 zhangyu. All rights reserved.
//

#import "AppDelegate.h"
#import "OctopusSDK.h"
#import "ViewController.h"

@interface AppDelegate ()
/** AppDelegate代理对象 */
@property (nonatomic, strong) id<ZYPluginProtocol> pluginDelegate;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //必须初始化sdk的代理对象,并且在初始化中间层之前调用
    [[ViewController shareInstance] initSDKDelegate];
    //初始化聚合sdk
    id pluginDelegate = [OctopusSDK initSDK];
    if (pluginDelegate && [pluginDelegate conformsToProtocol:@protocol(ZYPluginProtocol)]) {
        _pluginDelegate = pluginDelegate;
    }
    
    
    if (_pluginDelegate && [_pluginDelegate respondsToSelector:@selector(application:didFinishLaunchingWithOptions:)]) {
        return [_pluginDelegate application:application didFinishLaunchingWithOptions:launchOptions];
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    if (_pluginDelegate && [_pluginDelegate respondsToSelector:@selector(applicationWillResignActive:)]) {
        [_pluginDelegate applicationWillResignActive:application];
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    if (_pluginDelegate && [_pluginDelegate respondsToSelector:@selector(applicationDidEnterBackground:)]) {
        [_pluginDelegate applicationDidEnterBackground:application];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    if (_pluginDelegate && [_pluginDelegate respondsToSelector:@selector(applicationWillEnterForeground:)]) {
        [_pluginDelegate applicationWillEnterForeground:application];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if (_pluginDelegate && [_pluginDelegate respondsToSelector:@selector(applicationDidBecomeActive:)]) {
        [_pluginDelegate applicationDidBecomeActive:application];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    if (_pluginDelegate && [_pluginDelegate respondsToSelector:@selector(applicationWillTerminate:)]) {
        [_pluginDelegate applicationWillTerminate:application];
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    if (_pluginDelegate && [_pluginDelegate respondsToSelector:@selector(application:openURL:sourceApplication:annotation:)]) {
        return [_pluginDelegate application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    if (_pluginDelegate && [_pluginDelegate respondsToSelector:@selector(application:openURL:options:)]) {
        return [_pluginDelegate application:application openURL:url options:options];
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(nonnull NSURL *)url{
    
    if (_pluginDelegate && [_pluginDelegate respondsToSelector:@selector(application:handleOpenURL:)]) {
        return [_pluginDelegate application:application handleOpenURL:url];
    }
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    if (_pluginDelegate && [_pluginDelegate respondsToSelector:@selector(application:didRegisterForRemoteNotificationsWithDeviceToken:)]) {
        [_pluginDelegate application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
    }
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    if (_pluginDelegate && [_pluginDelegate respondsToSelector:@selector(application:didFailToRegisterForRemoteNotificationsWithError:)]) {
        [_pluginDelegate application:application didFailToRegisterForRemoteNotificationsWithError:error];
    }
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    if (_pluginDelegate && [_pluginDelegate respondsToSelector:@selector(application:didReceiveLocalNotification:)]) {
        [_pluginDelegate application:application didReceiveLocalNotification:notification];
    }
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    if (_pluginDelegate && [_pluginDelegate respondsToSelector:@selector(application:didReceiveRemoteNotification:)]) {
        [_pluginDelegate application:application didReceiveRemoteNotification:userInfo];
    }
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if (_pluginDelegate && [_pluginDelegate respondsToSelector:@selector(application:supportedInterfaceOrientationsForWindow:)]) {
        [_pluginDelegate application:application supportedInterfaceOrientationsForWindow:window];
    }
    
    
    
    return UIInterfaceOrientationMaskAll;
}


@end
