//
//  PHHistoryLoc.m
//  SimplifiedApp
//
//  Created by Kowloon on 15/5/4.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import "PHHistoryLoc.h"
#import <MJExtension/MJExtension.h>
//#import "PHHistoryDatabase.h"
@implementation PHHistoryLoc


- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (!dict) return nil;
    self = [super init];
    if (self) {
        self = [PHHistoryLoc objectWithKeyValues:dict];
//        [[PHHistoryDatabase shareHistoryInfoDatabase] dbAddHistoryInfo:self];//向数据库中添加数据
    }
    return self;
}
+ (instancetype)createHistoryLocWithDict:(NSDictionary *)dict
{
    if (!dict) return nil;
    PHHistoryLoc *history = [[PHHistoryLoc alloc] initWithDict:dict];
    return history;
}

+ (NSArray *)historyLocWithDict:(NSDictionary *)dict
{
    if (!dict) return nil;
    NSArray *array = dict[PH_ConnectedArgument_data];
    return [PHHistoryLoc historyLocWithArray:array];
}
+ (NSArray *)historyLocWithArray:(NSArray *)array
{
    if (array.count == 0) return nil;
    NSMutableArray *mArray = [NSMutableArray array];
    for (NSDictionary *obj in array) {
        PHHistoryLoc *history = [PHHistoryLoc createHistoryLocWithDict:obj];
        [mArray addObject:history];
    }
    return mArray;
}

@end







