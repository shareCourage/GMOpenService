//
//  GMDeviceInfo.m
//  GMOpenSDK
//
//  Created by Kowloon on 15/6/24.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import "GMDeviceInfo.h"
#import <objc/runtime.h>
#import "GMConstant.h"

@implementation GMDeviceInfo

GMCodingImplementation

- (void)dealloc
{
    GMLog(@"%@->dealloc",NSStringFromClass([self class]));
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        if (dict.count != 0) {
            _course       = [NSString stringWithFormat:@"%@",dict[GM_Argument_course]];
            _speed        = [NSString stringWithFormat:@"%@",dict[GM_Argument_speed]];
            _gps_time     = [NSString stringWithFormat:@"%@",dict[GM_Argument_gps_time]];
            _lat          = [NSString stringWithFormat:@"%@",dict[GM_Argument_lat]];
            _lng          = [NSString stringWithFormat:@"%@",dict[GM_Argument_lng]];
            _devid        = [NSString stringWithFormat:@"%@",dict[GM_Argument_devid] ? dict[GM_Argument_devid] : nil];
            _server_time  = [NSString stringWithFormat:@"%@",dict[@"server_time"] ? dict[@"server_time"] : nil];
            _sys_time     = [NSString stringWithFormat:@"%@",dict[@"sys_time"] ? dict[@"sys_time"] : nil];
            _heart_time   = [NSString stringWithFormat:@"%@",dict[@"heart_time"] ? dict[@"heart_time"] : nil];
        }
    }
    return self;
}

@end


@implementation GMGeocodeResult

GMCodingImplementation

- (void)dealloc
{
    GMLog(@"%@->dealloc",NSStringFromClass([self class]));
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        _address = [NSString stringWithFormat:@"%@",dict[GM_Argument_address]];
        NSString *lat = [NSString stringWithFormat:@"%@",dict[GM_Argument_lat]];
        NSString *lng = [NSString stringWithFormat:@"%@",dict[GM_Argument_lng]];
        _location = CLLocationCoordinate2DMake([lat doubleValue], [lng doubleValue]);
    }
    return self;
}

@end

