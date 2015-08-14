//
//  GMTool.h
//  GMOpenSDK
//
//  Created by Kowloon on 15/6/18.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "GMManager.h"

@interface GMTool : NSObject

+ (NSString *)mapType:(GMMapType)mapType;

+ (NSString *)polygonArea:(CLLocationCoordinate2D *)coords count:(NSUInteger)count;

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

+ (NSMutableDictionary *)deviceParameters:(id<GMDevice>)device;


+ (NSDictionary *)iPhoneDeviceInfo;
@end







