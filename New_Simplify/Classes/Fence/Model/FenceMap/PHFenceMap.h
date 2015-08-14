//
//  PHFenceMap.h
//  SimplifiedApp
//
//  Created by Kowloon on 15/5/9.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface PHFenceMap : NSObject

/**
 *  圆形，圆的半径
 */
@property(nonatomic, assign)double radius;


/**
 *  圆形，圆的经纬度
 */
@property(nonatomic, assign)CLLocationCoordinate2D coordinate;

/**
 *  多边形，多边形点的集合
 */
@property(nonatomic, strong)NSArray *coords;

/**
 *  是否开启
 */
@property(nonatomic, assign)BOOL enable;


+ (instancetype)fenceMap;
@end




