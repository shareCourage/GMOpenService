//
//  PHDeviceInfo.m
//  SimplifiedApp
//
//  Created by Kowloon on 15/4/27.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import "PHDeviceInfo.h"
#import <MJExtension.h>
@implementation PHDeviceInfo
+ (instancetype)createDeviceWithDict:(NSDictionary *)dict
{
    if (!dict) return nil;
    PHDeviceInfo *device = [[PHDeviceInfo alloc] initWithDict:dict];
    return device;
}
- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self = [PHDeviceInfo objectWithKeyValues:dict];
    }
    return self;
}

@end
