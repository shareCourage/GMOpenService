//
//  GMTool.m
//  GMOpenSDK
//
//  Created by Kowloon on 15/6/18.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import "GMTool.h"
#import <objc/runtime.h>
#import "GMConstant.h"

@implementation GMTool

+ (NSString *)mapType:(GMMapType)mt
{
    NSString *mapType = nil;
    switch (mt) {
        case GMMapTypeOfNone:
            break;
        case GMMapTypeOfBAIDU:
            mapType = @"BAIDU";
            break;
        case GMMapTypeOfGOOGLE:
            mapType = @"GOOGLE";
            break;
        case GMMapTypeOfGAODE:
            mapType = @"GOOGLE";
            break;
        default:
            break;
    }
    return mapType;
}
+ (NSString *)devidinfos:(NSArray *)devids getIn:(BOOL)getIn getOut:(BOOL)getOut
{
    NSString *devInfos = nil;
    int i = 1;
    for (NSString *devid in devids) {
        NSString *devInfo = [NSString stringWithFormat:@"%@,%d,%d",devid,getIn,getOut];
        if (i == 1) {
            devInfos = devInfo;
        }
        else{
            NSString *aaaa = [@";" stringByAppendingString:devInfo];
            devInfos = [devInfos stringByAppendingString:aaaa];
        }
        i ++;
    }
    return devInfos;
}
+ (NSString *)stringConnected:(NSArray *)array connectString:(NSString *)connectStr
{
    NSString *string = nil;
    int i = 1;
    for (NSString *devID in array) {
        if (i == 1) {
            string = devID;
        }
        else{
            NSString *aaaa = [connectStr stringByAppendingString:devID];
            string = [string stringByAppendingString:aaaa];
        }
        i --;
    }
    return string;
}

+ (NSString *)polygonArea:(CLLocationCoordinate2D *)coords count:(NSUInteger)count
{
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < count; i ++) {
        CLLocationCoordinate2D coord = coords[i];
        NSString *coordStr = [NSString stringWithFormat:@"%.6f,%.6f",coord.latitude, coord.longitude];
        [array addObject:coordStr];
    }
    NSString *polygon = [GMTool stringConnected:array connectString:@";"];
    
    return polygon;
}

+ (NSString *)getSystemLangague
{
    NSArray *languages      = [NSLocale preferredLanguages];
    NSString *curLanguage   = [languages firstObject];//zh+Hans简体中文 en英文 繁体 zh+Hant 香港 zh+HK
    NSRange range = [curLanguage rangeOfString:@"zh"];
    if (range.length != NSNotFound) return @"zh+CN";
    return @"en";
}
+ (BOOL)getVariableWithClass:(Class)myClass varName:(NSString *)name
{
    unsigned int outCount, i;
    Ivar *ivars = class_copyIvarList(myClass, &outCount);
    for (i = 0; i < outCount; i++) {
        Ivar property = ivars[i];
        NSString *keyName = [NSString stringWithCString:ivar_getName(property) encoding:NSUTF8StringEncoding];
        NSRange range = NSMakeRange(1, keyName.length + 1);
//        keyName = [keyName stringByReplacingOccurrencesOfString:@"_" withString:@""];
        keyName = [keyName substringWithRange:range];
        if ([keyName isEqualToString:name]) {
            return YES;
        }
    }
    return NO;
}


+ (NSDictionary *)iPhoneDeviceInfo
{
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    NSString *appVersion    = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    UIDevice *myDevice      = [UIDevice currentDevice];
    NSString *deviceName    = myDevice.name;
    NSString *deviceModel   = [NSString iPhoneDeviceNumber];//myDevice.model;
    NSString *sysName       = myDevice.systemName;
    NSString *sysVersion    = myDevice.systemVersion;
    NSArray *languages      = [NSLocale preferredLanguages];
    NSString *curLanguage   = [languages firstObject];//zh+Hans简体中文 en英文
    if (appVersion.length != 0)  [mDict setValue:appVersion  forKey:@"appVersion"];
    if (deviceName.length != 0)  [mDict setValue:deviceName  forKey:@"deviceName"];
    if (deviceModel.length != 0) [mDict setValue:deviceModel forKey:@"deviceModel"];
    if (sysName.length != 0)     [mDict setValue:sysName     forKey:@"deviceSystemName"];
    if (sysVersion.length != 0)  [mDict setValue:sysVersion  forKey:@"deviceSystemVersion"];
    if (curLanguage.length != 0) [mDict setValue:curLanguage forKey:@"language"];
    return mDict;
}

