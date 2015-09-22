//
//  GMNetworkManager.m
//  GMOpenSDK
//
//  Created by Kowloon on 15/6/17.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import "GMNetworkManager.h"
#import "GMConstant.h"
#import "NSString+PHCategory.h"
#import "GMTool.h"
@implementation GMNetworkManager
/**
 *  对GMHTTPRequestOperationManager的GET封装
 *
 *  @param url         url ?前面的一部分，eg:https: //www.baidu.com/s  ?wd=textfield
 *  @param parameters  parameters description
 *  @param optionDict  void (^GMNetworkOption)(NSDictionary *dict)
 *  @param errorOption void (^GMNetworkError)(NSError *error)#optionError description#>
 *
 *  @return GMHTTPRequestOperation
 */
- (GMHTTPRequestOperation *)GET:(NSString *)url
                     parameters:(id)parameters
                      dictBlock:(GMOptionDict)optionDict
                     errorBlock:(GMOptionError)optionError
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    GMHTTPRequestOperationManager *manager = [GMHTTPRequestOperationManager manager];
    manager.responseSerializer = [GMHTTPResponseSerializer serializer];//将数据转化为NSData
    GMHTTPRequestOperation *operation = [manager GET:url parameters:parameters success:^(GMHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if (optionDict) {
            optionDict(dict);
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    } failure:^(GMHTTPRequestOperation *operation, NSError *error) {
        if (optionError) {
            optionError(error);
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    }];
    return operation;
}

/**
 *  对GMHTTPRequestOperationManager的POST封装
 *
 *  @param url         url ?前面的一部分，eg:https://www.baidu.com/s  ?wd=textfield
 *  @param parameters  parameters description
 *  @param optionDict  void (^GMNetworkOption)(NSDictionary *dict)
 *  @param errorOption void (^GMNetworkError)(NSError *error)#optionError description#>
 *
 *  @return GMHTTPRequestOperation
 */
- (GMHTTPRequestOperation *)POST:(NSString *)url
                      parameters:(id)parameters
                       dictBlock:(GMOptionDict)optionDict
                      errorBlock:(GMOptionError)optionError
{
    GMHTTPRequestOperationManager *manager = [GMHTTPRequestOperationManager manager];
    manager.responseSerializer = [GMHTTPResponseSerializer serializer];//将数据转化为NSData
    GMHTTPRequestOperation *operation = [manager POST:url parameters:parameters success:^(GMHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if (optionDict) {
            optionDict(dict);
        }
    } failure:^(GMHTTPRequestOperation *operation, NSError *error) {
        if (optionError) {
            optionError(error);
        }
    }];
    return operation;
}

#pragma mark - selfForBasicInformation
/**
 *  设备接入及位置信息上传
 *
 *  @param appID       appID description
 *  @param devID       devID description
 *  @param latitude    latitude description
 *  @param longitude   longitude description
 *  @param optionDict  void (^GMOptionDict)(NSDictionary *dict)
 *  @param optionError (^GMOptionError)(NSError *error)
 */
- (GMHTTPRequestOperation *)uploadMyOwnDeviceLocationWithAppID:(NSString *)appID
                                                         devID:(NSString *)devID
                                                      latitude:(NSString *)latitude
                                                     longitude:(NSString *)longitude
                                                     withBlock:(GMOptionDict)optionDict
                                              withFailureBlock:(GMOptionError)optionError
{
    if (devID.length == 0 || appID.length == 0 || latitude == nil || longitude == nil) {
        return nil;
    }
    // @"http: //open.goome.net/1/device/setloc?appid=23&devid=4632434392&gps_time=1366786321&course=0&speed=0&lng=113.91919&lat=22.54546"
    NSDictionary *parameters = @{GM_Argument_appid:appID,
                                 GM_Argument_devid:devID,
                                 GM_Argument_gps_time:GM_CurrentTime,
                                 GM_Argument_course:@"0",
                                 GM_Argument_speed:@"0",
                                 GM_Argument_lat:latitude,
                                 GM_Argument_lng:longitude};
    GMHTTPRequestOperation *operation = [self GET:GM_Setloc_URL parameters:parameters dictBlock:optionDict errorBlock:optionError];
    return operation;
}
//更新日期:2015.04.10.17:00
/**
 *  设备接入及位置信息上传 (完整参数,添加course,speed,time)
 *
 *  @param appID       appID description
 *  @param devID       devID description
 *  @param latitude    latitude description
 *  @param longitude   longitude description
 *  @param course       course description
 *  @param speed        speed description
 *  @param time        time description
 *  @param optionDict  void (^GMOptionDict)(NSDictionary *dict)
 *  @param optionError (^GMOptionError)(NSError *error)
 */
- (GMHTTPRequestOperation *)uploadMyOwnDeviceLocationWithAppID:(NSString *)appID
                                                         devID:(NSString *)devID
                                                      latitude:(NSString *)latitude
                                                     longitude:(NSString *)longitude
                                                        course:(NSString *)course
                                                         speed:(NSString *)speed
                                                          time:(NSString *)time
                                                     withBlock:(GMOptionDict)optionDict
                                              withFailureBlock:(GMOptionError)optionError
{
    if (devID.length == 0 || appID.length == 0 || latitude == nil || longitude == nil || time == nil) {
        return nil;
    }
    // @"http: //open.goome.net/1/device/setloc?appid=23&devid=4632434392&gps_time=1366786321&course=0&speed=0&lng=113.91919&lat=22.54546"
    NSDictionary *parameters = @{GM_Argument_appid:appID,
                                 GM_Argument_devid:devID,
                                 GM_Argument_gps_time:time,
                                 GM_Argument_course:course,
                                 GM_Argument_speed:speed,
                                 GM_Argument_lat:latitude,
                                 GM_Argument_lng:longitude};
    GMHTTPRequestOperation *operation = [self GET:GM_Setloc_URL parameters:parameters dictBlock:optionDict errorBlock:optionError];
    return operation;
}

//TODO: 7.27添加
- (GMHTTPRequestOperation *)uploadMyOwnDeviceLocationWithAppID:(NSString *)appID
                                                        device:(id<GMDevice>)device
                                                       mapType:(NSString *)mapType
                                                     withBlock:(GMOptionDict)optionDict
                                              withFailureBlock:(GMOptionError)optionError
{
    if (appID.length == 0 || ![device conformsToProtocol:@protocol(GMDevice)]) return nil;
    if (device.devid.length == 0 || device.gps_time.length == 0) return nil;
    NSMutableDictionary *mpara = [GMTool deviceParameters:device];
    [mpara setObject:appID forKey:GM_Argument_appid];
    if (mapType.length != 0) [mpara setObject:mapType forKey:GM_Argument_map_type];
    GMHTTPRequestOperation *operation = [self GET:GM_Setloc_URL parameters:mpara dictBlock:optionDict errorBlock:optionError];
    return operation;
}
/**
 *  设备接入及位置信息上传(批量信息上传)
 *
 *  @param appID       appID description
 *  @param devIDs      devIDs 一个数组，里面存储模型，但这个模型必须遵行GMGoomeOpenBasicInfo协议
 *  @param optionDict  void (^GMOptionDict)(NSDictionary *dict)
 *  @param optionError (^GMOptionError)(NSError *error)
 *  @return GMHTTPRequestOperation
 */
- (GMHTTPRequestOperation *)uploadMuchOfDeviceLocationWithAppID:(NSString *)appID
                                                         devIDs:(NSArray *)devIDs
                                                        mapType:(NSString *)mapType
                                                      withBlock:(GMOptionDict)optionDict
                                               withFailureBlock:(GMOptionError)optionError
{
    if (appID.length == 0 || devIDs.count == 0) return nil;
    NSMutableArray *array = [NSMutableArray array];
    for (id obj in devIDs) {
        if (![obj conformsToProtocol:@protocol(GMDevice)]) return nil;
        [array addObject:[GMTool deviceParameters:obj]];
    }
    NSDictionary *dict = @{GM_Argument_appid:appID,
                           GM_Argument_data:array};
    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    if (mapType.length != 0) [mDict setObject:mapType forKey:GM_Argument_map_type];
    __autoreleasing NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:mDict options:NSJSONWritingPrettyPrinted error:&error];
    if (error) return nil;
    NSString *parameters = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    GMHTTPRequestOperation *operation = [self POST:GM_Setloc_URL parameters:parameters dictBlock:optionDict errorBlock:optionError];
    return operation;
}


