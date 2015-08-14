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



- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        unsigned int outCount, i;
        Ivar *ivars = class_copyIvarList([self class], &outCount);
        for (i = 0; i < outCount; i++) {
            Ivar property = ivars[i];
            NSString *keyName = [NSString stringWithCString:ivar_getName(property) encoding:NSUTF8StringEncoding];
            id value = [aDecoder decodeObjectForKey:keyName];
            [self setValue:value forKey:keyName];
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    unsigned int outCount, i;
    Ivar *ivars = class_copyIvarList([self class], &outCount);
    for (i = 0; i < outCount; i++) {
        Ivar property = ivars[i];
        NSString *keyName = [NSString stringWithCString:ivar_getName(property) encoding:NSUTF8StringEncoding];
        id value = [self valueForKey:keyName];
        [aCoder encodeObject:value forKey:keyName];
    }
}
@end
