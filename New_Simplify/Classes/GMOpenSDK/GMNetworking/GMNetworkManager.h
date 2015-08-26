//
//  GMNetworkManager.h
//  GMOpenSDK
//
//  Created by Kowloon on 15/6/17.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import "GMManager.h"
#import <CoreLocation/CoreLocation.h>
#import "GMNetworking.h"
#import "GMDevice.h"



@interface GMNetworkManager : GMManager

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
                     errorBlock:(GMOptionError)optionError;
/**
 *  对GMHTTPRequestOperationManager的POST封装
 *
 *  @param url         url ?前面的一部分，eg:https: //www.baidu.com/s  ?wd=textfield
 *  @param parameters  parameters description
 *  @param optionDict  void (^GMNetworkOption)(NSDictionary *dict)
 *  @param errorOption void (^GMNetworkError)(NSError *error)#optionError description#>
 *
 *  @return GMHTTPRequestOperation
 */
- (GMHTTPRequestOperation *)POST:(NSString *)url
                      parameters:(id)parameters
                       dictBlock:(GMOptionDict)optionDict
                      errorBlock:(GMOptionError)optionError;
@end


#pragma mark - GMNetworkManagerForBasicInformation
@interface GMNetworkManager (GMNetworkManagerForBasicInformation)
/**
 *  设备接入及位置信息上传 GOOME_Setloc
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
                                              withFailureBlock:(GMOptionError)optionError;

//更新日期:2015.04.15.10:36
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
                                              withFailureBlock:(GMOptionError)optionError;

//TODO:7.27更新
- (GMHTTPRequestOperation *)uploadMyOwnDeviceLocationWithAppID:(NSString *)appID
                                                        device:(id<GMDevice>)device
                                                       mapType:(NSString *)mapType
                                                     withBlock:(GMOptionDict)optionDict
                                              withFailureBlock:(GMOptionError)optionError;

//更新日期:2015.04.10.15:10
/**
 *  1、设备接入及位置信息上传(批量信息上传)
 *  2、devIDs 一个数组，里面存储模型，但这个模型必须遵行GMGoomeOpenBasicInfo协议
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
                                               withFailureBlock:(GMOptionError)optionError;

/**
 *  历史位置信息获取 GOOME_GetHisloc
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
                                                      withFailureBlock:(GMOptionError)optionError;


//更新日期:2015.04.09.18:10
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
                                                     withFailureBlock:(GMOptionError)optionError;
//更新日期:2015.04.09.18:10
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
                                                     withFailureBlock:(GMOptionError)optionError;

//2015.04.10 16:45
/**
 *  附近设备位置信息获取
 *
 *  @param appID       appID description
 *  @param devID       devID 设备号
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
                                               withFailureBlock:(GMOptionError)optionError;
@end



#pragma mark - GMNetworkManagerForFence
@interface GMNetworkManager (GMNetworkManagerForFence)

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
                                         andFailureBlock:(GMOptionError)optionError;

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
                                           andFailureBlock:(GMOptionError)optionError;


/**
 *  POST请求,创建一个设备的围栏(默认使用圆形围栏),报警阈值默认使用3
 *
 *  @param devID       devID description
 *  @param appID       appID description
 *  @param enable     enable 默认使用YES 0：关闭，1：开启
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
                                       andFailureBlock:(GMOptionError)OptionError;

/**
 *  POST请求,创建一个设备的围栏(使用圆形围栏)
 *
 *  @param devIDs       devIDs devid数组
 *  @param appID       appID description
 *  @param enable     enable 默认使用YES 0：关闭，1：开启
 *  @param threshold   threshold description
 *  @param getIn       getIn description
 *  @param getOut      getOut description
 *  @param mapType     mapType description
 *  @param coord       coord 经纬度
 *  @param radius      radius 围栏半径
 *  @param option      void (^GMNetworkOption)(NSDictionary *dict)
 *  @param errorOption void (^GMNetworkError)(NSError *error)
 */
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
                                        andFailureBlock:(GMOptionError)OptionError;