/**
 *  历史位置信息获取
 *
 *  @param begintime 起始时间
 *  @param endtime   结束时间
 *  @param option    void (^GMOptionDict)(NSDictionary *dict)
 *  @param error    void (^GMOptionError)(NSError *error)
 */
- (GMHTTPRequestOperation *)acquireMyOwnDeviceHistoryLocationWithAppID:(NSString *)appID
                                                                 devID:(NSString *)devID
                                                             beginTime:(NSString *)begintime
                                                            andEndTime:(NSString *)endtime
                                                               mapType:(NSString *)mapType
                                                           numberLimit:(NSString *)limit
                                                             withBlock:(GMOptionDict)optionDict
                                                      withFailureBlock:(GMOptionError)optionError
{
    if (devID.length == 0 || appID.length == 0 || begintime == nil || endtime == nil) return nil;
    if ([begintime doubleValue] >= [endtime doubleValue]) return nil;
    NSDictionary *parameters = [GMTool parameters:appID deviceId:devID beginTime:begintime endTime:endtime mapType:mapType numberLimit:limit];
    GMHTTPRequestOperation *operation = [self GET:GM_GetHistoryloc_URL parameters:parameters dictBlock:optionDict errorBlock:optionError];
    return operation;
}

/**
 *  设备实时位置信息获取(最新的位置信息)
 *
 *  @param appID       appID description
 *  @param devID       devID description
 *  @param optionDict  void (^GMOptionDict)(NSDictionary *dict)
 *  @param error    void (^GMOptionError)(NSError *error)
 *
 *  @return GMHTTPRequestOperation
 */
