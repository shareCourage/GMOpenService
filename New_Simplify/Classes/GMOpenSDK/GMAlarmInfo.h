//
//  GMAlarmInfo.h
//  New_Simplify
//
//  Created by Kowloon on 15/8/13.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GMAlarmInfo : NSObject <NSCoding>
/**
 *  
 "alarm_time" = 8;
 course = 6;
 des = 9;
 "gps_time" = 2;
 id = 0;
 lat = 4;
 lng = 3;
 speed = 5;
 status = 7;
 "type_id" = 1;
 */

@property(nonatomic, copy, readonly)NSString *alartTime;
@property(nonatomic, copy, readonly)NSString *course;
@property(nonatomic, copy, readonly)NSString *fenceId;
@property(nonatomic, copy, readonly)NSString *gpsTime;
@property(nonatomic, copy, readonly)NSString *alarmId;
@property(nonatomic, copy, readonly)NSString *lat;
@property(nonatomic, copy, readonly)NSString *lng;
@property(nonatomic, copy, readonly)NSString *speed;
@property(nonatomic, copy, readonly)NSString *status;
@property(nonatomic, copy, readonly)NSString *typeId;

- (instancetype)initWithArray:(NSArray *)array;

@end






