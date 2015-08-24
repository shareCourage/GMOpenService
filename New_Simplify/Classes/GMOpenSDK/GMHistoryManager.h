//
//  GMHistoryManager.h
//  GMOpenSDK
//
//  Created by Kowloon on 15/6/17.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import "GMManager.h"
#import "GMDevice.h"
#import "GMDeviceInfo.h"

typedef void (^GMOptionDeviceInfo)(GMDeviceInfo *deviceInfo);


@interface GMHistoryManager : GMManager

/**
 *  开始时间,获取历史位置信息时,必选参数
 */
@property(nonatomic, copy, readwrite)NSString *startTime;

/**
 *  结束时间,获取历史位置信息时,必选参数
 */
@property(nonatomic, copy, readwrite)NSString *endTime;

/**
 *  每次请求数据数量,默认1000条
 */
@property(nonatomic, copy, readwrite)NSString *numberLimit;

/**
 *  设备id号,必选参数
 */
@property(nonatomic, copy, readwrite)NSString *deviceId;


//TODO: 获取最新的位置信息：下面两个方法实现功能相同，但回调的block不一样;第一个返回原生的字典，用户可根据具体情况自己解析;第二个返回一个GMDeviceInfo模型，已解析完成，可直接使用
/**
 *  获取最新的位置信息,需填写deviceId参数
 *
 */
- (void)getNewestInformationSuccessBlock:(GMOptionDict)success failureBlock:(GMOptionError)failure;

/**
 *  获取最新的位置信息,需填写deviceId参数,回调block指定GMDeviceInfo模型
 *
 */
- (void)getNewestInformationSuccessBlockDeviceInfo:(GMOptionDeviceInfo)success failureBlock:(GMOptionError)failure;


//TODO: 批量获取最新的位置信息：下面两个方法实现功能相同，但回调的block不一样;第一个返回原生的字典，用户可根据具体情况自己解析;第二个返回一个数组，已解析完成，内部存放GMDeviceInfo模型，可直接使用
/**
 *  批量获取最新的位置信息
 *
 *  @param deviceIds deviceIds 内部数据必须为字符串对象
 */
- (void)getNewestInformationWithDeviceIds:(NSArray *)deviceIds successBlock:(GMOptionDict)success failureBlock:(GMOptionError)failure;

- (void)getNewestInformationWithDeviceIds:(NSArray *)deviceIds successBlockArray:(GMOptionArray)success failureBlock:(GMOptionError)failure;



//TODO: 获取设备历史信息数据：下面两个方法实现功能相同，但回调的block不一样;第一个返回原生的字典，用户可根据具体情况自己解析;第二个返回一个数组，已解析完成，内部存放GMDeviceInfo模型，可直接使用
/**
 *  获取设备历史信息数据,最大1000条,且数据在最近两个月,超过两个月数据无法获取
 *
 */
- (void)getHistoryInformationSuccessBlock:(GMOptionDict)success failureBlock:(GMOptionError)failure;

/**
 *  获取设备历史信息数据,最大1000条,且数据在最近两个月,超过两个月数据无法获取,
 *  success block返回一个数组,数组包含GMDeviceInfo对象
 *
 */
- (void)getHistoryInformationSuccessBlockArray:(GMOptionArray)success failureBlock:(GMOptionError)failure;


//TODO:将获取到的数据全部存入到本地数据库
/**
 *  子线程操作,将获取到的数据全部存入到本地数据库,包含时间段所有数据(可超过1000条)
 *
 */
- (void)getHistoryInformationAndSaveToLocalDatabaseWithCompletion:(void (^)(void))block;



//TODO:下面的api均从本地数据库获取数据,执行的前提是这个方法(getHistoryInformationAndSaveToLocalDatabaseWithCompletion)需执行完成,将数据保存好
/**
 *  返回数据的总条数
 */
- (int)countOfTheHistoryInfos;

/**
 *  根据gpstime,删除指定devid的数据
 */
- (BOOL)deleteHistoryInfoWhereGpstime:(NSString *)gpstime;

/**
 *  清空该数据库中所有指定devid数据
 */
- (BOOL)deleteHistoryInfo;

/**
 *  根据提供的模型,返回数据库所有的数据,默认均安gps时间排序
 *  @return 遵行GMDevice协议的模型数组
 */
- (NSArray *)selectAllOfHistoryInfosWithDevice:(id<GMDevice>)device orderBy:(GMOrderBy)orderBy;

/**
 *  根据提供的模型,指定段的数据,limit要显示多少条记录,offset跳过多少条记录,默认均安gps时间排序
 *  @return 遵行GMDevice协议的模型数组
 */
- (NSArray *)selectHistoryInfosWithDevice:(id<GMDevice>)device orderBy:(GMOrderBy)orderBy limit:(NSNumber *)limit offset:(NSNumber *)offset;

/**
 *  根据gpstime返回该时间段的数据
 *  @return 遵行GMDevice协议的模型数组
 */
- (NSArray *)selectHistoryInfosWithDevice:(id<GMDevice>)device fromTime:(NSString *)from toTime:(NSString *)to orderBy:(GMOrderBy)orderBy;

/**
 *  根据speed返回该时间段的数据
 *  @return 遵行GMDevice协议的模型数组
 */
- (NSArray *)selectHistoryInfosWithDevice:(id<GMDevice>)device fromSpeed:(NSString *)from toSpeed:(NSString *)to;

/**
 *  根据lat返回该时间段的数据
 *  @return 遵行GMDevice协议的模型数组
 */
- (NSArray *)selectHistoryInfosWithDevice:(id<GMDevice>)device fromLat:(NSString *)from toLat:(NSString *)to;

/**
 *  根据lng返回该时间段的数据
 *  @return 遵行GMDevice协议的模型数组
 */
- (NSArray *)selectHistoryInfosWithDevice:(id<GMDevice>)device fromLng:(NSString *)from toLng:(NSString *)to;

/**
 *  根据course返回该时间段的数据
 *  @return 遵行GMDevice协议的模型数组
 */
- (NSArray *)selectHistoryInfosWithDevice:(id<GMDevice>)device fromCourse:(NSString *)from toCourse:(NSString *)to;

/**
 *  可自定义数据库查询语句,但是只允许执行select语句
 *
 *  @return 遵行GMDevice协议的模型数组
 */
- (NSArray *)selectHistoryInfosWithDevice:(id<GMDevice>)device sqlite:(NSString *)sqlite;



@end