#pragma mark +  NSMutableDictionary
+ (NSDictionary *)parameters:(NSString *)appid
                    deviceId:(NSString *)deviceId
                   beginTime:(NSString *)begintime
                     endTime:(NSString *)endTime
                     mapType:(NSString *)mapType
                 numberLimit:(NSString *)limit
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (appid.length != 0) {
        [parameters setObject:appid forKey:GM_Argument_appid];
    }
    if (deviceId.length != 0) {
        [parameters setObject:deviceId forKey:GM_Argument_devid];
    }
    if (begintime.length != 0) {
        [parameters setObject:begintime forKey:GM_Argument_begin_time];
    }
    if (endTime.length != 0) {
        [parameters setObject:endTime forKey:GM_Argument_end_time];
    }
    if (mapType.length != 0) {
        [parameters setObject:mapType forKey:GM_Argument_map_type];
    }
    if (limit.length != 0) {
        [parameters setObject:limit forKey:GM_Argument_limit];
    }
    return parameters;
}

+ (NSDictionary *)parameters:(NSString *)appid
                    deviceId:(NSString *)deviceId
                     fenceId:(NSString *)fenceId
                     mapType:(NSString *)mapType
{
    return [self parameters:appid deviceId:deviceId fenceId:fenceId distance:nil mapType:mapType tags:nil];
}
+ (NSDictionary *)parameters:(NSString *)appid
                    deviceId:(NSString *)deviceId
                     fenceId:(NSString *)fenceId
                    distance:(NSString *)distance
                     mapType:(NSString *)mapType
                        tags:(NSDictionary *)tags
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (appid.length != 0) {
        [parameters setObject:appid forKey:GM_Argument_appid];
    }
    if (deviceId.length != 0) {
        [parameters setObject:deviceId forKey:GM_Argument_devid];
    }
    if (fenceId.length != 0) {
        [parameters setObject:fenceId forKey:GM_Argument_fenceid];
    }
    if (distance.length != 0) {
        [parameters setObject:distance forKey:GM_Argument_distance];
    }
    if (mapType.length != 0) {
        [parameters setObject:mapType forKey:GM_Argument_map_type];
    }
    
    if (tags.count != 0) {
        for (NSString *key in tags) {
            if ([key isEqualToString:GM_Argument_tag1]) {
                [parameters setObject:[tags objectForKey:key] forKey:GM_Argument_tag1];
            }
            else if ([key isEqualToString:GM_Argument_tag2]) {
                [parameters setObject:[tags objectForKey:key] forKey:GM_Argument_tag2];
            }
            else if ([key isEqualToString:GM_Argument_tag3]) {
                [parameters setObject:[tags objectForKey:key] forKey:GM_Argument_tag3];
            }
        }
    }
    return parameters;
}
+ (NSDictionary *)parameters:(NSString *)appid
                       shape:(NSNumber *)shape
                   threshold:(NSNumber *)threshold
                         are:(NSString *)area
                      enable:(NSNumber *)enable
                     mapType:(NSString *)mapType
                   fenceName:(NSString *)fenceName
                     devInfo:(NSString *)devInfo
{
    return [self parameters:appid fenceId:nil shape:shape threshold:threshold are:area enable:enable mapType:mapType fenceName:fenceName devInfo:devInfo];
}
+ (NSDictionary *)parameters:(NSString *)appid
                     fenceId:(NSString *)fenceId
                       shape:(NSNumber *)shape
                   threshold:(NSNumber *)threshold
                         are:(NSString *)area
                      enable:(NSNumber *)enable
                     mapType:(NSString *)mapType
                   fenceName:(NSString *)fenceName
                     devInfo:(NSString *)devInfo
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (appid.length != 0) {
        [parameters setObject:appid forKey:GM_Argument_appid];
    }
    if (fenceId.length != 0) {
        [parameters setObject:fenceId forKey:GM_Argument_fenceid];
    }
    if (shape) {
        [parameters setObject:shape forKey:GM_Argument_shape];
    }
    if (threshold) {
        [parameters setObject:threshold forKey:GM_Argument_threshold];
    }
    if (area.length != 0) {
        [parameters setObject:area forKey:GM_Argument_area];
    }
    if (enable) {
        [parameters setObject:enable forKey:GM_Argument_enable];
    }
    if (mapType.length != 0) {
        [parameters setObject:mapType forKey:GM_Argument_map_type];
    }
    if (fenceName.length != 0) {
        [parameters setObject:fenceName forKey:GM_Argument_fenceName];
    }
    if (devInfo.length != 0) {
        [parameters setObject:devInfo forKey:GM_Argument_devinfo];
    }
    return parameters;
}
//TODO: 7.27添加
+ (NSMutableDictionary *)deviceParameters:(id<GMDevice>)device
{
    NSMutableDictionary *mpara =    [NSMutableDictionary dictionary];
    //devid
    if ([GMTool getVariableWithClass:[device class] varName:GM_Argument_devid]) {
        if (device.devid.length != 0)   [mpara setObject:device.devid forKey:GM_Argument_devid];
    }
    
    //gps_time
    if ([GMTool getVariableWithClass:[device class] varName:GM_Argument_gps_time]) {
        if (device.gps_time.length != 0){
            NSNumber *number = [NSNumber numberWithDouble:[device.gps_time doubleValue]];
            [mpara setObject:number forKey:GM_Argument_gps_time];
        }
    }
    
    //lat
    if ([GMTool getVariableWithClass:[device class] varName:GM_Argument_lat]) {
        if (device.lat.length != 0) {
            NSNumber *number = [NSNumber numberWithDouble:[device.lat doubleValue]];
            [mpara setObject:number forKey:GM_Argument_lat];
        }
        else {
            [mpara setObject:@0 forKey:GM_Argument_lat];
        }
    }
    
    //lng
    if ([GMTool getVariableWithClass:[device class] varName:GM_Argument_lng]) {
        if (device.lng.length != 0) {
            NSNumber *number = [NSNumber numberWithDouble:[device.lng doubleValue]];
            [mpara setObject:number forKey:GM_Argument_lng];
        }
        else {
            [mpara setObject:@0 forKey:GM_Argument_lng];
        }
    }
    
    
    //speed
    if ([GMTool getVariableWithClass:[device class] varName:GM_Argument_speed]) {
        if (device.speed.length != 0) {
            NSNumber *number = [NSNumber numberWithDouble:[device.speed doubleValue]];
            [mpara setObject:number forKey:GM_Argument_speed];
        }
        else {
            [mpara setObject:@0 forKey:GM_Argument_speed];
        }
    }
    
    
    //course
    if ([GMTool getVariableWithClass:[device class] varName:GM_Argument_course]) {
        if (device.course.length != 0) {
            NSNumber *number = [NSNumber numberWithDouble:[device.course doubleValue]];
            [mpara setObject:number forKey:GM_Argument_course];
        }
        else {
            [mpara setObject:@0 forKey:GM_Argument_course];
        }
    }
    
    
    //tag1,2,3
    if ([GMTool getVariableWithClass:[device class] varName:GM_Argument_tag1]) {
        if (device.tag1.length != 0) [mpara setObject:device.tag1 forKey:GM_Argument_tag1];
    }
    if ([GMTool getVariableWithClass:[device class] varName:GM_Argument_tag2]) {
        if (device.tag2.length != 0) [mpara setObject:device.tag2 forKey:GM_Argument_tag2];
    }
    if ([GMTool getVariableWithClass:[device class] varName:GM_Argument_tag3]) {
        if (device.tag3.length != 0) [mpara setObject:device.tag3 forKey:GM_Argument_tag3];
    }
    
    return mpara;
}
@end




