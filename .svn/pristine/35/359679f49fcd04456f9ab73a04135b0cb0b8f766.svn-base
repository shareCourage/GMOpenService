//
//  AppDelegate.m
//  New_Simplify
//
//  Created by Kowloon on 15/7/7.
//  Copyright (c) 2015年 Goome. All rights reserved.
//
#define GM_Appid @"23"
#import "AppDelegate.h"
#import "PHLoginController.h"
#import <BaiduMapAPI/BMapKit.h>
#import "GMOpenKit.h"
@interface AppDelegate ()<BMKGeneralDelegate>
{
    BMKMapManager * _bmkManager;
}
@property(nonatomic, strong)PHLoginController *loginVC;

@end

@implementation AppDelegate
/**
 *  百度的密钥验证
 */
- (void)validateTheBMKKey
{
    _bmkManager = [[BMKMapManager alloc] init];
    BOOL flag = [_bmkManager start:PH_BaiduMap_AppKey generalDelegate:self];
    if (flag) {
        PHLog(@"bmk->success");
    }
    else
    {
        PHLog(@"bmk->fail");
    }
}
- (void)validateTheGMAppid
{
    GMOpenManager *open = [GMOpenManager manager];
    [open validateWithKey:GM_Appid completionBlock:^(GMOpenPermissionStatus status) {
        if (status == GMOpenPermissionStatusOfSuccess) PHLog(@"appid validate success");
    }];
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self validateTheBMKKey];//验证百度地图是否正确
    [self validateTheGMAppid];
    if (PH_iOS(8.0)) {
        [GMPushManager iOS8RegisterForRemoteNotificationTypes:(UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound) categories:nil];
    }
    else {
        [GMPushManager iOS7RegisterForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    }
    [GMPushManager setupWithOption:launchOptions];
    
    if (!PH_BoolForKey(PH_LoginSuccess)) {
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [self.window makeKeyAndVisible];
        PHLoginController *login = [[PHLoginController alloc] init];
        self.loginVC = login;
        self.window.rootViewController = login;
    }
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    PHLog(@"deviceToken ->%@",deviceToken);
    [GMPushManager registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    PHLog(@"failToRegister -> %@",error);
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    PHLog(@"~~~~~~~~~~~~~~~~~~~~~~~~~~didReceiveRemoteNotification~~~~~~~~~~~~~~~~~~~~~~~~~->\n%@",userInfo);
}
#pragma mark - BMKGeneralDelegate
/**
 *返回网络错误
 *@param iError 错误号  222221121122
 */
- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        PHLog(@"联网成功");
    }
    else{
        PHLog(@"onGetNetworkState %d",iError);
    }
}

/**
 *返回授权验证错误
 *@param iError 错误号 : 为0时验证通过，具体参加BMKPermissionCheckResultCode
 */
- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        PHLog(@"授权成功");
    }
    else {
        PHLog(@"onGetPermissionState %d",iError);
    }
}









@end










