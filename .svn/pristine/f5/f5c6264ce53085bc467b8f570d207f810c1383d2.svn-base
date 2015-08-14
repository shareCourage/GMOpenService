//
//  GMDatabase.m
//  GMOpenSDK
//
//  Created by Kowloon on 15/6/24.
//  Copyright (c) 2015年 Goome. All rights reserved.
//
#define sql_Create_Table_historyInfo @"create table if not exists historyInfo(id integer primary key autoincrement, gpstime text not null unique,lat text not null,lng text not null,speed text,course text,devid text not null)"
#define sql_Insert_historyInfo       @"insert into historyInfo(gpstime, lat, lng, speed, course, devid) values(?,?,?,?,?,?)"
#define sql_Delete_historyInfo_where_gpstime    @"delete from historyInfo where devid = ? and gpstime = ?"
#define sql_Delete_HistoryInfo                  @"delete from historyInfo where devid = ?"

#define sql_SelectAllHistoryInfo_Desc           @"select * from historyInfo where devid = ? order by gpstime desc"
#define sql_SelectAllHistoryInfo_Asc            @"select * from historyInfo where devid = ? order by gpstime asc"
#define sql_SelectAllHistoryInfo_Default        @"select * from historyInfo where devid = ?"
#define sql_SelectAllHistoryInfo_Desc_Limit     @"select * from historyInfo where devid = ? order by gpstime desc limit ? offset ?"
#define sql_SelectAllHistoryInfo_Asc_Limit      @"select * from historyInfo where devid = ? order by gpstime asc limit ? offset ?"
#define sql_SelectAllHistoryInfo_Default_Limit  @"select * from historyInfo where devid = ? order by gpstime limit ? offset ?"

#define sql_SelectHistoryInfo_between_speed     @"select * from historyInfo where devid = ? and speed between ? and ?"
#define sql_SelectHistoryInfo_between_lat       @"select * from historyInfo where devid = ? and lat between ? and ?"
#define sql_SelectHistoryInfo_between_lng       @"select * from historyInfo where devid = ? and lng between ? and ?"
#define sql_SelectHistoryInfo_between_course    @"select * from historyInfo where devid = ? and course between ? and ?"
#define sql_SelectHistoryInfo_between_gpstime_Default @"select * from historyInfo where devid = ? and gpstime between ? and ?"
#define sql_SelectHistoryInfo_between_gpstime_Desc    @"select * from historyInfo where devid = ? and gpstime between ? and ? order by gpstime desc"
#define sql_SelectHistoryInfo_between_gpstime_Asc     @"select * from historyInfo where devid = ? and gpstime between ? and ? order by gpstime asc"

#define DB_gpstime @"gpstime"
#define DB_lat @"lat"
#define DB_lng @"lng"
#define DB_speed @"speed"
#define DB_course @"course"
#define DB_devid @"devid"

#import "GMDatabase.h"
#import "GFMDB.h"
@implementation GMDatabase
{
//    GFMDatabase *_db;
    GFMDatabaseQueue *_GFMQueue;
}

+ (instancetype)shareDatabase
{
    static GMDatabase *gmDB;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gmDB = [[GMDatabase alloc] init];
    });
    return gmDB;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *routeDB = [documents stringByAppendingPathComponent:@"GMDatabase"];
        NSString *path = [routeDB stringByAppendingPathComponent:@"GMDatabase.db"];
        if (![fileManager fileExistsAtPath:routeDB]) {
            [fileManager createDirectoryAtPath:routeDB withIntermediateDirectories:YES attributes:nil error:nil];
        }
        _GFMQueue = [GFMDatabaseQueue databaseQueueWithPath:path];
        [_GFMQueue inDatabase:^(GFMDatabase *db) {
            [db executeUpdate:sql_Create_Table_historyInfo];
        }];
    }
    return self;
}

