//
//  GMAlarmManager.h
//  New_Simplify
//
//  Created by Kowloon on 15/8/13.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import "GMManager.h"

@interface GMAlarmManager : GMManager


/**
 *  typeId 默认 @"1,2"，1代表进围栏报警，2代表出围栏报警
 *  可自定义成@"1"、@"2"
 */
@property(nonatomic, copy)NSString *typeId;

/**
 *  控制第几页的数据，默认为0
 */
@property(nonatomic, assign)NSUInteger pageNum;

/**
 *  控制每页显示的数量、默认为20条
 */
@property(nonatomic, assign)NSUInteger pageSize;

/**
 *  获取报警围栏信息
 *
 */
- (BOOL)getAlarmInformationWithDevid:(NSString *)devid completionBlock:(GMOptionArray)success failureBlock:(GMOptionError)failure;

@end