- (GMHTTPRequestOperation *)acquireMyOwnDeviceNewestLocationWithAppID:(NSString *)appID
                                                                devID:(NSString *)devID
                                                              mapType:(NSString *)mapType
                                                            withBlock:(GMOptionDict)optionDict
                                                     withFailureBlock:(GMOptionError)optionError
{
    if (devID.length == 0 || appID.length == 0) return nil;
    NSDictionary *parameters = [GMTool parameters:appID deviceId:devID fenceId:nil mapType:mapType];
    GMHTTPRequestOperation *operation = [self GET:GM_Getloc_URL parameters:parameters dictBlock:optionDict errorBlock:optionError];
    return operation;
}
/**
 *  多台设备(一台也可以)实时位置信息获取(最新的位置信息)
 *
 *  @param appID        appID description
 *  @param devIDArray   devIDArray 数组内容必须是NSString类型
 *  @param optionDict   void (^GMOptionDict)(NSDictionary *dict)
 *  @param error        void (^GMOptionError)(NSError *error)
 *
 *  @return GMHTTPRequestOperation
 */
- (GMHTTPRequestOperation *)acquireMyOwnDeviceNewestLocationWithAppID:(NSString *)appID
                                                           devIDArray:(NSArray *)devIDArray
                                                              mapType:(NSString *)mapType
                                                            withBlock:(GMOptionDict)optionDict
                                                     withFailureBlock:(GMOptionError)optionError
{
    if (appID.length == 0 || devIDArray.count == 0) return nil;
    for (id obj in devIDArray) {//若其中有一组信息不是NSString类型，则结束
        if (![obj isKindOfClass:[NSString class]]) return nil;
    }
    NSDictionary *parameters = @{GM_Argument_appid:appID,
                                 GM_Argument_devid:[GMTool stringConnected:devIDArray connectString:@","]};
    GMHTTPRequestOperation *operation = [self GET:GM_Getloc_URL parameters:parameters dictBlock:optionDict errorBlock:optionError];
    return operation;
}

//2015.04.10 16:45
/**
 *  附近设备位置信息获取
 *
 *  @param appID       appID description
 *  @param devID       devID description
 *  @param distance    distance 距离
 *  @param mapType     mapType 地图类型 eg:BAIDU, GOOGLE
 *  @param optionDict  void (^GMOptionDict)(NSDictionary *dict)
 *  @param error       void (^GMOptionError)(NSError *error)
 *
 *  @return GMHTTPRequestOperation
 */
- (GMHTTPRequestOperation *)getNearbyDeviceInformationWithAppID:(NSString *)appID
                                                          devID:(NSString *)devID
                                                       distance:(NSString *)distance
                                                        mapType:(NSString *)mapType
                                                           tags:(NSDictionary *)tags
                                                      withBlock:(GMOptionDict)optionDict
                                               withFailureBlock:(GMOptionError)optionError
{
    if (appID.length == 0 || devID.length == 0 || distance.length == 0) return nil;
    NSDictionary *parameters = [GMTool parameters:appID
                                         deviceId:devID
                                          fenceId:nil
                                         distance:distance
                                          mapType:mapType
                                             tags:tags];
    GMHTTPRequestOperation *operation = [self GET:GM_Getnearby_URL parameters:parameters dictBlock:optionDict errorBlock:optionError];
    return operation;
}



#pragma mark - selfForFence

