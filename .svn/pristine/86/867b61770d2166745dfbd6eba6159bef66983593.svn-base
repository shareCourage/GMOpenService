//
//  GMAlarmInfo.m
//  New_Simplify
//
//  Created by Kowloon on 15/8/13.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import "GMAlarmInfo.h"
#import <objc/runtime.h>
@implementation GMAlarmInfo

- (instancetype)initWithArray:(NSArray *)array
{
    self = [super init];
    if (self) {
        _alarmId = [NSString stringWithFormat:@"%@",array[0]];
        _typeId  = [NSString stringWithFormat:@"%@",array[1]];
        _gpsTime = [NSString stringWithFormat:@"%@",array[2]];
        _lng     = [NSString stringWithFormat:@"%@",array[3]];
        _lat     = [NSString stringWithFormat:@"%@",array[4]];
        _speed   = [NSString stringWithFormat:@"%@",array[5]];
        _course  = [NSString stringWithFormat:@"%@",array[6]];
        _status  = [NSString stringWithFormat:@"%@",array[7]];
        _alartTime  = [NSString stringWithFormat:@"%@",array[8]];
        _fenceId = [NSString stringWithFormat:@"%@",array[9]];

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



