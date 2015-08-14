//
//  GMPushManager.m
//  GMOpenSDK
//
//  Created by Kowloon on 15/6/17.
//  Copyright (c) 2015年 Goome. All rights reserved.
//
//#define GM_iOS(version) ([[[UIDevice currentDevice] systemVersion] floatValue] >= version)
#import "GMPushManager.h"
#import "GMNetworkManager.h"
#import "GMOpenUDID.h"
#import "GMConstant.h"

@implementation GMPushManager


+ (void)iOS7RegisterForRemoteNotificationTypes:(NSUInteger)types
{
    UIApplication *application = [UIApplication sharedApplication];
    [application registerForRemoteNotificationTypes:types];
}


+ (void)iOS8RegisterForRemoteNotificationTypes:(NSUInteger)types categories:(NSSet *)categories
{
    UIApplication *application = [UIApplication sharedApplication];
    UIUserNotificationSettings *userN = [UIUserNotificationSettings settingsForTypes:types categories:categories];
    [application registerUserNotificationSettings:userN];
    [application registerForRemoteNotifications];
}

+ (void)setupWithOption:(NSDictionary *)launchingOption
{
    if (!launchingOption) return;
}

+ (void)registerDeviceToken:(NSData *)deviceToken 
{
    GMNetworkManager *manager = [GMNetworkManager manager];
    NSString *appid = [[NSUserDefaults standardUserDefaults] objectForKey:GM_KeyOfAppid];
    NSString *openUDIDStr = [GMOpenUDID value];
    if (appid.length == 0 || openUDIDStr.length == 0 || deviceToken == nil) return;
    [manager registerWithAppID:appid
                          udid:openUDIDStr
                   deviceToken:deviceToken
                  successBlock:^(NSDictionary *dict) {
                      NSLog(@"registerCid->%@",dict);
        NSString *msg = dict[GM_Argument_msg];
        if (msg.length == 0) {
            NSDictionary *channelD = dict[GM_Argument_data];
            NSString *channelid = channelD[GM_Argument_channelid];
            if (channelid.length == 0) return;
            [[NSUserDefaults standardUserDefaults] setObject:channelid forKey:GM_KeyOfChannelid];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    } failureBlock:nil];
}

+ (void)handleRemoteNotification:(NSDictionary *)remoteInfo
{
    
}


@end





