//
//  GMOpenManager.h
//  GMOpenSDK
//
//  Created by Kowloon on 15/6/16.
//  Copyright (c) 2015年 Goome. All rights reserved.
//


#import "GMManager.h"
@class GMOpenManager;

typedef NS_ENUM(NSInteger, GMOpenPermissionStatus) {
    GMOpenPermissionStatusOfFailure,
    GMOpenPermissionStatusOfSuccess
};

typedef void (^GMOpenManagerBlock)(GMOpenPermissionStatus status);


@protocol GMOpenManagerDelegate <NSObject>

@optional
- (void)openManager:(GMOpenManager *)manager getPermissionState:(GMOpenPermissionStatus)status;

@end


@interface GMOpenManager : GMManager


/**
 *  通过代理的方式来获取验证appidKey的结果
 */
- (BOOL)validateWithKey:(NSString *)appidKey delegate:(id<GMOpenManagerDelegate>)delegate;

/**
 *  通过回调block的方式来获取验证appidKey的结果
 */
- (BOOL)validateWithKey:(NSString *)appidKey completionBlock:(GMOpenManagerBlock)block;

@end





