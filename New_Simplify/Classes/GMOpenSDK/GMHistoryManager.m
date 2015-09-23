//
//  GMHistoryManager.m
//  GMOpenSDK
//
//  Created by Kowloon on 15/6/17.
//  Copyright (c) 2015年 Goome. All rights reserved.
//
#define GM_MaxNumberOfHistory   1000
#import "GMHistoryManager.h"
#import "GMNetworkManager.h"
#import "GMTool.h"
#import "GMDatabase.h"
#import "GMConstant.h"
@interface GMHistoryManager ()
{
    dispatch_queue_t _global;
}
@property(nonatomic, copy)void (^completionBlock) ();
@end

@implementation GMHistoryManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.startTime = nil;
        self.endTime = nil;
        self.mapType = GMMapTypeOfNone;
        self.numberLimit = nil;
        _global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    }
    return self;
}


- (void)getNewestInformationSuccessBlock:(GMOptionDict)success failureBlock:(GMOptionError)failure
{
    if (self.deviceId == 0) return;
    NSString *appid = [[NSUserDefaults standardUserDefaults] objectForKey:GM_KeyOfAppid];
    if (appid.length == 0) return;
    NSString *mapType = [GMTool mapType:self.mapType];
    GMNetworkManager *manager = [GMNetworkManager manager];
    [manager acquireMyOwnDeviceNewestLocationWithAppID:appid
                                                 devID:self.deviceId
                                               mapType:mapType
                                             withBlock:success
                                      withFailureBlock:failure];
}

//TODO:7.21添加
- (void)getNewestInformationSuccessBlockDeviceInfo:(GMOptionDeviceInfo)success failureBlock:(GMOptionError)failure
{
    if (self.deviceId == 0) return;
    NSString *appid = [[NSUserDefaults standardUserDefaults] objectForKey:GM_KeyOfAppid];
    if (appid.length == 0) return;
    NSString *mapType = [GMTool mapType:self.mapType];
    GMNetworkManager *manager = [GMNetworkManager manager];
    [manager acquireMyOwnDeviceNewestLocationWithAppID:appid devID:self.deviceId mapType:mapType withBlock:^(NSDictionary *dict) {
        NSArray *array = dict[GM_Argument_data];
        if (array.count == 0) return;
        NSDictionary *objD = [array firstObject];
        GMDeviceInfo *deviceInfo = [[GMDeviceInfo alloc] initWithDict:objD];
        if (success) success(deviceInfo);
    } withFailureBlock:failure];
}

- (void)getNewestInformationWithDeviceIds:(NSArray *)deviceIds successBlock:(GMOptionDict)success failureBlock:(GMOptionError)failure
{
    if (deviceIds.count == 0) return;
    NSString *appid = [[NSUserDefaults standardUserDefaults] objectForKey:GM_KeyOfAppid];
    if (appid.length == 0) return;
    NSString *mapType = [GMTool mapType:self.mapType];
    GMNetworkManager *manager = [GMNetworkManager manager];
    [manager acquireMyOwnDeviceNewestLocationWithAppID:appid
                                            devIDArray:deviceIds
                                               mapType:mapType
                                             withBlock:success
                                      withFailureBlock:failure];
}

//TODO: 7.21添加
- (void)getNewestInformationWithDeviceIds:(NSArray *)deviceIds successBlockArray:(GMOptionArray)success failureBlock:(GMOptionError)failure
{
    if (deviceIds.count == 0) return;
    NSString *appid = [[NSUserDefaults standardUserDefaults] objectForKey:GM_KeyOfAppid];
    if (appid.length == 0) return;
    NSString *mapType = [GMTool mapType:self.mapType];
    GMNetworkManager *manager = [GMNetworkManager manager];
    [manager acquireMyOwnDeviceNewestLocationWithAppID:appid
                                            devIDArray:deviceIds
                                               mapType:mapType
                                             withBlock:^(NSDictionary *dict) {
        NSArray *datas = dict[GM_Argument_data];
        if (datas.count == 0) return;
        NSMutableArray *mArray = [NSMutableArray array];
        for (NSDictionary *objD in datas) {
            GMDeviceInfo *deviceInfo = [[GMDeviceInfo alloc] initWithDict:objD];
            [mArray addObject:deviceInfo];
        }
        if (success) {
            success([mArray copy]);
        }
    } withFailureBlock:failure];
}

- (void)getHistoryInformationSuccessBlock:(GMOptionDict)success failureBlock:(GMOptionError)failure
{
    if ([self.endTime doubleValue] <= [self.startTime doubleValue]) return;
    if (self.deviceId.length == 0) return;
    NSString *appid = [[NSUserDefaults standardUserDefaults] objectForKey:GM_KeyOfAppid];
    if (appid.length == 0) return;
    NSString *mapType = [GMTool mapType:self.mapType];
    GMNetworkManager *manager = [GMNetworkManager manager];
    [manager acquireMyOwnDeviceHistoryLocationWithAppID:appid
                                                  devID:self.deviceId
                                              beginTime:self.startTime
                                             andEndTime:self.endTime
                                                mapType:mapType
                                            numberLimit:self.numberLimit
                                              withBlock:success
                                       withFailureBlock:failure];
}


