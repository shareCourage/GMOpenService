//
//  PHHistoryLoc.h
//  SimplifiedApp
//
//  Created by Kowloon on 15/5/4.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PHHistoryLoc : NSObject<GMDevice>

@property(nonatomic, copy)NSString *devid;
@property(nonatomic, copy)NSString *gps_time;
@property(nonatomic, copy)NSString *course;
@property(nonatomic, copy)NSString *speed;
@property(nonatomic, copy)NSString *lng;
@property(nonatomic, copy)NSString *lat;


- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)createHistoryLocWithDict:(NSDictionary *)dict;
+ (NSArray *)historyLocWithDict:(NSDictionary *)dict;
+ (NSArray *)historyLocWithArray:(NSArray *)array;


@end
