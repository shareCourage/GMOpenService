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
#import "GMConstant.h"
#import "GMTool.h"
#import "GMPushInfo.h"

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
    NSString *openUDIDStr = [GMTool getUniqueIdentifier];
    if (appid.length == 0 || openUDIDStr.length == 0 || deviceToken == nil) return;
    [manager registerWithAppID:appid
                          udid:openUDIDStr
                   deviceToken:deviceToken
                  successBlock:^(NSDictionary *dict) {
                      GMLog(@"registerCid->%@",dict);
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
    if (remoteInfo) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }

}

- (BOOL)updatePushTypeWithDevid:(NSString *)devid completionBlock:(GMOptionSuccess)success failureBlock:(GMOptionError)failure
{
    NSString *appid = [[NSUserDefaults standardUserDefaults] objectForKey:GM_KeyOfAppid];
    NSString *channelid = [[NSUserDefaults standardUserDefaults] objectForKey:GM_KeyOfChannelid];
    if (appid.length == 0 || devid.length == 0 || channelid.length == 0) return NO;
    NSString *mapType   = [GMTool mapType:self.mapType];
    GMNetworkManager *manager = [GMNetworkManager manager];
    id operation = [manager updatePushTypeWithAppID:appid
                                           deviceID:devid
                                          channelid:channelid
                                               lang:self.lang
                                          alarmType:self.alarmType
                                           timeZone:self.timeZone
                                              sound:self.sound
                                              shake:self.shake
                                          startTime:self.startTime
                                            endTime:self.endTime
                                            mapType:mapType
                                       successBlock:^(NSDictionary *dict) {
                                           NSString *msg = dict[GM_Argument_msg];
                                           BOOL value = NO;
                                           msg.length == 0 ? (value = YES) : (value = NO);
                                           if (success) success(value);
                                       } failureBlock:failure];
    
    return operation == nil ? NO : YES;
}



- (BOOL)getPushInfoWithDevid:(NSString *)devid completionBlock:(GMOptionPushInfo)pushInfo failureBlock:(GMOptionError)failure
{
    NSString *appid = [[NSUserDefaults standardUserDefaults] objectForKey:GM_KeyOfAppid];
    NSString *channelid = [[NSUserDefaults standardUserDefaults] objectForKey:GM_KeyOfChannelid];
    if (appid.length == 0 || devid.length == 0 || channelid.length == 0) return NO;
    GMNetworkManager *manager = [GMNetworkManager manager];
    id operation = [manager acquirePushInfoWithAppID:appid
                                               devid:devid
                                           channelid:channelid
                                        successBlock:^(NSDictionary *dict) {
                                            NSDictionary *data = dict[GM_Argument_data];
                                            if (data.count == 0) {
                                                pushInfo(nil);
                                            }
                                            else {
                                                GMPushInfo *push = [[GMPushInfo alloc] initWithDict:data];
                                                pushInfo(push);
                                            }
                                        }
                                        failureBlock:failure];
    return operation == nil ? NO : YES;
}
@end