- (void)dbAddHistoryInfoOnQueue:(id<GMDevice>)device
{
    [_GFMQueue inDatabase:^(GFMDatabase *db) {
        NSString *gpstime = [device gps_time];
        NSString *lat = [device lat];
        NSString *lng = [device lng];
        NSString *speed = [device speed];
        NSString *course = [device course];
        NSString *deviceId = [device devid];
        [db executeUpdate:sql_Insert_historyInfo,gpstime,lat,lng,speed,course,deviceId];
//        NSLog(@"thread~~~~~~~~%@",[NSThread currentThread]);
    }];
}

- (BOOL)dbDeleteHistoryInfoWithGpstime:(NSString *)gpstime devid:(NSString *)devid
{
    __block BOOL success;
    [_GFMQueue inDatabase:^(GFMDatabase *db) {
        success = [db executeUpdate:sql_Delete_historyInfo_where_gpstime, devid, gpstime];
    }];
    return success;
}
- (BOOL)dbDeleteAllOfTheHistoryInfoWidthDevid:(NSString *)devid
{
    __block BOOL success;
    [_GFMQueue inDatabase:^(GFMDatabase *db) {
        success = [db executeUpdate:sql_Delete_HistoryInfo,devid];
    }];
    return success;
}

- (int)dbTotalCountOfHistoryInfoWidthDevid:(NSString *)devid
{
    __block int sum = 0;
    [_GFMQueue inDatabase:^(GFMDatabase *db) {
        GFMResultSet *result = [db executeQuery:sql_SelectAllHistoryInfo_Default,devid];
        while ([result next]) {
            sum ++;
        }
    }];
    return sum;
}

- (NSArray *)dbAllOfTheHistoryInfoWithDevice:(id<GMDevice>)device orderBy:(GMOrderBy)orderBy devid:(NSString *)devid
{
    NSString *sql = sql_SelectAllHistoryInfo_Default;
    switch (orderBy) {
        case GMOrderByDefault:
            sql = sql_SelectAllHistoryInfo_Default;
            break;
        case GMOrderByASC:
            sql = sql_SelectAllHistoryInfo_Asc;
            break;
        case GMOrderByDESC:
            sql = sql_SelectAllHistoryInfo_Desc;
            break;
        default:
            break;
    }
    return [self selectWithDevice:device sql:sql from:nil to:nil devid:devid];
}
- (NSArray *)dbHistoryInfoWithDevice:(id<GMDevice>)device orderBy:(GMOrderBy)orderBy limit:(NSNumber *)limit offset:(NSNumber *)offset devid:(NSString *)devid
{
    if (device == nil) return nil;
    if ([limit intValue] < 0 || [offset intValue] < 0) return nil;
    NSString *sql = sql_SelectAllHistoryInfo_Default_Limit;
    switch (orderBy) {
        case GMOrderByDefault:
            sql = sql_SelectAllHistoryInfo_Default_Limit;
            break;
        case GMOrderByASC:
            sql = sql_SelectAllHistoryInfo_Asc_Limit;
            break;
        case GMOrderByDESC:
            sql = sql_SelectAllHistoryInfo_Desc_Limit;
            break;
        default:
            break;
    }
    NSString *limitStr = [NSString stringWithFormat:@"%@",limit];
    NSString *offsetStr = [NSString stringWithFormat:@"%@",offset];
    return [self selectWithDevice:device sql:sql from:limitStr to:offsetStr devid:devid];
}

