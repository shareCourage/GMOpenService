//
//  GMTool.h
//  GMOpenSDK
//
//  Created by Kowloon on 15/6/18.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@class GMManager;

@interface GMTool : NSObject

+ (NSString *)mapType:(GMMapType)mapType;

+ (NSString *)polygonArea:(CLLocationCoordinate2D *)coords count:(NSUInteger)count;

+ (NSArray *)coordinates:(CLLocationCoordinate2D *)coords count:(NSUInteger)count;
+ (NSArray *)coordinates:(CLLocationCoordinate2D *)coords count:(NSUInteger)count mapType:(NSString *)mapType;

+ (NSString *)getSystemLangague;//带zh的都转化成zh-CN，其它均为en

/**
 *  判断myClass类是否包含name属性
 *
 */
+ (BOOL)getVariableWithClass:(Class)myClass varName:(NSString *)name;

+ (NSString *)devidinfos:(NSArray *)devids getIn:(BOOL)getIn getOut:(BOOL)getOut;

+ (NSString *)stringConnected:(NSArray *)array connectString:(NSString *)connectStr;

+ (NSDictionary *)parameters:(NSString *)appid
                     fenceId:(NSString *)fenceId
                       shape:(NSNumber *)shape
                   threshold:(NSNumber *)threshold
                         are:(NSString *)area
                      enable:(NSNumber *)enable
                     mapType:(NSString *)mapType
                   fenceName:(NSString *)fenceName
                     devInfo:(NSString *)devInfo;

+ (NSDictionary *)parameters:(NSString *)appid
                       shape:(NSNumber *)shape
                   threshold:(NSNumber *)threshold
                         are:(NSString *)area
                      enable:(NSNumber *)enable
                     mapType:(NSString *)mapType
                   fenceName:(NSString *)fenceName
                     devInfo:(NSString *)devInfo;

+ (NSDictionary *)parameters:(NSString *)appid
                    deviceId:(NSString *)deviceId
                     fenceId:(NSString *)fenceId
                    distance:(NSString *)distance
                     mapType:(NSString *)mapType
                        tags:(NSDictionary *)tags;

+ (NSDictionary *)parameters:(NSString *)appid
                    deviceId:(NSString *)deviceId
                     fenceId:(NSString *)fenceId
                     mapType:(NSString *)mapType;

+ (NSDictionary *)parameters:(NSString *)appid
                    deviceId:(NSString *)deviceId
                   beginTime:(NSString *)begintime
                     endTime:(NSString *)endTime
                     mapType:(NSString *)mapType
                 numberLimit:(NSString *)limit;

+ (NSDictionary *)parametersWithAppid:(NSString *)appid
                                devid:(NSString *)devid
                            channelid:(NSString *)channelid
                                 lang:(NSString *)lang
                            alarmType:(NSString *)alarmType
                             timeZone:(NSNumber *)timeZone
                                sound:(NSNumber *)sound
                                shake:(NSNumber *)shake
                            startTime:(NSNumber *)startTime
                              endTime:(NSNumber *)endTime
                              mapType:(NSString *)mapType;

+ (NSMutableDictionary *)deviceParameters:(id<GMDevice>)device;


+ (NSDictionary *)iPhoneDeviceInfo;

/**
 *  获取设备唯一标识方法
 *  1、通过GMOpenUDID获取设备的唯一标识
 *  2、将这个标识添加到iOS的keyChain中
 *  3、
 */
+ (NSString *)getUniqueIdentifier;
@end