//TODO: 7.21新添加
- (void)getHistoryInformationSuccessBlockArray:(GMOptionArray)success failureBlock:(GMOptionError)failure
{
    if ([self.endTime doubleValue] <= [self.startTime doubleValue]) return;
    if (self.deviceId.length == 0) return;
    NSString *appid = [[NSUserDefaults standardUserDefaults] objectForKey:GM_KeyOfAppid];
    if (appid.length == 0) return;
    NSString *mapType = [GMTool mapType:self.mapType];
    GMNetworkManager *manager = [GMNetworkManager manager];
    [manager acquireMyOwnDeviceHistoryLocationWithAppID:appid
                                                  devID:self.deviceId
                                              beginTime:self.startTime
                                             andEndTime:self.endTime
                                                mapType:mapType
                                            numberLimit:self.numberLimit
                                              withBlock:^(NSDictionary *dict) {
        NSArray *array = dict[GM_Argument_data];
        if (array.count == 0) return;
        NSMutableArray *mArray = [NSMutableArray array];
        for (NSDictionary *obj in array) {
            GMDeviceInfo *idDevice  = [[GMDeviceInfo alloc] init];
            idDevice.gps_time       = [NSString stringWithFormat:@"%@",obj[GM_Argument_gps_time]] ;
            idDevice.lat            = [NSString stringWithFormat:@"%@",obj[GM_Argument_lat]];
            idDevice.lng            = [NSString stringWithFormat:@"%@",obj[GM_Argument_lng]];
            idDevice.speed          = [NSString stringWithFormat:@"%@",obj[GM_Argument_speed]];
            idDevice.course         = [NSString stringWithFormat:@"%@",obj[GM_Argument_course]];
            idDevice.devid          = self.deviceId;
            [mArray addObject:idDevice];
        }
        if (success) success([mArray copy]);
    } withFailureBlock:failure];
}


- (void)getHistoryInformationAndSaveToLocalDatabaseWithCompletion:(void (^)(void))block
{
    if ([self.endTime doubleValue] <= [self.startTime doubleValue]) return;
    if (self.deviceId.length == 0) return;
    NSString *appid = [[NSUserDefaults standardUserDefaults] objectForKey:GM_KeyOfAppid];
    if (appid.length == 0) return;
    NSString *mapType = [GMTool mapType:self.mapType];
    if (block) self.completionBlock = block;
    [self downloadData:self.startTime
                   end:self.endTime
                 appid:appid
              deviceId:self.deviceId
               mapType:mapType
                 limit:self.numberLimit];
}


- (NSArray *)dictionary:(NSDictionary *)dict deviceId:(NSString *)deviceId
{
    NSArray *array = dict[GM_Argument_data];
    if (array.count == 0) return nil;
    NSMutableArray *mArray = [NSMutableArray array];
    for (NSDictionary *obj in array) {
        GMDeviceInfo *idDevice = [[GMDeviceInfo alloc] init];
        idDevice.gps_time   = [NSString stringWithFormat:@"%@",obj[GM_Argument_gps_time]] ;
        idDevice.lat        = [NSString stringWithFormat:@"%@",obj[GM_Argument_lat]];
        idDevice.lng        = [NSString stringWithFormat:@"%@",obj[GM_Argument_lng]];
        idDevice.speed      = [NSString stringWithFormat:@"%@",obj[GM_Argument_speed]];
        idDevice.course     = [NSString stringWithFormat:@"%@",obj[GM_Argument_course]];
        idDevice.devid      = deviceId;
        [[GMDatabase shareDatabase] dbAddHistoryInfoOnQueue:idDevice];
        [mArray addObject:idDevice];
    }
    return mArray;
}

//FIXME:limit暂时都置为空，保持默认状态
- (void)downloadData:(NSString *)beginStr end:(NSString *)endStr appid:(NSString *)appid deviceId:(NSString *)deviceId mapType:(NSString *)mapType limit:(NSString *)limit
{
    GMNetworkManager *manager = [GMNetworkManager manager];//1440664708  1440668961
    [manager acquireMyOwnDeviceHistoryLocationWithAppID:appid
                                                  devID:deviceId
                                              beginTime:beginStr
                                             andEndTime:endStr
                                                mapType:mapType
                                            numberLimit:self.numberLimit
                                              withBlock:^(NSDictionary *dict) {//这个block会被AF安置在主线程执行，所以，内部需要在子线程执行的，仍需要主动调用子线程方法
                dispatch_async(_global, ^{
                    NSArray *array = [self dictionary:dict deviceId:deviceId];
                    if (array.count == 0) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (self.completionBlock) self.completionBlock();
                        });
                        return;
                    }
                    if (array.count >= GM_MaxNumberOfHistory) {
                        GMDeviceInfo *lastDevice = [array lastObject];
                        [self downloadData:lastDevice.gps_time
                                       end:self.endTime
                                     appid:appid
                                  deviceId:deviceId
                                   mapType:mapType
                                     limit:self.numberLimit];
                    }
                    else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (self.completionBlock) self.completionBlock();
                        });
                    }
                });
    } withFailureBlock:nil];
}


