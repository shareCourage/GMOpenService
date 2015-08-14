//
//  PHMeController.m
//  SimplifiedApp
//
//  Created by Kowloon on 15/4/21.
//  Copyright (c) 2015年 Goome. All rights reserved.
//
#define PH_NSTimer_time 3.0f
#import "PHMeController.h"
#import "PHDeviceInfo.h"
#import "PHBaiduMapView.h"
#import "GMDevInOut.h"
#import "GMOpenUDID.h"
#import <AdSupport/AdSupport.h>

@interface PHMeController ()
{
    int _number;
}
@property(nonatomic, strong)NSTimer *myTimer;//周期获取设备最新位置定时器
@property (weak, nonatomic) IBOutlet PHBaiduMapView *baiDuMapView;

@property(nonatomic, strong)GMNearbyManager *nearByManager;//测试，可以删除

@end

@implementation PHMeController
- (GMNearbyManager *)nearByManager
{
    if (_nearByManager == nil) {
        _nearByManager = [GMNearbyManager manager];
    }
    return _nearByManager;
}
- (void)dealloc
{
    PHLog(@"PHMeController.h->dealloc");
    [self invalidateTimer];
    
}
//干掉定时器
- (void)invalidateTimer
{
    [self.myTimer invalidate];
    self.myTimer = nil;
}
- (NSTimer *)myTimer
{
    if (_myTimer == nil) {
        _myTimer = [NSTimer scheduledTimerWithTimeInterval:PH_NSTimer_time target:self selector:@selector(getDeviceIdInfomation) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_myTimer forMode:NSRunLoopCommonModes];
    }
    return _myTimer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的设备";
    NSNumber *number = [PH_UserDefaults objectForKey:@"numberforkey"];
    _number = [number intValue];
    
    ASIdentifierManager *as = [ASIdentifierManager sharedManager];
    PHLog(@"\n vendor -> %@\n openudid -> %@ \n identifier -> %@",[NSString currentDeviceNSUUID], [GMOpenUDID value],as.advertisingIdentifier.UUIDString);
    //paul
    //vendor    :6F467665-FD78-4311-BC64-E6E5541B7720
    //openudid  :ebd34d0085fb40719f5b292a4e8752971cce0e69
    //identifier:05793FB6-A64F-4992-A196-325796D8C176
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.baiDuMapView baiduMapViewWillAppear];
    [self.myTimer fire];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.baiDuMapView baiduMapViewWillDisappear];
    [self invalidateTimer];
}

//根据devId号，获取信息当前最新位置信息
- (void)getDeviceIdInfomation
{

    PH_WS(ws);
    GMHistoryManager *history = [GMHistoryManager manager];
//    history.mapType = GMMapTypeOfBAIDU;
    history.deviceId = [PHTool getDeviceIdFromUserDefault];
    [history getNewestInformationSuccessBlock:^(NSDictionary *dict) {
        PHLog(@"%@",dict);
        NSArray *array = dict[PH_ConnectedArgument_data];
        if (array.count != 0) {
            PHDeviceInfo *device = [PHDeviceInfo createDeviceWithDict:[array firstObject]];
            ws.baiDuMapView.device = device;
        }
    } failureBlock:^(NSError *error) {
        if (error) PHLog(@"error %@",error);
    }];
    
    [self test];
    [self alarmTest];

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
@end