- (NSArray *)dbHistoryInfosWithDevice:(id<GMDevice>)device fromTime:(NSString *)from toTime:(NSString *)to devid:(NSString *)devid orderBy:(GMOrderBy)orderBy
{
    if (device == nil || from.length == 0 || to.length == 0 ) return nil;
    NSString *sql = sql_SelectHistoryInfo_between_gpstime_Default;
    switch (orderBy) {
        case GMOrderByDefault:
            sql = sql_SelectHistoryInfo_between_gpstime_Default;
            break;
        case GMOrderByASC:
            sql = sql_SelectHistoryInfo_between_gpstime_Asc;
            break;
        case GMOrderByDESC:
            sql = sql_SelectHistoryInfo_between_gpstime_Desc;
            break;
        default:
            break;
    }
    return [self selectWithDevice:device sql:sql from:from to:to devid:devid];
}
- (NSArray *)dbHistoryInfosWithDevice:(id<GMDevice>)device fromSpeed:(NSString *)from toSpeed:(NSString *)to devid:(NSString *)devid
{
    if (device == nil || from.length == 0 || to.length == 0 ) return nil;
    return [self selectWithDevice:device sql:sql_SelectHistoryInfo_between_speed from:from to:to devid:devid];
}
- (NSArray *)dbHistoryInfosWithDevice:(id<GMDevice>)device fromLat:(NSString *)from toLat:(NSString *)to devid:(NSString *)devid
{
    if (device == nil || from.length == 0 || to.length == 0 ) return nil;
    return [self selectWithDevice:device sql:sql_SelectHistoryInfo_between_lat from:from to:to devid:devid];
}
- (NSArray *)dbHistoryInfosWithDevice:(id<GMDevice>)device fromLng:(NSString *)from toLng:(NSString *)to devid:(NSString *)devid
{
    if (device == nil || from.length == 0 || to.length == 0 ) return nil;
    return [self selectWithDevice:device sql:sql_SelectHistoryInfo_between_lng from:from to:to devid:devid];
}
- (NSArray *)dbHistoryInfosWithDevice:(id<GMDevice>)device fromCourse:(NSString *)from toCourse:(NSString *)to devid:(NSString *)devid
{
    if (device == nil || from.length == 0 || to.length == 0 ) return nil;
    return [self selectWithDevice:device sql:sql_SelectHistoryInfo_between_course from:from to:to devid:devid];
}
- (NSArray *)selectWithDevice:(id<GMDevice>)device sql:(NSString *)sql from:(NSString *)from to:(NSString *)to devid:(NSString *)devid
{
    __block NSMutableArray *mutableArray = nil;
    Class deviceClass = [device class];
    [_GFMQueue inDatabase:^(GFMDatabase *db) {
        mutableArray = [NSMutableArray array];
        GFMResultSet *result = nil;
        if (from.length == 0 && to.length == 0) {
            result = [db executeQuery:sql,devid];
        }
        else {
           result = [db executeQuery:sql,devid,from,to];
        }
        while ([result next]) {
            id<GMDevice> myDevice = [[deviceClass alloc] init];
            myDevice.gps_time = [result stringForColumn:DB_gpstime];
            myDevice.lat = [result stringForColumn:DB_lat];
            myDevice.lng = [result stringForColumn:DB_lng];
            myDevice.speed = [result stringForColumn:DB_speed];
            myDevice.course = [result stringForColumn:DB_course];
            myDevice.devid = [result stringForColumn:DB_devid];
            [mutableArray addObject:myDevice];
        }

    }];
    return mutableArray;
}

- (NSArray *)dbExecuteWithDevice:(id<GMDevice>)device sqlite:(NSString *)sqlite
{
    NSString *select = [sqlite substringWithRange:NSMakeRange(0, 6)];
    if (![select isEqualToString:@"select"]) return nil;
    __block NSMutableArray *mutableArray = nil;
    Class deviceClass = [device class];
    [_GFMQueue inDatabase:^(GFMDatabase *db) {
        mutableArray = [NSMutableArray array];
        GFMResultSet *result = [db executeQuery:sqlite];
        while ([result next]) {
            id<GMDevice> myDevice = [[deviceClass alloc] init];
            myDevice.gps_time = [result stringForColumn:DB_gpstime];
            myDevice.lat = [result stringForColumn:DB_lat];
            myDevice.lng = [result stringForColumn:DB_lng];
            myDevice.speed = [result stringForColumn:DB_speed];
            myDevice.course = [result stringForColumn:DB_course];
            myDevice.devid = [result stringForColumn:DB_devid];
            [mutableArray addObject:myDevice];
        }
    }];
    return mutableArray;
}

@end




