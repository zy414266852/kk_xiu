//
//  AppDelegate.m
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/8/8.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import "AppDelegate.h"
#import "YYTabBarController.h"
#import "CcUserModel.h"
#import "LIMLoginViewController.h"
#import "YYNavigationController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
#import "WXApi.h"
//新浪微博SDK头文件
#import "WeiboSDK.h"

#import "XGPush.h"
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate ()<XGPushDelegate,XGPushTokenManagerDelegate>
    @property (nonatomic, strong) YYTabBarController *limTabBar;
    @end

@implementation AppDelegate
    
    
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // 推送
    [[XGPush defaultManager] setEnableDebug:YES];
    
    // 不同推送的点击事件
    XGNotificationAction *action1 = [XGNotificationAction actionWithIdentifier:@"xgaction001" title:@"xgAction1" options:XGNotificationActionOptionNone];
    XGNotificationAction *action2 = [XGNotificationAction actionWithIdentifier:@"xgaction002" title:@"xgAction2" options:XGNotificationActionOptionDestructive];
    XGNotificationCategory *category = [XGNotificationCategory categoryWithIdentifier:@"xgCategory" actions:@[action1, action2] intentIdentifiers:@[] options:XGNotificationCategoryOptionNone];
    XGNotificationConfigure *configure = [XGNotificationConfigure configureNotificationWithCategories:[NSSet setWithObject:category] types:XGUserNotificationTypeAlert|XGUserNotificationTypeBadge|XGUserNotificationTypeSound];
    [[XGPush defaultManager] setNotificationConfigure:configure];
    
    // 配置 appid  appkey
    [[XGPush defaultManager] startXGWithAppID:2200275430 appKey:@"IL4P898NX9XP" delegate:self];
    [[XGPush defaultManager] setXgApplicationBadgeNumber:0];
    [[XGPush defaultManager] reportXGNotificationInfo:launchOptions];
    [[XGPush defaultManager] setEnableDebug:YES];
    
    
//    [XGPush setAccount:@"myAccount" successCallback:^{
//        NSLog(@"[XGDemo] Set account success");
//    } errorCallback:^{
//        NSLog(@"[XGDemo] Set account error");
//    }];
    
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    CcUserModel *userModel = [CcUserModel defaultClient];
    [userModel setUserModelInfo];
    
    NSLog(@"%@/n%@",userModel.timid,userModel.timsig);

    if (userModel.uid) {      // 账户已登录
        //初始化一个tabBar控制器
        YYTabBarController *tabbarVC = [[YYTabBarController alloc]init];
        tabbarVC.tabBar.translucent = NO;
        self.window.rootViewController = tabbarVC;
        self.limTabBar = tabbarVC;
    }else{                  // 账户未登陆
        LIMLoginViewController *logInVC = [[LIMLoginViewController alloc]init];
        YYNavigationController *navigationVc = [[YYNavigationController alloc] initWithRootViewController:logInVC];
        self.window.rootViewController = navigationVc;
    }

    

//    [WXApi registerApp:@"wxb0f624469fee1d6c"];
    
    
    [ShareSDK registerActivePlatforms:@[
//                                       @(SSDKPlatformTypeSinaWeibo),
                                       @(SSDKPlatformTypeWechat),
                                       @(SSDKPlatformTypeQQ),
                                       ]
onImport:^(SSDKPlatformType platformType)
    {
        switch (platformType)
        {
            case SSDKPlatformTypeWechat:
                [ShareSDKConnector connectWeChat:[WXApi class]];
                break;
            case SSDKPlatformTypeQQ:
                [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                break;
//            case SSDKPlatformTypeSinaWeibo:
//                [ShareSDKConnector connectWeibo:[WeiboSDK class]];
//                break;
            default:
                break;
        }
    }
onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
    {
        switch (platformType)
        {
//            case SSDKPlatformTypeSinaWeibo:
//                //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
//                [appInfo SSDKSetupSinaWeiboByAppKey:@"568898243"
//                                          appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
//                                        redirectUri:@"http://www.sharesdk.cn"
//                                           authType:SSDKAuthTypeBoth];
//                break;
            case SSDKPlatformTypeWechat:
                [appInfo SSDKSetupWeChatByAppId:@"wxb0f624469fee1d6c"
                                      appSecret:@"6597ce1f0869bfb3e4510b3aee9284d7"];
                break;
            case SSDKPlatformTypeQQ:
                [appInfo SSDKSetupQQByAppId:@"1106254217"
                                     appKey:@"KEY5WT5GQFQHDevdnoP"
                                   authType:SSDKAuthTypeSSO];
                break;
       
                default:
                  break;
                  }
                  }];
    

    
    [self.window makeKeyAndVisible];
    
    
    

    
    // Override point for customization after application launch.
    return YES;
}


    
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}
    
    
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"deviceToken=%@",deviceToken);
    
