//
//  GMFenceManager.h
//  GMOpenSDK
//
//  Created by Kowloon on 15/6/17.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import "GMManager.h"
#import <CoreLocation/CoreLocation.h>
@class GMFenceInfo;
@class GMDeviceFence;
@class GMNumberFence;

typedef NS_ENUM(NSInteger, GMFenceShape) {
    GMFenceShapeOfCircle,
    GMFenceShapeOfPolygon
};


typedef void (^GMOptionFenceInfo)(GMFenceInfo *fenceInfo);
typedef void (^GMOptionDeviceFence)(GMDeviceFence *deviceFence);
typedef void (^GMOptionNumberFence)(GMNumberFence *numberFence);

@interface GMFenceManager : GMManager

/**
 *  围栏为圆形时，圆形中心点，必选参数
 */
@property(nonatomic, assign, readwrite)CLLocationCoordinate2D coord;

/**
 *  如果围栏为多边形，围栏的各个点，必选参数
 *  示例：
 *  CLLocationCoordinate2D *coords = malloc(sizeof(CLLocationCoordinate2D) * 2);
 *  coords[0] = CLLocationCoordinate2DMake(22.000000, 131.000000);
 *  coords[1] = CLLocationCoordinate2DMake(23.000000, 132.000000);
 */
@property(nonatomic, assign, readwrite)CLLocationCoordinate2D *coords;

/**
 *  如果围栏为多边形，表示点的个数，必选参数
 */
@property(nonatomic, assign, readwrite)NSUInteger coordsCount;

/**
 *  是否开启围栏，默认YES，开启
 */
@property(nonatomic, assign, readwrite)BOOL enable;

/**
 *  圆形，多边形，默认圆形
 */
@property(nonatomic, assign, readwrite)GMFenceShape shape;

/**
 *  报警阈值。即设备连续N次出/入围栏时才发出报警，默认3次
 */
@property(nonatomic, assign, readwrite)NSUInteger threshold;

/**
 *  围栏为圆形时，圆形半径，默认100米
 */
@property(nonatomic, assign, readwrite)CGFloat radius;

/**
 *  YES代表进入围栏报警，NO不报警，默认YES
 */
@property(nonatomic, assign, readwrite)BOOL getIn;

/**
 *  YES代表离开围栏报警，NO不报警，默认YES
 */
@property(nonatomic, assign, readwrite)BOOL getOut;

/**
 *  围栏名称，默认为nil
 */
@property(nonatomic, copy, readwrite)NSString *fenceName;


/**
 *  限修改围栏使用,格式：devid1,in_flag,out_flag;devid2,in_flag,out_flag;…
 *  例如：123,1,0;234,1,1;
 */
@property(nonatomic, copy, readwrite)NSString *devinfo;

/**
 *  给多个设备添加围栏
 *  devids设备围栏数组
 */
- (void)addFenceWithDeviceIds:(NSArray *)devids completionBlock:(GMOptionSuccess)success failureBlock:(GMOptionError)failure;

@end


@interface GMFenceManager (GMDeleteFenceManager)

/**
 *  删除围栏
 */
- (void)deleteFenceWithFenceId:(NSString *)fenceId completionBlock:(GMOptionSuccess)success failureBlock:(GMOptionError)failure;

@end


@interface GMFenceManager (GMModifyFenceManager)

/**
 *  修改围栏
 *  1、修改围栏图形形状时，shape和coord(shape 和 coords、coordsCount)必须一一对应
 */
- (void)modifyFenceWithFenceId:(NSString *)fenceId completionBlock:(GMOptionSuccess)success failureBlock:(GMOptionError)failure;


/**
 *  仅用来修改围栏的enable属性
 *
 */
+ (void)modifyFenceWithFenceId:(NSString *)fenceId enable:(BOOL)enable completion:(GMOptionSuccess)success failureBlock:(GMOptionError)failure;

//TODO: 9.06添加
/**
 *  仅用来修改围栏的devinfo属性
 *
 */
+ (void)modifyFenceWithFenceId:(NSString *)fenceId devinfo:(NSString *)devinfo completion:(GMOptionSuccess)success failure:(GMOptionError)failure;

//TODO: 9.06添加
/**
 *  仅用来修改围栏的name属性
 *
 */
+ (void)modifyFenceWithFenceId:(NSString *)fenceId name:(NSString *)name completion:(GMOptionSuccess)success failure:(GMOptionError)failure;

+ (void)modifyFenceWithFenceId:(NSString *)fenceId threshold:(NSString *)threshold completion:(GMOptionSuccess)success failure:(GMOptionError)failure;

@end


@interface GMFenceManager (GMObtainFenceManager)

//TODO: 下面两个方法实现功能相同，但回调的block不一样;第一个返回原生的字典，用户可根据具体情况自己解析;第二个返回一个数组，已解析完成，内部存放GMFenceInfo模型，可直接使用
/**
 *  根据设备号查询围栏
 *
 *  @param devid   deviceId 设备号
 */
- (void)obtainFenceWithDeviceId:(NSString *)deviceId successBlock:(GMOptionDict)success failureBlock:(GMOptionError)failure;

/**
 *  根据设备号查询围栏，回调block中的数组指定GMDeviceFence模型
 *
 */
- (void)obtainFenceWithDeviceId:(NSString *)deviceId successBlockArray:(GMOptionArray)success failureBlock:(GMOptionError)failure;




//TODO: 下面两个方法实现功能相同，但回调的block不一样;第一个返回原生的字典，用户可根据具体情况自己解析;第二个返回一个GMFenceInfo模型，已解析完成，可直接使用

/**
 *  根据围栏号查询围栏
 *
 *  @param devid   fenceId 围栏号
 */
- (void)obtainFenceWithFenceId:(NSString *)fenceId successBlock:(GMOptionDict)success failureBlock:(GMOptionError)failure;

/**
 *  根据围栏号查询围栏
 *
 *  返回一个GMFenceInfo模型block
 */
- (void)obtainFenceWithFenceId:(NSString *)fenceId successBlockFenceInfo:(GMOptionNumberFence)success failureBlock:(GMOptionError)failure;

@end


