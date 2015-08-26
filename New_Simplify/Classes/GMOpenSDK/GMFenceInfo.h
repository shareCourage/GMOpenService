//
//  GMFenceInfo.h
//  New_Simplify
//
//  Created by Kowloon on 15/7/20.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GMDevInOut;

@interface GMFenceInfo : NSObject<NSCoding>

/**
 通过设备号获取的围栏信息
 area = "22.543140,113.989880,2179";
 devid = 1234567890;
 enable = 0;
 fenceid = 3285066;
 in = 1;
 name = NULL;
 out = 1;
 shape = 1;
 threshold = 3;
 "update_time" = 1431337640;
 
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 通过围栏号获取的围栏信息
 area = "22.123456,113.123400;22.145543,113.125600;22.164400,113.129900;22.180000,113.135500;22.197700,113.142200";
 devinfo =         (
 {
 devid = 1234567890;
 in = 1;
 out = 1;
 }
 );
 enable = 1;
 fenceid = 3305198;
 name = "\U54c8\U54c8\U54c8";
 shape = 2;
 threshold = 4;
 "update_time" = 1431413504;
 */
@property(nonatomic, copy)NSString *area;
@property(nonatomic, copy)NSString *enable;
@property(nonatomic, copy)NSString *fenceid;
@property(nonatomic, copy)NSString *name;
@property(nonatomic, copy)NSString *shape;
@property(nonatomic, copy)NSString *threshold;
@property(nonatomic, copy)NSString *update_time;

/**
 *  获取设备围栏信息时，实例化该参数
 */
@property(nonatomic, strong)GMDevInOut *devInOut;

/**
 *  获取指定围栏信息时，实例化该参数，存放GMDevInOut对象
 */
@property(nonatomic, strong)NSArray *devinfos;

/**
 *  通过设备号查询的围栏信息
 *
 */
- (instancetype)initWithDeviceDict:(NSDictionary *)dict;

/**
 *  通过围栏号查询的围栏信息
 *
 */
- (instancetype)initWithFenceDict:(NSDictionary *)dict;

@end



@interface GMDevInOut : NSObject <NSCoding>

@property(nonatomic, copy)NSString *devid;
@property(nonatomic, copy)NSString *dev_in;
@property(nonatomic, copy)NSString *dev_out;

@end





