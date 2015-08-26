//
//  GMPushInfo.h
//  New_Simplify
//
//  Created by Kowloon on 15/8/24.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GMPushInfo : NSObject <NSCoding>

@property (nonatomic, copy)NSString *alarmType;
@property (nonatomic, copy)NSString *lang;
@property (nonatomic, copy)NSString *mapType;
@property (nonatomic, copy)NSString *version;

@property (nonatomic, copy)NSString *cid;
@property (nonatomic, copy)NSString *shake;
@property (nonatomic, copy)NSString *sound;
@property (nonatomic, copy)NSString *timeZone;
@property (nonatomic, copy)NSString *startTime;
@property (nonatomic, copy)NSString *endTime;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end



/**
 *  {
 "data": {
 "alarmtype": "1,2",
 "cid": "12001",
 "end_time": "1439",
 "lang": "en",
 "map_type": "GOOGLE",
 "shake": "1",
 "sound": "1",
 "start_time": "0",
 "timezone": "28800",
 "version": "1.0"
 },
 "msg": "",
 "ret": 0
 }
 */