/**
 *  根据devID,查询设备的围栏
 *
 *  @param devID  围栏设备号
 *  @param appID  appID号
 *  @param option void (^GMNetworkOption)(NSDictionary *dict)
 *  @param errorOption void (^GMNetworkError)(NSError *error)
 */
- (GMHTTPRequestOperation *)acquireDeviceFenceWidthDevID:(NSString *)devID
                                                andAPPID:(NSString *)appID
                                                 mapType:(NSString *)mapType
                                         withOptionBlock:(GMOptionDict)optionDict
                                         andFailureBlock:(GMOptionError)optionError
{
    if (devID.length == 0 || appID.length == 0) return nil;
    NSDictionary *parameters= [GMTool parameters:appID deviceId:devID fenceId:nil mapType:mapType];
    GMHTTPRequestOperation *operation = [self GET:GM_Get_Fence_URL parameters:parameters dictBlock:optionDict errorBlock:optionError];
    return operation;
}

/**
 *  根据fenceID,查询设备的围栏
 *
 *  @param fenceID  围栏号
 *  @param appID  appID号
 *  @param option void (^GMNetworkOption)(NSDictionary *dict)
 *  @param errorOption void (^GMNetworkError)(NSError *error)
 */
- (GMHTTPRequestOperation *)acquireDeviceFenceWidthFenceID:(NSString *)fenceID
                                                  andAPPID:(NSString *)appID
                                                   mapType:(NSString *)mapType
                                           withOptionBlock:(GMOptionDict)optionDict
                                           andFailureBlock:(GMOptionError)optionError
{
    if (fenceID.length == 0 || appID.length == 0) return nil;
    NSDictionary *parameters = [GMTool parameters:appID deviceId:nil fenceId:fenceID mapType:mapType];
    GMHTTPRequestOperation *operation = [self GET:GM_Get_Fence_URL parameters:parameters dictBlock:optionDict errorBlock:optionError];
    return operation;
}

/**
 *  POST请求,创建一个设备的围栏(默认使用圆形围栏),报警阈值默认使用3
 *
 *  @param devID       devID description
 *  @param appID       appID description
 *  @param enable      enable 默认使用YES 0：关闭，1：开启
 *  @param coord       coord 经纬度
 *  @param radius      radius 围栏半径
 *  @param option      void (^GMNetworkOption)(NSDictionary *dict)
 *  @param errorOption void (^GMNetworkError)(NSError *error)
 */
- (GMHTTPRequestOperation *)createCircleFenceWithDevID:(NSString *)devID
                                              andAppID:(NSString *)appID
                                                enable:(BOOL)enable
                                                 coord:(CLLocationCoordinate2D)coord
                                                radius:(CGFloat)radius
                                       withOptionBlock:(GMOptionDict)optionDict
                                       andFailureBlock:(GMOptionError)OptionError
{
    return [self createCircleFenceWithDevIDs:@[devID] andAppID:appID enable:enable threshold:3 getInFlag:YES getOutFlag:YES mapType:nil fenceName:nil coord:coord radius:radius withOptionBlock:optionDict andFailureBlock:OptionError];
}


- (GMHTTPRequestOperation *)createCircleFenceWithDevIDs:(NSArray *)devIDs
                                               andAppID:(NSString *)appID
                                                 enable:(BOOL)enable
                                              threshold:(NSUInteger)threshold
                                              getInFlag:(BOOL)getIn
                                             getOutFlag:(BOOL)getOut
                                                mapType:(NSString *)mapType
                                              fenceName:(NSString *)fenceName
                                                  coord:(CLLocationCoordinate2D)coord
                                                 radius:(CGFloat)radius
                                        withOptionBlock:(GMOptionDict)optionDict
                                        andFailureBlock:(GMOptionError)OptionError
{
    if (devIDs.count == 0 || appID.length == 0 || coord.latitude == 0 || coord.longitude == 0) return nil;
    NSString *area = [NSString stringWithFormat:@"%.6f,%.6f,%.f",coord.latitude,coord.longitude,radius];
    NSString *devInfo = [GMTool devidinfos:devIDs getIn:getIn getOut:getOut];
    NSDictionary *parameters = [GMTool parameters:appID
                                            shape:@1
                                        threshold:@(threshold)
                                              are:area
                                           enable:@(enable)
                                          mapType:mapType
                                        fenceName:fenceName
                                          devInfo:devInfo];
    GMHTTPRequestOperation *operation = [self POST:GM_Create_Fence_URL parameters:parameters dictBlock:optionDict errorBlock:OptionError];
    return operation;
}

