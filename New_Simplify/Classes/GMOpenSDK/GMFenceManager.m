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
#import "GMDevInOut.h"
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
#if 0
- (void)addFenceWithDeviceId:(NSString *)devid successBlock:(GMOptionDict)success failureBlock:(GMOptionError)failure
{
    if (devid.length == 0) return;
    
    NSString *appid = [[NSUserDefaults standardUserDefaults] objectForKey:GM_KeyOfAppid];
    if (appid.length == 0) return;
    NSString *mapType = [GMTool mapType:self.mapType];
    GMNetworkManager *manager = [GMNetworkManager manager];
    if (self.shape == GMFenceShapeOfCircle) {
        [manager createCircleFenceWithDevIDs:@[devid]
                                    andAppID:appid
                                      enable:self.enable
                                   threshold:self.threshold
                                   getInFlag:self.getIn
                                  getOutFlag:self.getOut
                                     mapType:mapType
                                   fenceName:self.fenceName
                                       coord:self.coord
                                      radius:self.radius
                             withOptionBlock:success
                             andFailureBlock:failure];
    }
    else if (self.shape == GMFenceShapeOfPolygon) {
        NSString *polygonArea = [GMTool polygonArea:self.coords count:self.coordsCount];
        [manager createPolygonFenceWithDevIDs:@[devid]
                                     andAppID:appid
                                       enable:self.enable
                                    threshold:self.threshold
                                    getInFlag:self.getIn
                                   getOutFlag:self.getOut
                                      mapType:mapType
                                    fenceName:self.fenceName
                                  polygonArea:polygonArea
                              withOptionBlock:success
                              andFailureBlock:failure];
    }
}
// TODO: 7.28
- (void)addFenceWithDeviceId:(NSString *)devid completionBlock:(GMOptionSuccess)success failureBlock:(GMOptionError)failure
{
    [self addFenceWithDeviceId:devid successBlock:^(NSDictionary *dict) {
        NSString *msg = dict[GM_Argument_msg];
        BOOL value = NO;
        msg.length == 0 ? (value = YES) : (value = NO);
        if (success) success(value);
    } failureBlock:failure];
}
#endif

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
                                  withBLock:success
                           withFailureBLock:failure];
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
                                   withBLock:success
                            withFailureBLock:failure];
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
    [manager acquireDeviceFenceWidthDevID:deviceId andAPPID:appid mapType:mapType withOptionBlock:^(NSDictionary *dict) {
        NSArray *datas = dict[GM_Argument_data];
        if (datas.count == 0) success(nil);
        NSMutableArray *mArray = [NSMutableArray array];
        for (NSDictionary *fenceInfo in datas) {
            GMFenceInfo *fence = [[GMFenceInfo alloc] initWithDeviceDict:fenceInfo];
#if 0
{
    fence.area              = [NSString stringWithFormat:@"%@",fenceInfo[GM_Argument_area]];
    fence.devInOut.devid    = [NSString stringWithFormat:@"%@",fenceInfo[GM_Argument_devid]];
    fence.enable            = [NSString stringWithFormat:@"%@",fenceInfo[GM_Argument_enable]];
    fence.fenceid           = [NSString stringWithFormat:@"%@",fenceInfo[GM_Argument_fenceid]];
    fence.devInOut.dev_in   = [NSString stringWithFormat:@"%@",fenceInfo[GM_Argument_in]];
    fence.devInOut.dev_out  = [NSString stringWithFormat:@"%@",fenceInfo[GM_Argument_out]];
    fence.name              = [NSString stringWithFormat:@"%@",fenceInfo[GM_Argument_name]];
    fence.shape             = [NSString stringWithFormat:@"%@",fenceInfo[GM_Argument_shape]];
    fence.threshold         = [NSString stringWithFormat:@"%@",fenceInfo[GM_Argument_threshold]];
    fence.update_time       = [NSString stringWithFormat:@"%@",fenceInfo[GM_Argument_update_time]];
}
#endif
            [mArray addObject:fence];
        }
        if (success) success([mArray copy]);
     } andFailureBlock:failure];
}


- (void)inquireFenceWithFenceId:(NSString *)fenceId successBlockFenceInfo:(GMOptionFenceInfo)success failureBlock:(GMOptionError)failure
{
    if (fenceId.length == 0) return;
    NSString *appid = [[NSUserDefaults standardUserDefaults] objectForKey:GM_KeyOfAppid];
    if (appid.length == 0) return;
    NSString *mapType = [GMTool mapType:self.mapType];
    GMNetworkManager *manager = [GMNetworkManager manager];
    [manager acquireDeviceFenceWidthFenceID:fenceId andAPPID:appid mapType:mapType withOptionBlock:^(NSDictionary *dict) {
        NSDictionary *fenceDict = dict[GM_Argument_data];
        if (fenceDict.count == 0) success(nil);
        GMFenceInfo *fenceInfo  = [[GMFenceInfo alloc] initWithFenceDict:fenceDict];
#if 0
{
        fenceInfo.area          = [NSString stringWithFormat:@"%@",fenceDict[GM_Argument_area]];
        fenceInfo.enable        = [NSString stringWithFormat:@"%@",fenceDict[GM_Argument_enable]];
        fenceInfo.fenceid       = [NSString stringWithFormat:@"%@",fenceDict[GM_Argument_fenceid]];
        fenceInfo.name          = [NSString stringWithFormat:@"%@",fenceDict[GM_Argument_name]];
        fenceInfo.shape         = [NSString stringWithFormat:@"%@",fenceDict[GM_Argument_shape]];
        fenceInfo.threshold     = [NSString stringWithFormat:@"%@",fenceDict[GM_Argument_threshold]];
        fenceInfo.update_time   = [NSString stringWithFormat:@"%@",fenceDict[GM_Argument_update_time]];
        NSArray *devinfos       = fenceDict[GM_Argument_devinfo];
        NSMutableArray *mArray  = [NSMutableArray array];
        for (NSDictionary *obj in devinfos) {
            GMDevInOut *devInOut    = [[GMDevInOut alloc] init];
            devInOut.devid          = [NSString stringWithFormat:@"%@",obj[GM_Argument_devid]];
            devInOut.dev_in         = [NSString stringWithFormat:@"%@",obj[GM_Argument_in]];
            devInOut.dev_out        = [NSString stringWithFormat:@"%@",obj[GM_Argument_out]];
            [mArray addObject:devInOut];
        }
        fenceInfo.devinfos = [mArray copy];
}
#endif
        if (success) success(fenceInfo);
    } andFailureBlock:failure];
}

@end









