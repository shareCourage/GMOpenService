//
//  GMFenceInfo.m
//  New_Simplify
//
//  Created by Kowloon on 15/7/20.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import "GMFenceInfo.h"
#import <objc/runtime.h>
#import "GMConstant.h"
@implementation GMFenceInfo

GMCodingImplementation

- (void)dealloc
{
    GMLog(@"%@->dealloc",NSStringFromClass([self class]));
}

- (instancetype)initWithDeviceDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        if (dict.count != 0) {
            _devInOut          = [[GMDevInOut alloc] init];
            _area              = [NSString stringWithFormat:@"%@",dict[GM_Argument_area]];
            _devInOut.devid    = [NSString stringWithFormat:@"%@",dict[GM_Argument_devid]];
            _enable            = [NSString stringWithFormat:@"%@",dict[GM_Argument_enable]];
            _fenceid           = [NSString stringWithFormat:@"%@",dict[GM_Argument_fenceid]];
            _devInOut.dev_in   = [NSString stringWithFormat:@"%@",dict[GM_Argument_in]];
            _devInOut.dev_out  = [NSString stringWithFormat:@"%@",dict[GM_Argument_out]];
            _name              = [NSString stringWithFormat:@"%@",dict[GM_Argument_name]];
            _shape             = [NSString stringWithFormat:@"%@",dict[GM_Argument_shape]];
            _threshold         = [NSString stringWithFormat:@"%@",dict[GM_Argument_threshold]];
            _update_time       = [NSString stringWithFormat:@"%@",dict[GM_Argument_update_time]];
        }
    }
    return self;
}

- (instancetype)initWithFenceDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        if (dict.count != 0) {
            _area          = [NSString stringWithFormat:@"%@",dict[GM_Argument_area]];
            _enable        = [NSString stringWithFormat:@"%@",dict[GM_Argument_enable]];
            _fenceid       = [NSString stringWithFormat:@"%@",dict[GM_Argument_fenceid]];
            _name          = [NSString stringWithFormat:@"%@",dict[GM_Argument_name]];
            _shape         = [NSString stringWithFormat:@"%@",dict[GM_Argument_shape]];
            _threshold     = [NSString stringWithFormat:@"%@",dict[GM_Argument_threshold]];
            _update_time   = [NSString stringWithFormat:@"%@",dict[GM_Argument_update_time]];
            NSArray *devinfos = dict[GM_Argument_devinfo];
            if (devinfos.count != 0) {
                NSMutableArray *mArray  = [NSMutableArray array];
                for (NSDictionary *obj in devinfos) {
                    GMDevInOut *devInOut    = [[GMDevInOut alloc] init];
                    devInOut.devid          = [NSString stringWithFormat:@"%@",obj[GM_Argument_devid]];
                    devInOut.dev_in         = [NSString stringWithFormat:@"%@",obj[GM_Argument_in]];
                    devInOut.dev_out        = [NSString stringWithFormat:@"%@",obj[GM_Argument_out]];
                    [mArray addObject:devInOut];
                }
                _devinfos = [mArray copy];
            }
        }
    }
    return self;
}

#if 0
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
#endif

@end


@implementation GMDevInOut

GMCodingImplementation

- (void)dealloc
{
    GMLog(@"%@->dealloc",NSStringFromClass([self class]));
}

@end