- (GMHTTPRequestOperation *)createPolygonFenceWithDevIDs:(NSArray *)devIDs
                                                andAppID:(NSString *)appID
                                                  enable:(BOOL)enable
                                               threshold:(NSUInteger)threshold
                                               getInFlag:(BOOL)getIn
                                              getOutFlag:(BOOL)getOut
                                                 mapType:(NSString *)mapType
                                               fenceName:(NSString *)fenceName
                                             polygonArea:(NSString *)area
                                         withOptionBlock:(GMOptionDict)optionDict
                                         andFailureBlock:(GMOptionError)OptionError
{
    if (devIDs.count == 0 || appID.length == 0 || area.length == 0) return nil;
    NSString *devInfo = [GMTool devidinfos:devIDs getIn:getIn getOut:getOut];
    NSDictionary *parameters = [GMTool parameters:appID
                                            shape:@2
                                        threshold:@(threshold)
                                              are:area
                                           enable:@(enable)
                                          mapType:mapType
                                        fenceName:fenceName
                                          devInfo:devInfo];
    GMHTTPRequestOperation *operation = [self POST:GM_Create_Fence_URL parameters:parameters dictBlock:optionDict errorBlock:OptionError];
    return operation;
}


/**
 *  删除围栏
 *
 *  @param appID      appID description
 *  @param fenceID    fenceID description
 *  @param dictOption void (^GMNetworkOption)(NSDictionary *dict)
 *  @param errorBlock void (^GMNetworkError)(NSError *error)
 *
 *  @return GMHTTPRequestOperation
 */
- (GMHTTPRequestOperation *)deleteDeviceFenceWithAppID:(NSString *)appID
                                               fenceID:(NSString *)fenceID
                                             withBlock:(GMOptionDict)optionDict
                                         withFailBlock:(GMOptionError)optionError
{
    if (appID.length == 0 || fenceID.length == 0) return nil;
    NSDictionary *parameters = @{GM_Argument_appid:  appID,
                                 GM_Argument_fenceid:fenceID};
    GMHTTPRequestOperation *operation = [self GET:GM_Delete_Fence_URL parameters:parameters dictBlock:optionDict errorBlock:optionError];
    return operation;
}


/**
 *  修改设备围栏参数
 *
 *  @param appID      appID description
 *  @param fenceID    fenceID description
 *  @param enable     enable description
 *  @param coord      coord description
 *  @param radius     radius description
 *  @param dictOption void (^GMNetworkOption)(NSDictionary *dict)
 *  @param errorBlock void (^GMNetworkError)(NSError *error)
 *
 *  @return GMHTTPRequestOperation
 */
- (GMHTTPRequestOperation *)modifyCircleFenceWithAppID:(NSString *)appID
                                               fenceID:(NSString *)fenceID
                                                enable:(BOOL)enable
                                             threshold:(NSUInteger)threshold
                                               mapType:(NSString *)mapType
                                             fenceName:(NSString *)fenceName
                                                 coord:(CLLocationCoordinate2D)coord
                                                radius:(CGFloat)radius
                                               devinfo:(NSString *)devinfo
                                             withBlock:(GMOptionDict)optionDict
                                      withFailureBlock:(GMOptionError)optionError
{
    if (appID.length == 0 || fenceID.length == 0 || coord.latitude == 0 || radius == 0) return nil;
    NSString *area = [NSString stringWithFormat:@"%.6f,%.6f,%.f",coord.latitude,coord.longitude,radius];
    NSDictionary *parameters = [GMTool parameters:appID
                                          fenceId:fenceID
                                            shape:@1
                                        threshold:@(threshold)
                                              are:area
                                           enable:@(enable)
                                          mapType:mapType
                                        fenceName:fenceName
                                          devInfo:devinfo];
    GMHTTPRequestOperation *operation = [self POST:GM_Modify_Fence_URL parameters:parameters dictBlock:optionDict errorBlock:optionError];
    return operation;
}

- (GMHTTPRequestOperation *)modifyPolygonFenceWithAppID:(NSString *)appID
                                                fenceID:(NSString *)fenceID
                                                 enable:(BOOL)enable
                                              threshold:(NSUInteger)threshold
                                                mapType:(NSString *)mapType
                                              fenceName:(NSString *)fenceName
                                            polygonArea:(NSString *)area
                                                devinfo:(NSString *)devinfo
                                              withBlock:(GMOptionDict)optionDict
                                       withFailureBlock:(GMOptionError)optionError
{
    if (appID.length == 0 || fenceID.length == 0 || area.length == 0) return nil;
    NSDictionary *parameters = [GMTool parameters:appID
                                          fenceId:fenceID
                                            shape:@2
                                        threshold:@(threshold)
                                              are:area
                                           enable:@(enable)
                                          mapType:mapType
                                        fenceName:fenceName
                                          devInfo:devinfo];
    GMHTTPRequestOperation *operation = [self POST:GM_Modify_Fence_URL parameters:parameters dictBlock:optionDict errorBlock:optionError];
    return operation;

}

