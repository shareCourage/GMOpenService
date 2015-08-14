//
//  GMNearbyManager.m
//  GMOpenSDK
//
//  Created by Kowloon on 15/6/17.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import "GMNearbyManager.h"
#import "GMNetworkManager.h"
#import "GMTool.h"
#import "GMConstant.h"
@interface GMNearbyManager ()

@end

@implementation GMNearbyManager


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.distance = @"200";
        self.mapType = GMMapTypeOfNone;
    }
    return self;
}
- (NSDictionary *)tagDictionary
{
    NSMutableDictionary *tagDic = [NSMutableDictionary dictionary];
    if (self.tag1.length != 0) [tagDic setObject:self.tag1 forKey:GM_Argument_tag1];
    if (self.tag2.length != 0) [tagDic setObject:self.tag2 forKey:GM_Argument_tag2];
    if (self.tag3.length != 0) [tagDic setObject:self.tag3 forKey:GM_Argument_tag3];
    return [tagDic copy];
}

- (void)nearbyDeviceInformation:(NSString *)devid successBlock:(GMOptionDict)success failureBlock:(GMOptionError)failure
{
    if (devid.length == 0) return;
    NSString *appid = [[NSUserDefaults standardUserDefaults] objectForKey:GM_KeyOfAppid];
    if (appid.length == 0) return;
    NSString *mapType = [GMTool mapType:self.mapType];
    GMNetworkManager *manager = [GMNetworkManager manager];
    [manager getNearbyDeviceInformationWithAppID:appid
                                           devID:devid
                                        distance:self.distance
                                         mapType:mapType
                                            tags:[self tagDictionary]
                                       withBlock:success
                                withFailureBlock:failure];
}


- (void)nearbyDeviceInformation:(NSString *)devid successBlockArray:(GMOptionArray)success failureBlock:(GMOptionError)failure
{
    [self nearbyDeviceInformation:devid successBlock:^(NSDictionary *dict) {
        NSArray *datas = dict[GM_Argument_data];
        if (datas.count == 0) {
            if (success) success(nil);
            return;
        }
        NSMutableArray *mArray = [NSMutableArray array];
        for (NSDictionary *objD in datas) {
            GMDeviceInfo *deviceInfo = [[GMDeviceInfo alloc] init];
            deviceInfo.course       = [NSString stringWithFormat:@"%@",objD[GM_Argument_course]];
            deviceInfo.speed        = [NSString stringWithFormat:@"%@",objD[GM_Argument_speed]];
            deviceInfo.devid        = [NSString stringWithFormat:@"%@",objD[GM_Argument_devid]];
            deviceInfo.gps_time     = [NSString stringWithFormat:@"%@",objD[GM_Argument_gps_time]];
            deviceInfo.lat          = [NSString stringWithFormat:@"%@",objD[GM_Argument_lat]];
            deviceInfo.lng          = [NSString stringWithFormat:@"%@",objD[GM_Argument_lng]];
            deviceInfo.server_time  = [NSString stringWithFormat:@"%@",objD[@"server_time"]];
            deviceInfo.sys_time     = [NSString stringWithFormat:@"%@",objD[@"sys_time"]];
            deviceInfo.heart_time   = [NSString stringWithFormat:@"%@",objD[@"heart_time"]];
            [mArray addObject:deviceInfo];
        }
        if (success) success([mArray copy]);
    } failureBlock:failure];
    
}


- (void)uploadDeviceInfo:(id<GMDevice>)device successBlock:(GMOptionDict)success failureBlock:(GMOptionError)failure
{
    if (device == nil) return;
    NSString *appid = [[NSUserDefaults standardUserDefaults] objectForKey:GM_KeyOfAppid];
    if (appid.length == 0) return;
    NSString *mapType = [GMTool mapType:self.mapType];
    GMNetworkManager *manager = [GMNetworkManager manager];
    [manager uploadMyOwnDeviceLocationWithAppID:appid
                                         device:device
                                        mapType:mapType
                                      withBlock:success
                               withFailureBlock:failure];
}
//TODO: 7.28
- (void)uploadDeviceInfo:(id<GMDevice>)device completionBlock:(GMOptionSuccess)success failureBlock:(GMOptionError)failure
{
    [self uploadDeviceInfo:device successBlock:^(NSDictionary *dict) {
        NSString *msg = dict[GM_Argument_msg];
        BOOL value = NO;
        msg.length == 0 ? (value = YES) : (value = NO);
        if (success) success(value);
    } failureBlock:failure];
}

- (void)uploadMuchOfDeviceInfos:(NSArray *)devices successBlock:(GMOptionDict)success failureBlock:(GMOptionError)failure
{
    if (devices.count == 0) return;
    NSString *appid = [[NSUserDefaults standardUserDefaults] objectForKey:GM_KeyOfAppid];
    if (appid.length == 0) return;
    NSString *mapType = [GMTool mapType:self.mapType];
    GMNetworkManager *manager = [GMNetworkManager manager];
    [manager uploadMuchOfDeviceLocationWithAppID:appid
                                          devIDs:devices
                                         mapType:mapType
                                       withBlock:success
                                withFailureBlock:failure];
}
- (void)uploadMuchOfDeviceInfos:(NSArray *)devices completionBlock:(GMOptionSuccess)success failureBlock:(GMOptionError)failure
{
    [self uploadMuchOfDeviceInfos:devices successBlock:^(NSDictionary *dict) {
        NSString *msg = dict[GM_Argument_msg];
        BOOL value = NO;
        msg.length == 0 ? (value = YES) : (value = NO);
        if (success) success(value);
    } failureBlock:failure];
}

@end






