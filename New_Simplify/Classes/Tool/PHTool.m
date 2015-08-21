//
//  PHTool.m
//  SimplifiedApp
//
//  Created by Kowloon on 15/4/30.
//  Copyright (c) 2015年 Goome. All rights reserved.
//
#define PHArchiver_memberArray @"memberArray"

#import "PHTool.h"

@implementation PHTool
+ (CLLocationCoordinate2D *)transitToCoords:(NSArray *)coords
{
    int count = (int)coords.count;
    CLLocationCoordinate2D *coordsC = malloc(sizeof(CLLocationCoordinate2D) * count);
    int i = 0;
    for (NSString *obj in coords) {
        NSArray *objArray = [NSArray seprateString:obj characterSet:@","];
        NSString *lat = [objArray firstObject];
        NSString *lng = [objArray lastObject];
        coordsC[i].latitude = [lat doubleValue];
        coordsC[i].longitude = [lng doubleValue];
        i ++;
    }
    return coordsC;
}

+ (NSString *)getDeviceIdFromUserDefault
{
    return [PH_UserDefaults valueForKey:PH_UniqueDeviceId];
}
+ (NSString *)getAppidFromUserDefault
{
    return [PH_UserDefaults valueForKey:PH_UniqueAppid];
}
+ (void)loginSuccessWithAppid:(NSString *)appidString
                        devid:(NSString *)devidString
                  accessToken:(NSString *)accessToken
{
    [PH_UserDefaults setBool:YES forKey:@"是否开启消息推送"];
    [PH_UserDefaults setObject:devidString forKey:PH_UniqueDeviceId];
    [PH_UserDefaults setObject:appidString forKey:PH_UniqueAppid];
    [PH_UserDefaults setObject:accessToken forKey:PH_UniqueAccess_token];
    [PH_UserDefaults setBool:YES forKey:PH_LoginSuccess];
    [PH_UserDefaults synchronize];
}
#pragma mark 包大小转换工具类（将包大小转换成合适单位）
+ (NSString *)getDataSizeString:(int)nSize
{
    NSString *string = nil;
    if (nSize<1024)
    {
        string = [NSString stringWithFormat:@"%dB", nSize];
    }
    else if (nSize<1048576)
    {
        string = [NSString stringWithFormat:@"%dK", (nSize/1024)];
    }
    else if (nSize<1073741824)
    {
        if ((nSize%1048576)== 0 )
        {
            string = [NSString stringWithFormat:@"%dM", nSize/1048576];
        }
        else
        {
            int decimal = 0; //小数
            NSString* decimalStr = nil;
            decimal = (nSize%1048576);
            decimal /= 1024;
            
            if (decimal < 10)
            {
                decimalStr = [NSString stringWithFormat:@"%d", 0];
            }
            else if (decimal >= 10 && decimal < 100)
            {
                int i = decimal / 10;
                if (i >= 5)
                {
                    decimalStr = [NSString stringWithFormat:@"%d", 1];
                }
                else
                {
                    decimalStr = [NSString stringWithFormat:@"%d", 0];
                }
                
            }
            else if (decimal >= 100 && decimal < 1024)
            {
                int i = decimal / 100;
                if (i >= 5)
                {
                    decimal = i + 1;
                    
                    if (decimal >= 10)
                    {
                        decimal = 9;
                    }
                    
                    decimalStr = [NSString stringWithFormat:@"%d", decimal];
                }
                else
                {
                    decimalStr = [NSString stringWithFormat:@"%d", i];
                }
            }
            
            if (decimalStr == nil || [decimalStr isEqualToString:@""])
            {
                string = [NSString stringWithFormat:@"%dMss", nSize/1048576];
            }
            else
            {
                string = [NSString stringWithFormat:@"%d.%@M", nSize/1048576, decimalStr];
            }
        }
    }
    else	// >1G
    {
        string = [NSString stringWithFormat:@"%dG", nSize/1073741824];
    }
    
    return string;
}
/**
 1、如果有设置传入参数:(时间格式)，则使用传入的格式
 2、否则，将时间转化成这样的格式：MM/dd/yyyy HH:mm:ss
 */
+ (NSString *)convertTime:(id)gpsTime withDateFormate:(NSString *)dateF
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[gpsTime doubleValue]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (!dateF) {
        [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    }
    else
    {
        [dateFormatter setDateFormat:dateF];
    }
    return [dateFormatter stringFromDate:date];
}
#pragma mark - 计算2个经纬度之间的直线距离
/**
 *  计算2个经纬度之间的直线距离
 */
+ (CLLocationDistance)calculateLineDistanceWithSourceCoordinate:(CLLocationCoordinate2D)source andDestinationCoordinate:(CLLocationCoordinate2D)destination
{
    // 计算2个经纬度之间的直线距离
    CLLocation *loc1 = [[CLLocation alloc] initWithLatitude:source.latitude longitude:source.longitude  ];
    CLLocation *loc2 = [[CLLocation alloc] initWithLatitude:destination.latitude longitude:destination.longitude];
    CLLocationDistance distance = [loc1 distanceFromLocation:loc2];
    //    NSLog(@"两个坐标之间的距离==%.2f", distance);
    return distance;
}

/**
 *  数组归档
 *
 *  @param memberArray memberArray 接收的参数NSMutableArray
 *  @param filePath    filePath 文件路径
 *
 *  @return BOOL
 */
+ (BOOL)encoderObjectArray:(NSMutableArray *)memberArray path:(NSString *)filePath
{
    PHLog(@"%ld",(long)memberArray.count);
    NSMutableData *mutableData = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:mutableData];
    [archiver encodeObject:memberArray forKey:PHArchiver_memberArray];
    [archiver finishEncoding];
    return [mutableData writeToFile:filePath atomically:YES];
}
/**
 *   数组解档
 *
 *  @param filePath filePath 文件路径
 *
 *  @return 返回一个NSMutableArray
 */
+ (NSMutableArray *)decoderObjectPath:(NSString *)filePath
{
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSKeyedUnarchiver *unarc = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSArray *array = [unarc decodeObjectForKey:PHArchiver_memberArray];
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithArray:array];
    return mutableArray;
}
@end