//TODO: 9.02添加
- (GMHTTPRequestOperation *)modifyFenceWithAppid:(NSString *)appid
                                         fenceid:(NSString *)fenceid
                                          enable:(BOOL)enable
                                      completion:(GMOptionDict)optionDict
                                         failure:(GMOptionError)optionError
{
    if (appid.length == 0 || fenceid.length == 0) {
        optionDict(nil);
        return nil;
    }
    NSDictionary *parameters = [GMTool parameters:appid
                                          fenceId:fenceid
                                            shape:nil
                                        threshold:nil
                                              are:nil
                                           enable:@(enable)
                                          mapType:nil
                                        fenceName:nil
                                          devInfo:nil];
    GMHTTPRequestOperation *operation = [self POST:GM_Modify_Fence_URL parameters:parameters dictBlock:optionDict errorBlock:optionError];
    return operation;
}

//TODO: 9.06添加
- (GMHTTPRequestOperation *)modifyFenceWithAppid:(NSString *)appid
                                         fenceid:(NSString *)fenceid
                                         devInfo:(NSString *)devInfo
                                      completion:(GMOptionDict)optionDict
                                         failure:(GMOptionError)optionError
{
    if (appid.length == 0 || fenceid.length == 0) {
        optionDict(nil);
        return nil;
    }
    NSDictionary *parameters = [GMTool parameters:appid
                                          fenceId:fenceid
                                            shape:nil
                                        threshold:nil
                                              are:nil
                                           enable:nil
                                          mapType:nil
                                        fenceName:nil
                                          devInfo:devInfo];
    GMHTTPRequestOperation *operation = [self POST:GM_Modify_Fence_URL parameters:parameters dictBlock:optionDict errorBlock:optionError];
    return operation;
}

//TODO: 9.06添加
- (GMHTTPRequestOperation *)modifyFenceWithAppid:(NSString *)appid
                                         fenceid:(NSString *)fenceid
                                       fenceName:(NSString *)fenceName
                                      completion:(GMOptionDict)optionDict
                                         failure:(GMOptionError)optionError
{
    if (appid.length == 0 || fenceid.length == 0) {
        optionDict(nil);
        return nil;
    }
    NSDictionary *parameters = [GMTool parameters:appid
                                          fenceId:fenceid
                                            shape:nil
                                        threshold:nil
                                              are:nil
                                           enable:nil
                                          mapType:nil
                                        fenceName:fenceName
                                          devInfo:nil];
    GMHTTPRequestOperation *operation = [self POST:GM_Modify_Fence_URL parameters:parameters dictBlock:optionDict errorBlock:optionError];
    return operation;
}

//TODO: 9.06添加
- (GMHTTPRequestOperation *)modifyFenceWithAppid:(NSString *)appid
                                         fenceid:(NSString *)fenceid
                                       threshold:(NSString *)threshold
                                      completion:(GMOptionDict)optionDict
                                         failure:(GMOptionError)optionError
{
    if (appid.length == 0 || fenceid.length == 0) {
        optionDict(nil);
        return nil;
    }
    NSDictionary *parameters = [GMTool parameters:appid
                                          fenceId:fenceid
                                            shape:nil
                                        threshold:@([threshold integerValue])
                                              are:nil
                                           enable:nil
                                          mapType:nil
                                        fenceName:nil
                                          devInfo:nil];
    GMHTTPRequestOperation *operation = [self POST:GM_Modify_Fence_URL parameters:parameters dictBlock:optionDict errorBlock:optionError];
    return operation;
}