//    NSString *deviceTokenStr = [XGPush registerDevice:deviceToken
//                                              account:nil
//                                      successCallback:^{
//                                          NSLog(@"[XGPush Demo] register push success");
//                                      } errorCallback:^{
//                                          NSLog(@"[XGPush Demo] register push error");
//                                      }];
//    NSLog(@"[XGPush Demo] device token is %@", deviceTokenStr);
}

#pragma mark - XGPushDelegate
- (void)xgPushDidFinishStart:(BOOL)isSuccess error:(NSError *)error {
    NSLog(@"%s, result %@, error %@", __FUNCTION__, isSuccess?@"OK":@"NO", error);
//    UIViewController *ctr = [self.window rootViewController];
//    if ([ctr isKindOfClass:[UINavigationController class]]) {
//        ViewController *viewCtr = (ViewController *)[(UINavigationController *)ctr topViewController];
//        [viewCtr updateNotification:[NSString stringWithFormat:@"%@%@", @"启动信鸽服务", (isSuccess?@"成功":@"失败")]];
//    }
}

- (void)xgPushDidFinishStop:(BOOL)isSuccess error:(NSError *)error {
//    UIViewController *ctr = [self.window rootViewController];
//    if ([ctr isKindOfClass:[UINavigationController class]]) {
//        ViewController *viewCtr = (ViewController *)[(UINavigationController *)ctr topViewController];
//        [viewCtr updateNotification:[NSString stringWithFormat:@"%@%@", @"注销信鸽服务", (isSuccess?@"成功":@"失败")]];
//    }
    
}
/**
 收到通知的回调
 @param application  UIApplication 实例
 @param userInfo 推送时指定的参数
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"[XGDemo] receive Notification,%@",userInfo);
    [[XGPush defaultManager] reportXGNotificationInfo:userInfo];
}


/**
 收到静默推送的回调
 
 @param application  UIApplication 实例
 @param userInfo 推送时指定的参数
 @param completionHandler 完成回调
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"[XGDemo] receive slient Notification");
    NSLog(@"[XGDemo] userinfo %@", userInfo);
    [[XGPush defaultManager] reportXGNotificationInfo:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

// iOS 10 新增 API
// iOS 10 会走新 API, iOS 10 以前会走到老 API
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
// App 用户点击通知
// App 用户选择通知中的行为
// App 用户在通知中心清除消息
// 无论本地推送还是远程推送都会走这个回调
- (void)xgPushUserNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    NSLog(@"[XGDemo] click notification");
    if ([response.actionIdentifier isEqualToString:@"xgaction001"]) {
        NSLog(@"click from Action1");
    } else if ([response.actionIdentifier isEqualToString:@"xgaction002"]) {
        NSLog(@"click from Action2");
    }
    [[XGPush defaultManager] reportXGNotificationResponse:response];
    
    completionHandler();
}

// App 在前台弹通知需要调用这个接口
- (void)xgPushUserNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    [[XGPush defaultManager] reportXGNotificationInfo:notification.request.content.userInfo];
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}
#endif

@end
