//
//  PHDeviceInfo.h
//  SimplifiedApp
//
//  Created by Kowloon on 15/4/27.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface PHDeviceInfo : NSObject
/**
 *  course = 0;
 devid = 1234567890;
 "gps_time" = 1429594296;
 "heart_time" = 1429594295;
 lat = "22.555839";
 lng = "113.9272";
 "server_time" = 1430098229;
 speed = 0;
 "sys_time" = 1429587342;
 */
@property(nonatomic, strong)NSString *lat;
@property(nonatomic, strong)NSString *lng;
@property(nonatomic, strong)NSNumber *cource;
@property(nonatomic, strong)NSNumber *devid;
@property(nonatomic, strong)NSNumber *gps_time;
@property(nonatomic, strong)NSNumber *heart_time;
@property(nonatomic, strong)NSNumber *server_time;
@property(nonatomic, strong)NSNumber *speed;
@property(nonatomic, strong)NSNumber *sys_time;

+ (instancetype)createDeviceWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end





