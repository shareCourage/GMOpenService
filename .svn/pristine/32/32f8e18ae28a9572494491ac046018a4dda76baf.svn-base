//
//  GMDeviceInfo.h
//  GMOpenSDK
//
//  Created by Kowloon on 15/6/24.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMDevice.h"
@interface GMDeviceInfo : NSObject <GMDevice, NSCoding>

@property (nonatomic, copy) NSString *lat;//经度
@property (nonatomic, copy) NSString *lng;//纬度
@property (nonatomic, copy) NSString *course;//方向
@property (nonatomic, copy) NSString *gps_time;//时间
@property (nonatomic, copy) NSString *speed;//速度
@property (nonatomic, copy) NSString *devid;//设备号

@property (nonatomic, copy) NSString *server_time;
@property (nonatomic, copy) NSString *sys_time;
@property (nonatomic, copy) NSString *heart_time;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
