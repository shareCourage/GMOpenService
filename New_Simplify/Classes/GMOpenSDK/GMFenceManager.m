//
//  GMFenceManager.m
//  GMOpenSDK
//
//  Created by Kowloon on 15/6/17.
//  Copyright (c) 2015年 Goome. All rights reserved.
//


#import "GMFenceManager.h"
#import "GMNetworkManager.h"
#import "GMTool.h"
#import "GMFenceInfo.h"
#import "GMConstant.h"
@implementation GMFenceManager
- (void)setUp
{
    self.enable = YES;
    self.shape = GMFenceShapeOfCircle;
    self.threshold = 3;
    self.radius = 100.0f;
    self.getIn = YES;
    self.getOut = YES;
    self.mapType = GMMapTypeOfNone;//地图类型不定
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUp];
    }
    return self;
}
- (void)setCoords:(CLLocationCoordinate2D *)coords
{
    _coords = coords;
    if (_coords != nil) {
        _shape = GMFenceShapeOfPolygon;
    }
}


- (void)addFenceWithDeviceIds:(NSArray *)devids completionBlock:(GMOptionSuccess)success failureBlock:(GMOptionError)failure
{
    if (devids.count == 0) return;
    NSString *appid = [[NSUserDefaults standardUserDefaults] objectForKey:GM_KeyOfAppid];
    if (appid.length == 0) return;
    NSString *mapType = [GMTool mapType:self.mapType];
    GMNetworkManager *manager = [GMNetworkManager manager];
    if (self.shape == GMFenceShapeOfCircle) {
        [manager createCircleFenceWithDevIDs:devids
                                    andAppID:appid
                                      enable:self.enable
                                   threshold:self.threshold
                                   getInFlag:self.getIn
                                  getOutFlag:self.getOut
                                     mapType:mapType
                                   fenceName:self.fenceName
                                       coord:self.coord
                                      radius:self.radius
                             withOptionBlock:^(NSDictionary *dict) {
                                 NSString *msg = dict[GM_Argument_msg];
                                 BOOL value = NO;
                                 msg.length == 0 ? (value = YES) : (value = NO);
                                 if (success) success(value);
                             }
                             andFailureBlock:failure];
    }
    else if (self.shape == GMFenceShapeOfPolygon) {
        NSString *polygonArea = [GMTool polygonArea:self.coords count:self.coordsCount];
        [manager createPolygonFenceWithDevIDs:devids
                                     andAppID:appid
                                       enable:self.enable
                                    threshold:self.threshold
                                    getInFlag:self.getIn
                                   getOutFlag:self.getOut
                                      mapType:mapType
                                    fenceName:self.fenceName
                                  polygonArea:polygonArea
                              withOptionBlock:^(NSDictionary *dict) {
                                  NSString *msg = dict[GM_Argument_msg];
                                  BOOL value = NO;
                                  msg.length == 0 ? (value = YES) : (value = NO);
                                  if (success) success(value);
                              }
                              andFailureBlock:failure];
    }
}

- (void)deleteFenceWithFenceId:(NSString *)fenceId successBlock:(GMOptionDict)success failureBlock:(GMOptionError)failure
{
    if (fenceId.length == 0) return;
    NSString *appid = [[NSUserDefaults standardUserDefaults] objectForKey:GM_KeyOfAppid];
    if (appid.length == 0) return;
    GMNetworkManager *manager = [GMNetworkManager manager];
    [manager deleteDeviceFenceWithAppID:appid fenceID:fenceId withBlock:success withFailBlock:failure];
}
//TODO: 7.28
- (void)deleteFenceWithFenceId:(NSString *)fenceId completionBlock:(GMOptionSuccess)success failureBlock:(GMOptionError)failure
{
    [self deleteFenceWithFenceId:fenceId successBlock:^(NSDictionary *dict) {
        NSString *msg = dict[GM_Argument_msg];
        BOOL value = NO;
        msg.length == 0 ? (value = YES) : (value = NO);
        if (success) success(value);
    } failureBlock:failure];
}


