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
#import "GMDeviceInfo.h"
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

- (BOOL)nearbyDeviceInformation:(NSString *)devid successBlock:(GMOptionDict)success failureBlock:(GMOptionError)failure
{
    if (devid.length == 0) return NO;
    NSString *appid = [[NSUserDefaults standardUserDefaults] objectForKey:GM_KeyOfAppid];
    if (appid.length == 0) return NO;
    NSString *mapType = [GMTool mapType:self.mapType];
    GMNetworkManager *manager = [GMNetworkManager manager];
    id operation = [manager getNearbyDeviceInformationWithAppID:appid
                                                          devID:devid
                                                       distance:self.distance
                                                        mapType:mapType
                                                           tags:[self tagDictionary]
                                                      withBlock:success
                                               withFailureBlock:failure];
    return operation == nil ? NO : YES;
}


- (BOOL)nearbyDeviceInformation:(NSString *)devid successBlockArray:(GMOptionArray)success failureBlock:(GMOptionError)failure
{
    return [self nearbyDeviceInformation:devid successBlock:^(NSDictionary *dict) {
        NSArray *datas = dict[GM_Argument_data];
        if (datas.count == 0) {
            if (success) success(nil);
            return;
        }
        NSMutableArray *mArray = [NSMutableArray array];
        for (NSDictionary *objD in datas) {
            GMDeviceInfo *deviceInfo = [[GMDeviceInfo alloc] initWithDict:objD];
            [mArray addObject:deviceInfo];
        }
        if (success) success([mArray copy]);
    } failureBlock:failure];
}


- (BOOL)uploadDeviceInfo:(id<GMDevice>)device successBlock:(GMOptionDict)success failureBlock:(GMOptionError)failure
{
    if (device == nil) return NO;
    NSString *appid = [[NSUserDefaults standardUserDefaults] objectForKey:GM_KeyOfAppid];
    if (appid.length == 0) return NO;
    NSString *mapType = [GMTool mapType:self.mapType];
    GMNetworkManager *manager = [GMNetworkManager manager];
    id operation = [manager uploadMyOwnDeviceLocationWithAppID:appid
                                                        device:device
                                                       mapType:mapType
                                                     withBlock:success
                                              withFailureBlock:failure];
    return operation == nil ? NO : YES;
}
//TODO: 7.28
- (BOOL)uploadDeviceInfo:(id<GMDevice>)device completionBlock:(GMOptionSuccess)success failureBlock:(GMOptionError)failure
{
    return [self uploadDeviceInfo:device successBlock:^(NSDictionary *dict) {
        NSString *msg = dict[GM_Argument_msg];
        BOOL value = NO;
        msg.length == 0 ? (value = YES) : (value = NO);
        if (success) success(value);
    } failureBlock:failure];
}

- (BOOL)uploadMuchOfDeviceInfos:(NSArray *)devices successBlock:(GMOptionDict)success failureBlock:(GMOptionError)failure
{
    if (devices.count == 0) return NO;
    NSString *appid = [[NSUserDefaults standardUserDefaults] objectForKey:GM_KeyOfAppid];
    if (appid.length == 0) return NO;
    NSString *mapType = [GMTool mapType:self.mapType];
    GMNetworkManager *manager = [GMNetworkManager manager];
    id operation = [manager uploadMuchOfDeviceLocationWithAppID:appid
                                                         devIDs:devices
                                                        mapType:mapType
                                                      withBlock:success
                                               withFailureBlock:failure];
    return operation == nil ? NO : YES;
}
- (BOOL)uploadMuchOfDeviceInfos:(NSArray *)devices completionBlock:(GMOptionSuccess)success failureBlock:(GMOptionError)failure
{
    return [self uploadMuchOfDeviceInfos:devices successBlock:^(NSDictionary *dict) {
        NSString *msg = dict[GM_Argument_msg];
        BOOL value = NO;
        msg.length == 0 ? (value = YES) : (value = NO);
        if (success) success(value);
    } failureBlock:failure];
}


- (BOOL)reverseGeocode:(CLLocationCoordinate2D *)coords count:(NSUInteger)count completionBlock:(GMOptionArray)success failureBlock:(GMOptionError)failure
{
    NSString *appid = [[NSUserDefaults standardUserDefaults] objectForKey:GM_KeyOfAppid];
    if (appid.length == 0 || count <= 0) return NO;
    NSString *mapType = [GMTool mapType:self.mapType];
    NSArray *array = [GMTool coordinates:coords count:count mapType:mapType];
    GMNetworkManager *manager = [GMNetworkManager manager];
    id operation = [manager reverseGecodeWithAppID:appid
                                      reverseArray:array
                                           mapType:mapType
                                      successBlock:^(NSDictionary *dict) {
//                                          GMLog(@"~~~~~~~~~~~~~~%@",dict);
                                          NSArray *data = dict[GM_Argument_data];
                                          NSMutableArray *mArray = [NSMutableArray array];
                                          for (NSDictionary *obj in data) {
                                              GMGeocodeResult *result = [[GMGeocodeResult alloc] initWithDict:obj];
                                              [mArray addObject:result];
                                          }
                                          mArray.count == 0 ? success(nil) : success([mArray copy]);
                                      }
                                      failureBlock:failure];
    return operation == nil ? NO : YES;
}

@end