//TODO: 9.07添加
- (GMHTTPRequestOperation *)modifyFenceWithAppid:(NSString *)appid
                                         fenceid:(NSString *)fenceid
                                            area:(NSString *)area
                                         mapType:(NSString *)mapType
                                      completion:(GMOptionDict)optionDict
                                         failure:(GMOptionError)optionError
{
    if (appid.length == 0 || fenceid.length == 0 || area.length == 0) {
        optionDict(nil);
        return nil;
    }
    NSNumber *shape = nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        area.length > 20 ? (shape = @2) : (shape = @1);
    }
    else {
        shape = [area containsString:@";"] ? @2 : @1;
    }
    NSDictionary *parameters = [GMTool parameters:appid
                                          fenceId:fenceid
                                            shape:shape
                                        threshold:nil
                                              are:area
                                           enable:nil
                                          mapType:mapType
                                        fenceName:nil
                                          devInfo:nil];
    GMHTTPRequestOperation *operation = [self POST:GM_Modify_Fence_URL parameters:parameters dictBlock:optionDict errorBlock:optionError];
    return operation;
}

#pragma mark - selfForLogin
- (GMHTTPRequestOperation *)logoutWithAppID:(NSString *)appID
                                   deviceID:(NSString *)deviceID
                                  channelid:(NSString *)channelid
                                  withBlock:(GMOptionDict)optionDict
                           withFailureBlock:(GMOptionError)optionError
{
    if (appID.length == 0 || deviceID.length == 0) return nil;
    NSDictionary *parameters = @{GM_Argument_appid      :appID,
                                 GM_Argument_account    :deviceID,
                                 GM_Argument_access_type:@"inner"};
    NSMutableDictionary *mParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    if (channelid.length != 0)  [mParameters setValue:channelid forKey:GM_Argument_cid];
    GMHTTPRequestOperation *operation = [self POST:GM_Logout_URL
                                        parameters:mParameters
                                         dictBlock:optionDict
                                        errorBlock:optionError];
    return operation;
}
//更新日期20150527
/**
 *  登录接口参数
 *
 *  @param appID      appID description
 *  @param deviceID    deviceID description
 *  @param signature     signature description通过MD5加密的token
 *  @param dictOption void (^GMNetworkOption)(NSDictionary *dict)
 *  @param errorBlock void (^GMNetworkError)(NSError *error)
 *
 *  @return GMHTTPRequestOperation
 */
- (GMHTTPRequestOperation *)loginWithAppID:(NSString *)appID
                                  deviceID:(NSString *)deviceID
                                 signature:(NSString *)signature
                                 channelid:(NSString *)channelid
                                   mapType:(NSString *)mapType
                                 withBlock:(GMOptionDict)optionDict
                          withFailureBlock:(GMOptionError)optionError
{
    if (appID.length == 0 || deviceID.length == 0) return nil;
    
    NSDictionary *parameters = @{GM_Argument_appid      :appID,
                                 GM_Argument_account    :deviceID,
                                 GM_Argument_time       :GM_CurrentTime,
                                 GM_Argument_access_type:@"inner",
                                 GM_Argument_platform   :@"ios",
                                 GM_Argument_lang       :[GMTool getSystemLangague],
                                 GM_Argument_timezone   :[NSString getNowDateTimezone]};
    NSMutableDictionary *mParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    if (signature.length != 0)  [mParameters setValue:signature forKey:GM_Argument_signature];
    if (channelid.length != 0)  [mParameters setValue:channelid forKey:GM_Argument_cid];
    if (mapType.length   != 0)  [mParameters setValue:mapType forKey:GM_Argument_map_type];
    GMHTTPRequestOperation *operation = [self POST:GM_Login_URL
                                        parameters:mParameters
                                         dictBlock:optionDict
                                        errorBlock:optionError];
    return operation;
}

//http: //open-dev.gpsoo.net/1/device/login?appid=23&account=1212&time=1438249165&access_type=inner&signature=95bc32774daa33d196a1d972d0ce31e4
//TODO RegisterWithAppID
- (GMHTTPRequestOperation *)registerWithAppID:(NSString *)appID
                                         udid:(NSString *)udid
                                  deviceToken:(NSData *)deviceToken
                                 successBlock:(GMOptionDict)optionDict
                                 failureBlock:(GMOptionError)optionError
{
    if (appID.length == 0 || udid.length == 0 || deviceToken == nil) return nil;
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:[GMTool iPhoneDeviceInfo] options:NSJSONWritingPrettyPrinted error:&error];
    NSString *devinfo = nil;
    if (!error) devinfo = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSDictionary *parameters = @{GM_Argument_appid      :appID,
                                 GM_Argument_fingerprint:udid,//唯一标识使用的key是devid,虽然不合理,容易产生误解
                                 GM_Argument_platform   :@"ios",
                                 GM_Argument_apnsToken  :deviceToken};
    NSMutableDictionary *mParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    if (devinfo.length != 0) [mParameters setValue:devinfo forKey:GM_Argument_devinfo];
    GMHTTPRequestOperation *operation = [self POST:GM_APNS_Provider_URL parameters:mParameters dictBlock:optionDict errorBlock:optionError];
    return operation;

}

