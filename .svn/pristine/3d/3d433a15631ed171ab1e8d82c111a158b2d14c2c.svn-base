//
//  GMNearbyManager.h
//  GMOpenSDK
//
//  Created by Kowloon on 15/6/17.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import "GMManager.h"
#import "GMDevice.h"

@interface GMNearbyManager : GMManager

/**
 *  附近设备使用，设备距离，默认200米,不得大于10000米
 */
@property(nonatomic, copy)NSString *distance;

/**
 *  附近设备使用, 根据上传位置时设置的tag来过滤需要的信息
 */
@property (nonatomic, copy) NSString *tag1;
@property (nonatomic, copy) NSString *tag2;
@property (nonatomic, copy) NSString *tag3;

//TODO: 获取最新的位置信息：下面两个方法实现功能相同，但回调的block不一样;第一个返回原生的字典，用户可根据具体情况自己解析;第二个返回一个GMDeviceInfo模型，已解析完成，可直接使用
/**
 *  success字典当中最多返回100个设备
 */
- (BOOL)nearbyDeviceInformation:(NSString *)devid successBlock:(GMOptionDict)success failureBlock:(GMOptionError)failure;
/**
 *  success字典当中最多返回100个设备,回调block指定GMDeviceInfo模型
 */
- (BOOL)nearbyDeviceInformation:(NSString *)devid successBlockArray:(GMOptionArray)success failureBlock:(GMOptionError)failure;



/**
 *  单个设备信息的位置上传
 */
- (BOOL)uploadDeviceInfo:(id<GMDevice>)device completionBlock:(GMOptionSuccess)success failureBlock:(GMOptionError)failure;


/**
 *  批量位置信息的上传，同时devices中的模型必须遵行GMDevice协议
 */
- (BOOL)uploadMuchOfDeviceInfos:(NSArray *)devices completionBlock:(GMOptionSuccess)success failureBlock:(GMOptionError)failure;


- (BOOL)reverseGeocode:(CLLocationCoordinate2D *)coords count:(NSUInteger)count completionBlock:(GMOptionArray)success failureBlock:(GMOptionError)failure;

@end