- (int)countOfTheHistoryInfos
{
    if (self.deviceId.length == 0) return 0;
    return [[GMDatabase shareDatabase] dbTotalCountOfHistoryInfoWidthDevid:self.deviceId];
}

- (id)selectMaxGpstimeHistoryInfosWithDevice:(id<GMDevice>)device {
    if (device == nil || self.deviceId.length == 0) return nil;
    return [[GMDatabase shareDatabase] dbSelectMaxGpstimeHistoryInfo:device devid:self.deviceId];
}

- (NSArray *)selectAllOfHistoryInfosWithDevice:(id<GMDevice>)device orderBy:(GMOrderBy)orderBy
{
    if (device == nil || self.deviceId.length == 0) return nil;
    return [[GMDatabase shareDatabase] dbAllOfTheHistoryInfoWithDevice:device orderBy:orderBy devid:self.deviceId];
}

- (NSArray *)selectHistoryInfosWithDevice:(id<GMDevice>)device orderBy:(GMOrderBy)orderBy limit:(NSNumber *)limit offset:(NSNumber *)offset
{
    if (device == nil || self.deviceId.length == 0) return nil;
    if ([limit intValue] < 0 || [offset intValue] < 0) return nil;
    return [[GMDatabase shareDatabase] dbHistoryInfoWithDevice:device orderBy:orderBy limit:limit offset:offset devid:self.deviceId];
}


- (NSArray *)selectHistoryInfosWithDevice:(id<GMDevice>)device fromTime:(NSString *)from toTime:(NSString *)to orderBy:(GMOrderBy)orderBy
{
    if (device == nil || from.length == 0 || to.length == 0 || self.deviceId.length == 0) return nil;
    return [[GMDatabase shareDatabase] dbHistoryInfosWithDevice:device fromTime:from toTime:to devid:self.deviceId orderBy:orderBy];
}

- (NSArray *)selectHistoryInfosWithDevice:(id<GMDevice>)device fromSpeed:(NSString *)from toSpeed:(NSString *)to
{
    if (device == nil || from.length == 0 || to.length == 0 || self.deviceId.length == 0) return nil;
    return [[GMDatabase shareDatabase] dbHistoryInfosWithDevice:device fromSpeed:from toSpeed:to devid:self.deviceId];
}
- (NSArray *)selectHistoryInfosWithDevice:(id<GMDevice>)device fromLat:(NSString *)from toLat:(NSString *)to
{
    if (device == nil || from.length == 0 || to.length == 0 || self.deviceId.length == 0) return nil;
    return [[GMDatabase shareDatabase] dbHistoryInfosWithDevice:device fromLat:from toLat:to devid:self.deviceId];
}
- (NSArray *)selectHistoryInfosWithDevice:(id<GMDevice>)device fromLng:(NSString *)from toLng:(NSString *)to
{
    if (device == nil || from.length == 0 || to.length == 0 || self.deviceId.length == 0) return nil;
    return [[GMDatabase shareDatabase] dbHistoryInfosWithDevice:device fromLng:from toLng:to devid:self.deviceId];
}
- (NSArray *)selectHistoryInfosWithDevice:(id<GMDevice>)device fromCourse:(NSString *)from toCourse:(NSString *)to
{
    if (device == nil || from.length == 0 || to.length == 0 || self.deviceId.length == 0) return nil;
    return [[GMDatabase shareDatabase] dbHistoryInfosWithDevice:device fromCourse:from toCourse:to devid:self.deviceId];
}
- (BOOL)deleteHistoryInfoWhereGpstime:(NSString *)gpstime
{
    if (gpstime.length == 0 || self.deviceId.length == 0) return NO;
    return [[GMDatabase shareDatabase] dbDeleteHistoryInfoWithGpstime:gpstime devid:self.deviceId];
}

- (BOOL)deleteHistoryInfo
{
    if (self.deviceId.length == 0) return NO;
    return [[GMDatabase shareDatabase] dbDeleteAllOfTheHistoryInfoWidthDevid:self.deviceId];
}


- (NSArray *)selectHistoryInfosWithDevice:(id<GMDevice>)device sqlite:(NSString *)sqlite
{
    if (device == nil || sqlite.length == 0) return nil;
    NSString *select = [sqlite substringWithRange:NSMakeRange(0, 6)];
    if (![select isEqualToString:@"select"]) return nil;
    return [[GMDatabase shareDatabase] dbExecuteWithDevice:device sqlite:sqlite];
}


@end