- (GMHTTPRequestOperation *)updatePushTypeWithAppID:(NSString *)appID
                                           deviceID:(NSString *)deviceID
                                          channelid:(NSString *)channelid
                                               lang:(NSString *)lang
                                          alarmType:(NSString *)alarmType
                                           timeZone:(NSNumber *)timeZone
                                              sound:(NSNumber *)sound
                                              shake:(NSNumber *)shake
                                          startTime:(NSNumber *)startTime
                                            endTime:(NSNumber *)endTime
                                            mapType:(NSString *)mapType
                                       successBlock:(GMOptionDict)optionDict
                                       failureBlock:(GMOptionError)optionError
{
    if (appID.length == 0 || deviceID.length == 0 || channelid.length == 0) return nil;
    NSDictionary *parameters = [GMTool parametersWithAppid:appID
                                                     devid:deviceID
                                                 channelid:channelid
                                                      lang:lang
                                                 alarmType:alarmType
                                                  timeZone:timeZone
                                                     sound:sound
                                                     shake:shake
                                                 startTime:startTime
                                                   endTime:endTime
                                                   mapType:mapType];
    GMHTTPRequestOperation *operation = [self POST:GM_UpdatePushType_URL parameters:parameters dictBlock:optionDict errorBlock:optionError];
    return operation;
}

- (GMHTTPRequestOperation *)acquirePushInfoWithAppID:(NSString *)appID
                                               devid:(NSString *)deviceID
                                           channelid:(NSString *)channelid
                                        successBlock:(GMOptionDict)optionDict
                                        failureBlock:(GMOptionError)optionError
{
    if (appID.length == 0 || deviceID.length == 0 || channelid.length == 0) return nil;
    NSDictionary *parameters = @{GM_Argument_appid :    appID,
                                 GM_Argument_account :  deviceID,
                                 GM_Argument_cid :      channelid};
    GMHTTPRequestOperation *operation = [self POST:GM_GetPushInfo_URL parameters:parameters dictBlock:optionDict errorBlock:optionError];
    return operation;
}


- (GMHTTPRequestOperation *)acquireAlarmInfoWithAppID:(NSString *)appID
                                             deviceID:(NSString *)deviceID
                                               typeId:(NSString *)typeId
                                               pageNo:(NSNumber *)pageno
                                             pageSize:(NSNumber *)pageSize
                                              mapType:(NSString *)mapType
                                            withBlock:(GMOptionDict)optionDict
                                     withFailureBlock:(GMOptionError)optionError
{
    if (appID.length == 0 || deviceID.length == 0 ) return nil;
    NSDictionary *parameters = @{GM_Argument_appid:appID,
                                 GM_Argument_devid:deviceID};
    NSMutableDictionary *mParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    if (typeId.length != 0) [mParameters setValue:typeId forKey:GM_Argument_typeid];
    if (pageno != nil)      [mParameters setValue:pageno forKey:GM_Argument_pageno];
    if (pageSize != nil)    [mParameters setValue:pageSize forKey:GM_Argument_pagesize];
    if (mapType.length != 0)[mParameters setValue:mapType forKey:GM_Argument_map_type];
    GMHTTPRequestOperation *operation = [self POST:GM_GetAlarm_URL parameters:mParameters dictBlock:optionDict errorBlock:optionError];
    return operation;
}

- (GMHTTPRequestOperation *)reverseGecodeWithAppID:(NSString *)appID
                                      reverseArray:(NSArray *)array
                                           mapType:(NSString *)mapType
                                      successBlock:(GMOptionDict)optionDict
                                      failureBlock:(GMOptionError)optionError
{
    if (appID.length == 0 || array.count == 0 ) return nil;
    NSDictionary *parameters = @{GM_Argument_appid : appID,
                                 GM_Argument_data  : array};//
    NSMutableDictionary *mParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
//    if (mapType.length != 0) [mParameters setValue:mapType forKey:GM_Argument_map_type];
    __autoreleasing NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:mParameters options:NSJSONWritingPrettyPrinted error:&error];
    if (error) return nil;
    NSString *dict = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    GMHTTPRequestOperation *operation = [self POST:GM_ReverseGecode_URL parameters:dict dictBlock:optionDict errorBlock:optionError];
    return operation;
}

@end




