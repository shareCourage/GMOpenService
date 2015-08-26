//
//  GMAlarmInfo.m
//  New_Simplify
//
//  Created by Kowloon on 15/8/13.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import "GMAlarmInfo.h"
#import <objc/runtime.h>
#import "GMConstant.h"

@implementation GMAlarmInfo

GMCodingImplementation

- (void)dealloc
{
    GMLog(@"%@->dealloc",NSStringFromClass([self class]));
}

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


@end



