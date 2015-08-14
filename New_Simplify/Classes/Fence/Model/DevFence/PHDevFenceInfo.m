//
//  PHDevFenceInfo.m
//  Demo_Monitor
//
//  Created by Kowloon on 15/4/1.
//  Copyright (c) 2015年 Goome. All rights reserved.
//
#define PHCoder_area                @"area"
#define PHCoder_devid               @"devid"
#define PHCoder_enable              @"enable"
#define PHCoder_fenceid             @"fenceid"
#define PHCoder_dev_In              @"dev_In"
#define PHCoder_dev_Out             @"dev_Out"
#define PHCoder_shape               @"shape"
#define PHCoder_threshold           @"threshold"
#define PHCoder_updatetime          @"updatetime"
#define PHCoder_radius              @"radius"
#define PHCoder_lat                 @"lat"
#define PHCoder_lng                 @"lng"
#define PHCoder_areaChinese         @"areaChinese"
#define PHCoder_name                @"name"

#import "PHDevFenceInfo.h"
#import "NSArray+MySeperateString.h"
#import "MJExtension.h"
@implementation PHDevFenceInfo
//对数据源的解析
+ (NSArray *)createWithDict:(NSDictionary *)dict
{
    if (!dict) return nil;
    NSMutableArray *array = [NSMutableArray array];
    if (dict) {
        NSArray *arr = dict[@"data"];
        if (arr.count != 0) {
            for (NSDictionary *obj in arr) {
                PHDevFenceInfo *fence = [[PHDevFenceInfo alloc] init];
                fence.name = obj[@"name"];
                fence.area = obj[@"area"];
                fence.devid = obj[@"devid"];
                fence.enable = obj[@"enable"];
                fence.fenceid = obj[@"fenceid"];
                fence.dev_In = obj[@"in"];
                fence.dev_Out = obj[@"out"];
                fence.shape = obj[@"shape"];
                fence.threshold = obj[@"threshold"];
                fence.update_time = obj[@"update_time"];
                if ([fence.shape isEqualToString:@"1"]) {
                    NSArray *arraySep = [NSArray seprateString:fence.area characterSet:@","];
                    fence.lat = arraySep[0];
                    fence.lng = arraySep[1];
                    fence.radius = arraySep[2];
                }
                else if ([fence.shape isEqualToString:@"2"]){
                    fence.coords = [NSArray seprateString:fence.area characterSet:@";"];
                }
                [array addObject:fence];
            }
        }
    }
    
    return array;
}

MJCodingImplementation


#if 0
//对象的解档
- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        _area        = [decoder decodeObjectForKey:PHCoder_area];
        _devid       = [decoder decodeObjectForKey:PHCoder_devid];
        _enable      = [decoder decodeObjectForKey:PHCoder_enable];
        _fenceid     = [decoder decodeObjectForKey:PHCoder_fenceid];
        _dev_In      = [decoder decodeObjectForKey:PHCoder_dev_In];
        _dev_Out     = [decoder decodeObjectForKey:PHCoder_dev_Out];
        _shape       = [decoder decodeObjectForKey:PHCoder_shape];
        _threshold   = [decoder decodeObjectForKey:PHCoder_threshold];
        _update_time = [decoder decodeObjectForKey:PHCoder_updatetime];
        _radius      = [decoder decodeObjectForKey:PHCoder_radius];
        _lat         = [decoder decodeObjectForKey:PHCoder_lat];
        _lng         = [decoder decodeObjectForKey:PHCoder_lng];
        _areaChinese = [decoder decodeObjectForKey:PHCoder_areaChinese];
        _areaChinese = [decoder decodeObjectForKey:PHCoder_name];
    }
    return self;
}
//对象归档
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_area forKey:PHCoder_area];
    [aCoder encodeObject:_devid forKey:PHCoder_devid];
    [aCoder encodeObject:_enable forKey:PHCoder_enable];
    [aCoder encodeObject:_fenceid forKey:PHCoder_fenceid];
    [aCoder encodeObject:_dev_In forKey:PHCoder_dev_In];
    [aCoder encodeObject:_dev_Out forKey:PHCoder_dev_Out];
    [aCoder encodeObject:_shape forKey:PHCoder_shape];
    [aCoder encodeObject:_threshold forKey:PHCoder_threshold];
    [aCoder encodeObject:_update_time forKey:PHCoder_updatetime];
    [aCoder encodeObject:_radius forKey:PHCoder_radius];
    [aCoder encodeObject:_lat forKey:PHCoder_lat];
    [aCoder encodeObject:_lng forKey:PHCoder_lng];
    [aCoder encodeObject:_areaChinese forKey:PHCoder_areaChinese];
    [aCoder encodeObject:_areaChinese forKey:PHCoder_name];

}
#endif
- (void)dealloc
{
    PHLog(@"PHDevFenceInfo.h  --->>> dealloc");
}
@end
