//
//  GMPushInfo.m
//  New_Simplify
//
//  Created by Kowloon on 15/8/24.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import "GMPushInfo.h"
#import "GMConstant.h"
#import <objc/runtime.h>

@implementation GMPushInfo

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
            _alarmType  = [NSString stringWithFormat:@"%@",dict[GM_Argument_alarmtype]];
            _lang       = [NSString stringWithFormat:@"%@",dict[GM_Argument_lang]];
            _mapType    = [NSString stringWithFormat:@"%@",dict[GM_Argument_map_type]];
            _version    = [NSString stringWithFormat:@"%@",dict[GM_Argument_version]];
            _cid        = [NSString stringWithFormat:@"%@",dict[GM_Argument_cid]];
            _shake      = [NSString stringWithFormat:@"%@",dict[GM_Argument_shake]];
            _sound      = [NSString stringWithFormat:@"%@",dict[GM_Argument_sound]] ;
            _timeZone   = [NSString stringWithFormat:@"%@",dict[GM_Argument_timezone]];
            _startTime  = [NSString stringWithFormat:@"%@",dict[GM_Argument_start_time]];
            _endTime    = [NSString stringWithFormat:@"%@",dict[GM_Argument_end_time]];
        }
    }
    return self;
}


@end