- (void)modifyFenceWithFenceId:(NSString *)fenceId successBlock:(GMOptionDict)success failureBlock:(GMOptionError)failure
{
    if (fenceId.length == 0) return;
    NSString *appid = [[NSUserDefaults standardUserDefaults] objectForKey:GM_KeyOfAppid];
    if (appid.length == 0) return;
    NSString *mapType = [GMTool mapType:self.mapType];
    GMNetworkManager *manager = [GMNetworkManager manager];
    if (self.shape == GMFenceShapeOfCircle) {
        [manager modifyCircleFenceWithAppID:appid
                                    fenceID:fenceId
                                     enable:self.enable
                                  threshold:self.threshold
                                    mapType:mapType
                                  fenceName:self.fenceName
                                      coord:self.coord
                                     radius:self.radius
                                    devinfo:self.devinfo
                                  withBlock:success
                           withFailureBlock:failure];
    }
    else if (self.shape == GMFenceShapeOfPolygon) {
        NSString *polygonArea = [GMTool polygonArea:self.coords count:self.coordsCount];
        [manager modifyPolygonFenceWithAppID:appid
                                     fenceID:fenceId
                                      enable:self.enable
                                   threshold:self.threshold
                                     mapType:mapType
                                   fenceName:self.fenceName
                                 polygonArea:polygonArea
                                     devinfo:self.devinfo
                                   withBlock:success
                            withFailureBlock:failure];
    }
    
}

- (void)modifyFenceWithFenceId:(NSString *)fenceId completionBlock:(GMOptionSuccess)success failureBlock:(GMOptionError)failure
{
    [self modifyFenceWithFenceId:fenceId successBlock:^(NSDictionary *dict) {
        NSString *msg = dict[GM_Argument_msg];
        BOOL value = NO;
        msg.length == 0 ? (value = YES) : (value = NO);
        if (success) success(value);
    } failureBlock:failure];
}

- (void)inquireFenceWithDeviceId:(NSString *)deviceId successBlock:(GMOptionDict)success failureBlock:(GMOptionError)failure
{
    if (deviceId.length == 0) return;
    NSString *appid = [[NSUserDefaults standardUserDefaults] objectForKey:GM_KeyOfAppid];
    if (appid.length == 0) return;
    NSString *mapType = [GMTool mapType:self.mapType];
    GMNetworkManager *manager = [GMNetworkManager manager];
    [manager acquireDeviceFenceWidthDevID:deviceId
                                 andAPPID:appid
                                  mapType:mapType
                          withOptionBlock:success
                          andFailureBlock:failure];
}


- (void)inquireFenceWithFenceId:(NSString *)fenceId successBlock:(GMOptionDict)success failureBlock:(GMOptionError)failure
{
    if (fenceId.length == 0) return;
    NSString *appid = [[NSUserDefaults standardUserDefaults] objectForKey:GM_KeyOfAppid];
    if (appid.length == 0) return;
    NSString *mapType = [GMTool mapType:self.mapType];
    GMNetworkManager *manager = [GMNetworkManager manager];
    [manager acquireDeviceFenceWidthFenceID:fenceId
                                   andAPPID:appid
                                    mapType:mapType
                            withOptionBlock:success
                            andFailureBlock:failure];
}

#pragma mark - 2015.07.20增加

- (void)inquireFenceWithDeviceId:(NSString *)deviceId successBlockArray:(GMOptionArray)success failureBlock:(GMOptionError)failure
{
    if (deviceId.length == 0) return;
    NSString *appid = [[NSUserDefaults standardUserDefaults] objectForKey:GM_KeyOfAppid];
    if (appid.length == 0) return;
    NSString *mapType = [GMTool mapType:self.mapType];
    GMNetworkManager *manager = [GMNetworkManager manager];
    [manager acquireDeviceFenceWidthDevID:deviceId
                                 andAPPID:appid
                                  mapType:mapType
                          withOptionBlock:^(NSDictionary *dict) {
                            NSArray *datas = dict[GM_Argument_data];
                            if (datas.count == 0) success(nil);
                            NSMutableArray *mArray = [NSMutableArray array];
                            for (NSDictionary *fenceInfo in datas) {
                                GMFenceInfo *fence = [[GMDeviceFence alloc] initWithDict:fenceInfo];
                                [mArray addObject:fence];
                            }
                            if (success) success([mArray copy]);
                         }
                          andFailureBlock:failure];
}


- (void)inquireFenceWithFenceId:(NSString *)fenceId successBlockFenceInfo:(GMOptionNumberFence)success failureBlock:(GMOptionError)failure
{
    if (fenceId.length == 0) return;
    NSString *appid = [[NSUserDefaults standardUserDefaults] objectForKey:GM_KeyOfAppid];
    if (appid.length == 0) return;
    NSString *mapType = [GMTool mapType:self.mapType];
    GMNetworkManager *manager = [GMNetworkManager manager];
    [manager acquireDeviceFenceWidthFenceID:fenceId
                                   andAPPID:appid
                                    mapType:mapType
                            withOptionBlock:^(NSDictionary *dict) {
                            NSDictionary *fenceDict = dict[GM_Argument_data];
                            if (fenceDict.count == 0) success(nil);
                            GMNumberFence *fenceInfo  = [[GMNumberFence alloc] initWithDict:fenceDict];
                            if (success) success(fenceInfo);
                        }
                            andFailureBlock:failure];
}

@end









