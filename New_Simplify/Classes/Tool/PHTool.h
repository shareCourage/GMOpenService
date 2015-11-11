//
//  PHTool.h
//  SimplifiedApp
//
//  Created by Kowloon on 15/4/30.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "NSArray+MySeperateString.h"
#import "NSDictionary+PHCategory.h"
#import "UIButton+PHCategory.h"
#import "UILabel+PHCategory.h"
#import "NSDate+PHCategory.h"
#import "UIProgressView+PHCategory.h"
#import "UISlider+PHCategory.h"
#import "NSNumber+PHCategory.h"
#import "UIImage+PHCategory.h"
#import "UITextField+PHCategory.h"
#import "NSString+PHCategory.h"
#import "MBProgressHUD+MJ.h"
#import "UIViewController+PHCategory.h"
#import "PHKeyValueObserver.h"

@interface PHTool : NSObject

/**
 *  获取用户在userDefaults存储的deviceId
 *
 *  @return string
 */
+ (NSString *)getDeviceIdFromUserDefault;

/**
 *  获取用户在userDefaults存储的appid
 *
 *  @return string
 */
+ (NSString *)getAppidFromUserDefault;

/**
 * 包大小转换工具类（将包大小转换成合适单位）
 *
 *  @return string
 */
+ (NSString *)getDataSizeString:(int)nSize;

/*
 *登录成功后，保存需要的数据
 */
+ (void)loginSuccessWithAppid:(NSString *)appidString
                        devid:(NSString *)devidString
                  accessToken:(NSString *)accessToken;

+ (NSString *)convertTime:(id)gpsTime withDateFormate:(NSString *)dateF;

/**
 *  计算2个经纬度之间的直线距离
 */
+ (CLLocationDistance)calculateLineDistanceWithSourceCoordinate:(CLLocationCoordinate2D)source andDestinationCoordinate:(CLLocationCoordinate2D)destination;


+ (BOOL)encoderObjectArray:(NSMutableArray *)memberArray path:(NSString *)filePath;
+ (NSMutableArray *)decoderObjectPath:(NSString *)filePath;


/**
 *  将数组元素转化成CLLocationCoordinate2D *数组
 *
 *  @param coords 数组中均为NSString类型
 */
+ (CLLocationCoordinate2D *)transitToCoords:(NSArray *)coords;

+ (NSString *)stringConnected:(NSArray *)array connectString:(NSString *)connectStr;

+ (void)loginViewControllerImplementation;
@end






