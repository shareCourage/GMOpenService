//
//  PHTest.m
//  New_Simplify
//
//  Created by Kowloon on 15/8/31.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import "PHTest.h"
#import <AdSupport/AdSupport.h>
#import "GMOpenUDID.h"

@interface PHTest ()
{
    int _number;
}
@property(nonatomic, strong)GMNearbyManager *nearByManager;//测试，可以删除

@end

@implementation PHTest

- (GMNearbyManager *)nearByManager
{
    if (_nearByManager == nil) {
        _nearByManager = [GMNearbyManager manager];
    }
    return _nearByManager;
}
- (void)test
{
    GMDeviceInfo *deviceInfo = [[GMDeviceInfo alloc] init];
    GMDeviceInfo *deviceInfo2 = [[GMDeviceInfo alloc] init];
    
    _number = _number + 200;
    [PH_UserDefaults setObject:@(_number) forKey:@"numberforkey"];
    [PH_UserDefaults synchronize];
    deviceInfo.devid = @"1234567890";
    deviceInfo.lat = [NSString stringWithFormat:@"23.%06d",_number];
    deviceInfo.lng = [NSString stringWithFormat:@"113.%06d",_number - 80];
    deviceInfo.gps_time = [NSString stringWithFormat:@"%.f",[NSDate date].timeIntervalSince1970];
    
    deviceInfo2.devid = @"1212";
    deviceInfo2.lat = @"23.540565";
    deviceInfo2.lng = @"114.067614";
    deviceInfo2.gps_time = deviceInfo.gps_time;
    
    
#if 0
    [self.nearByManager uploadMuchOfDeviceInfos:@[deviceInfo,deviceInfo2] completionBlock:^(BOOL success) {
        success ? PHLog(@"上传成功") : PHLog(@"上传失败");
    } failureBlock:nil];
#endif
    
#if 0
    [self.nearByManager uploadDeviceInfo:deviceInfo2 successBlock:^(NSDictionary *dict) {
        PHLog(@"testDictSINGLE -> %@",dict[@"msg"]);
    } failureBlock:nil];
#endif
    //    GMHistoryManager *history = [GMHistoryManager manager];
    
#if 0
    [history getNewestInformationWithDeviceIds:@[@"1234567890",@"1212"] successBlock:^(NSDictionary *dict) {
        PHLog(@"\n\n~~~~~~~~\n%@",dict);
    } failureBlock:nil];
    
    [history getNewestInformationWithDeviceIds:@[@"1234567890",@"1212"] successBlockArray:^(NSArray *array) {
        for (GMDeviceInfo *obj in array) {
            PHLog(@"____%@",obj.devid);
        }
    } failureBlock:nil];
    
#endif
    //    GMFenceManager *fenceM = [GMFenceManager manager];
    
#if 0
    [fenceM inquireFenceWithDeviceId:@"1234567890" successBlock:^(NSDictionary *dict) {
        //        PHLog(@"device_fenceM->%@",dict);
    } failureBlock:nil];
    [fenceM inquireFenceWithDeviceId:@"1234567890" successBlockArray:^(NSArray *array) {
        PHLog(@"~~array_fenceM->%ld",(long)array.count);
        for (GMFenceInfo *fence in array) {
            PHLog(@"%@",fence.devInOut.devid);
        }
    } failureBlock:nil];
#endif
    
#if 0
    [fenceM inquireFenceWithFenceId:@"3305198" successBlock:^(NSDictionary *dict) {
        PHLog(@"fence_fenceM->%@\n",dict);
    } failureBlock:nil];
    
    [fenceM inquireFenceWithFenceId:@"3305198" successBlockFenceInfo:^(GMFenceInfo *fenceInfo) {
        PHLog(@"%@",fenceInfo);
        
    } failureBlock:nil];
#endif
    
}

- (void)alarmTest
{
    GMAlarmManager *alarmM = [GMAlarmManager manager];
    [alarmM getAlarmInformationWithDevid:@"1212" completionBlock:^(NSArray *array) {
        PHLog(@"alarmArray - > %@",array);
    } failureBlock:nil];
}
+ (void)reverseTest
{
    GMNearbyManager *nearby = [GMNearbyManager manager];
    nearby.mapType = GMMapTypeOfGOOGLE;
    int maxCount = 250;
    CLLocationCoordinate2D *coords = malloc(sizeof(CLLocationCoordinate2D) * maxCount);
    for (int i = 0; i < maxCount; i ++) {
        coords[i] = CLLocationCoordinate2DMake(40.028830, 116.405911);
    }
    //    coords[0] = CLLocationCoordinate2DMake(40.028830, 116.405911);
    //    coords[1] = CLLocationCoordinate2DMake(40.128830, 116.505911);
    //    coords[2] = CLLocationCoordinate2DMake(22.495726, 113.940489); //广东省.深圳市.宝安区.梅坂大道.离南粤港酒楼约41米
    //    coords[3] = CLLocationCoordinate2DMake(22.442726, 114.151489);
    [nearby reverseGeocode:coords count:maxCount completionBlock:^(NSArray *array) {
        for (GMGeocodeResult *result in array) {
            PHLog(@"%@, %.6f, %.6f, num -> %ld",result.address, result.location.latitude, result.location.longitude, array.count);
        }
    } failureBlock:nil];
    free(coords);
    
}

- (void)uniqueIDTest
{
    ASIdentifierManager *as = [ASIdentifierManager sharedManager];
    PHLog(@"\n vendor -> %@\n openudid -> %@ \n identifier -> %@, %@",[NSString currentDeviceNSUUID], [GMOpenUDID value],as.advertisingIdentifier.UUIDString, [NSString digitUppercaseWithMoney:@"100001"]);
    //paul
    //vendor    :6F467665-FD78-4311-BC64-E6E5541B7720
    //openudid  :ebd34d0085fb40719f5b292a4e8752971cce0e69
    //identifier:05793FB6-A64F-4992-A196-325796D8C176
}

@end