/**
 *  POST请求,创建一个设备的围栏(使用多边形围栏)
 *
*  @param devIDs       devIDs devid数组
 *  @param appID       appID description
 *  @param enable      enable 默认使用YES 0：关闭，1：开启
 *  @param threshold   threshold description
 *  @param getIn       getIn description
 *  @param getOut      getOut description
 *  @param mapType     mapType description
 *  @param area        area description
 *  @param optionDict  optionDict description
 *  @param OptionError OptionError description
 *
 */
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
                                         andFailureBlock:(GMOptionError)OptionError;

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
                                             withBlock:(GMOptionDict)dictOption
                                         withFailBlock:(GMOptionError)errorBlock;



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
                                      withFailureBlock:(GMOptionError)optionError;

- (GMHTTPRequestOperation *)modifyPolygonFenceWithAppID:(NSString *)appID
                                                fenceID:(NSString *)fenceID
                                                 enable:(BOOL)enable
                                              threshold:(NSUInteger)threshold
                                                mapType:(NSString *)mapType
                                              fenceName:(NSString *)fenceName
                                            polygonArea:(NSString *)area
                                                devinfo:(NSString *)devinfo
                                              withBlock:(GMOptionDict)optionDict
                                       withFailureBlock:(GMOptionError)optionError;
@end

#pragma mark - GMNetworkManagerForLogin
@interface GMNetworkManager (GMNetworkManagerForLogin)
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
                          withFailureBlock:(GMOptionError)optionError;

/**
 *  注销该设备，比如：注销之后，就不再收到围栏报警消息
 *
 */
- (GMHTTPRequestOperation *)logoutWithAppID:(NSString *)appID
                                   deviceID:(NSString *)deviceID
                                  channelid:(NSString *)channelid
                                  withBlock:(GMOptionDict)optionDict
                           withFailureBlock:(GMOptionError)optionError;

@end


#pragma mark - GMNetworkManagerForRegister
@interface GMNetworkManager (GMNetworkManagerForRegister)

/**
 *  设备唯一标识注册，获取唯一通道id
 *
 *  @param udid        设备唯一表示，比如openUDID
 *  @param deviceToken 远程获取的token
 */
- (GMHTTPRequestOperation *)registerWithAppID:(NSString *)appID
                                         udid:(NSString *)udid
                                  deviceToken:(NSData *)deviceToken
                                 successBlock:(GMOptionDict)optionDict
                                 failureBlock:(GMOptionError)optionError;
@end


#pragma mark - GMNetworkManagerForAlarm
@interface GMNetworkManager (GMNetworkManagerForAlarm)

/**
 *  获取报警围栏信息
 *
 */
- (GMHTTPRequestOperation *)acquireAlarmInfoWithAppID:(NSString *)appID
                                             deviceID:(NSString *)deviceID
                                               typeId:(NSString *)typeId
                                               pageNo:(NSNumber *)pageno
                                             pageSize:(NSNumber *)pageSize
                                              mapType:(NSString *)mapType
                                            withBlock:(GMOptionDict)optionDict
                                     withFailureBlock:(GMOptionError)optionError;
@end

#pragma mark - GMNetworkManagerForPush
@interface GMNetworkManager (GMNetworkManagerForPush)

/**
 *  设置推送的格式
 *
 */
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
                                       failureBlock:(GMOptionError)optionError;

/**
 *  获取当前推送的格式信息
 *
 */
- (GMHTTPRequestOperation *)acquirePushInfoWithAppID:(NSString *)appID
                                               devid:(NSString *)deviceID
                                           channelid:(NSString *)channelid
                                        successBlock:(GMOptionDict)optionDict
                                        failureBlock:(GMOptionError)optionError;
@end

#pragma mark - GMNetworkManagerForReverseGecode
@interface GMNetworkManager (GMNetworkManagerForReverseGecode)

/**
 *  地理位置反编码
 *
 */
- (GMHTTPRequestOperation *)reverseGecodeWithAppID:(NSString *)appID
                                      reverseArray:(NSArray *)array
                                           mapType:(NSString *)mapType
                                      successBlock:(GMOptionDict)optionDict
                                      failureBlock:(GMOptionError)optionError;

@end


