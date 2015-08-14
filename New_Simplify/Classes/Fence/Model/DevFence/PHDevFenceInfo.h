//
//  PHDevFenceInfo.h
//  Demo_Monitor
//
//  Created by Kowloon on 15/4/1.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PHDevFenceInfo : NSObject<NSCoding>




@property(nonatomic, strong)NSString *area;
@property(nonatomic, strong)NSString *devid;
@property(nonatomic, strong)NSString *enable;
@property(nonatomic, strong)NSString *fenceid;
@property(nonatomic, strong)NSString *dev_In;
@property(nonatomic, strong)NSString *dev_Out;
@property(nonatomic, strong)NSString *shape;
@property(nonatomic, strong)NSString *threshold;
@property(nonatomic, strong)NSString *update_time;
@property(nonatomic, strong)NSString *name;

@property(nonatomic, strong)NSString *radius;
@property(nonatomic, strong)NSString *lat;
@property(nonatomic, strong)NSString *lng;
@property(nonatomic, strong)NSString *areaChinese;

/**
 *  多边形的经纬度集合，每个元素为NSString类型，有经纬度组合 eg:
 *  12.000000,13.000000
 *  14.000000,15.000000;
 */
@property(nonatomic, strong)NSArray *coords;

+ (NSArray *)createWithDict:(NSDictionary *)dict;

@end











