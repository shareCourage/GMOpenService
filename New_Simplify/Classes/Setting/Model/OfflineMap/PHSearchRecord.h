//
//  PHSearchRecord.h
//  SimplifiedApp
//
//  Created by Kowloon on 15/5/13.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BMKOLSearchRecord;
@interface PHSearchRecord : NSObject
@property(nonatomic, strong)BMKOLSearchRecord *record;
//@property(nonatomic, assign, getter=isDownloaded)BOOL downloaded;
@property(nonatomic, copy)NSString *statusStr;
+ (instancetype)searchRecord;
@end
