//
//  GMPushManager.h
//  GMOpenSDK
//
//  Created by Kowloon on 15/6/17.
//  Copyright (c) 2015年 Goome. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "GMManager.h"

@interface GMPushManager : GMManager


// init Push
+ (void)setupWithOption:(NSDictionary *)launchingOption;

// register notification type
+ (void)iOS8RegisterForRemoteNotificationTypes:(NSUInteger)types categories:(NSSet *)categories;  // 注册APNS类型
+ (void)iOS7RegisterForRemoteNotificationTypes:(NSUInteger)types;

// upload device token
+ (void)registerDeviceToken:(NSData *)deviceToken;

// handle notification recieved
+ (void)handleRemoteNotification:(NSDictionary *)remoteInfo;

@end




