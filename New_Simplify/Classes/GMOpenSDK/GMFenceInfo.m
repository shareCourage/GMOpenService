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


- (void)dealloc
{
    GMLog(@"%@->dealloc",NSStringFromClass([self class]));
}
- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        if (dict.count != 0) {
            self.area              = [NSString stringWithFormat:@"%@",dict[GM_Argument_area]];
            self.enable            = [NSString stringWithFormat:@"%@",dict[GM_Argument_enable]];
            self.fenceid           = [NSString stringWithFormat:@"%@",dict[GM_Argument_fenceid]];
            self.name              = [NSString stringWithFormat:@"%@",dict[GM_Argument_name]];
            self.shape             = [NSString stringWithFormat:@"%@",dict[GM_Argument_shape]];
            self.threshold         = [NSString stringWithFormat:@"%@",dict[GM_Argument_threshold]];
            self.update_time       = [NSString stringWithFormat:@"%@",dict[GM_Argument_update_time]];
        }
    }
    return self;
}

#if 1
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.area       = [aDecoder decodeObjectForKey:GM_Argument_area];
        self.enable     = [aDecoder decodeObjectForKey:GM_Argument_enable];
        self.fenceid    = [aDecoder decodeObjectForKey:GM_Argument_fenceid];
        self.name       = [aDecoder decodeObjectForKey:GM_Argument_name];
        self.shape      = [aDecoder decodeObjectForKey:GM_Argument_shape];
        self.threshold  = [aDecoder decodeObjectForKey:GM_Argument_threshold];
        self.update_time = [aDecoder decodeObjectForKey:GM_Argument_update_time];

    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.area forKey:GM_Argument_area];
    [aCoder encodeObject:self.enable forKey:GM_Argument_enable];
    [aCoder encodeObject:self.fenceid forKey:GM_Argument_fenceid];
    [aCoder encodeObject:self.name forKey:GM_Argument_name];
    [aCoder encodeObject:self.shape forKey:GM_Argument_shape];
    [aCoder encodeObject:self.threshold forKey:GM_Argument_threshold];
    [aCoder encodeObject:self.update_time forKey:GM_Argument_update_time];

}
#endif
@end



@implementation GMDeviceFence

//GMCodingImplementation
- (void)dealloc
{
    GMLog(@"%@->dealloc",NSStringFromClass([self class]));
}
- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super initWithDict:dict];
    if (self) {
        if (dict.count != 0) {
            self.devInOut = [[GMDevInOut alloc] initWithDict:dict];
        }
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.devInOut = [aDecoder decodeObjectForKey:@"devInOutCoder"];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:_devInOut forKey:@"devInOutCoder"];
}
@end


@implementation GMNumberFence

- (void)dealloc
{
    GMLog(@"%@->dealloc",NSStringFromClass([self class]));
}
- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super initWithDict:dict];
    if (self) {
        NSArray *devinfos = dict[GM_Argument_devinfo];
        if (devinfos.count != 0) {
            NSMutableArray *mArray  = [NSMutableArray array];
            for (NSDictionary *obj in devinfos) {
                GMDevInOut *devInOut    = [[GMDevInOut alloc] initWithDict:obj];
                [mArray addObject:devInOut];
            }
            _devinfos = [mArray copy];
        }
    }
    return self;
}
#warning 这里实现的NSCoding协议还需要完善数组
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
}
@end


@implementation GMDevInOut

GMCodingImplementation

- (void)dealloc
{
    GMLog(@"%@->dealloc",NSStringFromClass([self class]));
}
- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        _devid = [NSString stringWithFormat:@"%@",dict[GM_Argument_devid]];
        _dev_in = [NSString stringWithFormat:@"%@",dict[GM_Argument_in]];
        _dev_out = [NSString stringWithFormat:@"%@",dict[GM_Argument_out]];
    }
    return self;
}
@end



