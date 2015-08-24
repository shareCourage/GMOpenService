//
//  GMPushManager.h
//  GMOpenSDK
//
//  Created by Kowloon on 15/6/17.
//  Copyright (c) 2015年 Goome. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "GMManager.h"
@class GMPushInfo;

typedef void (^GMOptionPushInfo)(GMPushInfo *pushInfo);


@interface GMPushManager : GMManager

/**
 *  语言类型， 例如：zh-CN , en
 */
@property (nonatomic, copy)NSString *lang;

/**
 *  需要推送的报警类型，逗号隔开，如：1,2 表示推送进出围栏报警
 */
@property (nonatomic, copy)NSString *alarmType;

/**
 *  时区， 如东8区:28800
 */
@property (nonatomic, strong)NSNumber *timeZone;

/**
 *  收到报警时是否声音提醒，0：不提醒；1：提醒
 */
@property (nonatomic, strong)NSNumber *sound;

/**
 *  收到报警时是否震动提醒，0：不提醒；1：提醒
 */
@property (nonatomic, strong)NSNumber *shake;

/**
 *  一天之中接收报警的起始时间，单位分钟，从0点开始的分钟数，比如：360，表示起始时间为6点
 */
@property (nonatomic, strong)NSNumber *startTime;

/**
 *  一天之中接收报警的结束时间，单位分钟，从0点开始的分钟数，比如：1080，表示结束时间为18点
 */
@property (nonatomic, strong)NSNumber *endTime;


// init Push
+ (void)setupWithOption:(NSDictionary *)launchingOption;

// register notification type
+ (void)iOS8RegisterForRemoteNotificationTypes:(NSUInteger)types categories:(NSSet *)categories;  // 注册APNS类型
+ (void)iOS7RegisterForRemoteNotificationTypes:(NSUInteger)types;

// upload device token
+ (void)registerDeviceToken:(NSData *)deviceToken;

// handle notification recieved
+ (void)handleRemoteNotification:(NSDictionary *)remoteInfo;

/**
 *  设置推送报警选项接口，根据设备id，修改推送的条件
 *
 */
- (BOOL)updatePushTypeWithDevid:(NSString *)devid completionBlock:(GMOptionSuccess)success failureBlock:(GMOptionError)failure;

/**
 *  获取推送当前的设置
 */
- (BOOL)getPushInfoWithDevid:(NSString *)devid completionBlock:(GMOptionPushInfo)pushInfo failureBlock:(GMOptionError)failure;

@end




