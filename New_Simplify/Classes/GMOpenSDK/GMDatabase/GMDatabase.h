//
//  GMDatabase.h
//  GMOpenSDK
//
//  Created by Kowloon on 15/6/24.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMDevice.h"

@interface GMDatabase : NSObject


/**
 *创建一个数据库单例
 */
+ (instancetype)shareDatabase;

/**
 * 向historyInfo表添加信息
 */
- (void)dbAddHistoryInfoOnQueue:(id<GMDevice>)device;

/**
 *  删除gpstime这个点的数据
 *
 */
- (BOOL)dbDeleteHistoryInfoWithGpstime:(NSString *)gpstime devid:(NSString *)devid;

/**
 *  删除整个表格数据
 *
 */
- (BOOL)dbDeleteAllOfTheHistoryInfoWidthDevid:(NSString *)devid;

/**
 *  数据所有个数
 *
 */
- (int)dbTotalCountOfHistoryInfoWidthDevid:(NSString *)devid;


/**
 获取historyInfo表所有信息
 */
- (NSArray *)dbAllOfTheHistoryInfoWithDevice:(id<GMDevice>)device orderBy:(GMOrderBy)orderBy devid:(NSString *)devid;

/**
 *  根据提供的模型，指定段的数据，limit要显示多少条记录，offset跳过多少条记录
 */
- (NSArray *)dbHistoryInfoWithDevice:(id<GMDevice>)device orderBy:(GMOrderBy)orderBy limit:(NSNumber *)limit offset:(NSNumber *)offset devid:(NSString *)devid;

- (NSArray *)dbHistoryInfosWithDevice:(id<GMDevice>)device fromTime:(NSString *)from toTime:(NSString *)to devid:(NSString *)devid orderBy:(GMOrderBy)orderBy;
- (NSArray *)dbHistoryInfosWithDevice:(id<GMDevice>)device fromSpeed:(NSString *)from toSpeed:(NSString *)to devid:(NSString *)devid;
- (NSArray *)dbHistoryInfosWithDevice:(id<GMDevice>)device fromLat:(NSString *)from toLat:(NSString *)to devid:(NSString *)devid;
- (NSArray *)dbHistoryInfosWithDevice:(id<GMDevice>)device fromLng:(NSString *)from toLng:(NSString *)to devid:(NSString *)devid;
- (NSArray *)dbHistoryInfosWithDevice:(id<GMDevice>)device fromCourse:(NSString *)from toCourse:(NSString *)to devid:(NSString *)devid;


- (NSArray *)dbExecuteWithDevice:(id<GMDevice>)device sqlite:(NSString *)sqlite;


/**
 *  查询数据库中指定devid，gps时间最大的那行
 *
 */
- (id)dbSelectMaxGpstimeHistoryInfo:(id<GMDevice>)device devid:(NSString *)devid;

@end







