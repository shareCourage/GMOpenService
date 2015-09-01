//
//  AppDelegate.m
//  New_Simplify
//
//  Created by Kowloon on 15/7/7.
//  Copyright (c) 2015年 Goome. All rights reserved.
//
#define GM_Appid [PH_UserDefaults objectForKey:PH_UniqueAppid]
#import "AppDelegate.h"
#import "PHLoginController.h"
#import <BaiduMapAPI/BMapKit.h>
#import "GMOpenKit.h"
#import "PHNavigationController.h"

@interface AppDelegate ()<BMKGeneralDelegate>
{
    BMKMapManager * _bmkManager;
}

@end

@implementation AppDelegate
/**
 *  百度的密钥验证
 */
- (void)validateTheBMKKey
{
    _bmkManager = [[BMKMapManager alloc] init];
    BOOL flag = [_bmkManager start:PH_BaiduMap_AppKey generalDelegate:self];
    flag ? PHLog(@"bmk->success") : PHLog(@"bmk->fail");
}
- (void)validateTheGMAppid
{
    GMOpenManager *open = [GMOpenManager manager];
    NSString *appid = GM_Appid;
    [open validateWithKey:appid completionBlock:^(GMOpenPermissionStatus status) {
        status == GMOpenPermissionStatusOfSuccess ? PHLog(@"appid validate success") : PHLog(@"appid validate failure");
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
        [PHTool loginViewControllerImplementation];
    }
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    PHLog(@"deviceToken ->%@",deviceToken);
    [GMPushManager registerDeviceToken:deviceToken];
    [PH_UserDefaults setObject:deviceToken forKey:PH_UniqueDevicetoken];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    PHLog(@"failToRegister -> %@",error);
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [GMPushManager handleRemoteNotification:userInfo];

    PHLog(@"~~~~~~~~~~~~~~~~~~~~~~~~~~didReceiveRemoteNotification~~~~~~~~~~~~~~~~~~~~~~~~~->\n%@",userInfo);
    if (userInfo) {
        NSString *alarm = userInfo[@"alarm"];
        NSArray *arraySep = [NSArray seprateString:alarm characterSet:@","];
        NSString *deviceId = [arraySep firstObject];
        NSString *status = arraySep[1];
        NSString *fenceId = [[arraySep lastObject] stringByAppendingString:@" 围栏"];
        NSString *fenceName = [self getFenceNameFromUserInfo:userInfo];
        NSString *information = [NSString stringWithFormat:@"设备%@%@ %@",deviceId, [status isEqualToString:@"1"] ? @"进入" : @"离开", fenceName == nil ? fenceId : [fenceName stringByAppendingString:@" 围栏"]];
        [MBProgressHUD showSuccess:information];

    }
}
- (NSString *)getFenceNameFromUserInfo:(NSDictionary *)userInfo
{
    NSDictionary *aps = userInfo[@"aps"];
    NSString *alert = aps[@"alert"];
    NSString *fenceName = nil;
    if ([alert containsString:@"开"] || [alert containsString:@"入"]) {
        NSRange range = [alert rangeOfString:@"开"];
        if (range.length == 0) {
            range = [alert rangeOfString:@"入"];
        }
        NSRange subRange = NSMakeRange(range.location + 1, alert.length - range.location - 1);
        fenceName = [alert substringWithRange:subRange];
    }
    else if ([alert containsString:@"Out"] || [alert containsString:@"In"]){
        alert = [alert stringByReplacingOccurrencesOfString:@" " withString:@","];
        NSArray *alerts = [alert componentsSeparatedByString:@","];
        fenceName = alerts[2];
        if ([fenceName isEqualToString:@"Fence"]) {
            return nil;
        }
    }
    return fenceName;
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










