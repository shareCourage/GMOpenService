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
#import "PHMeMapView.h"
@interface PHMeController ()

@property(nonatomic, strong)NSTimer *myTimer;//周期获取设备最新位置定时器
@property (weak, nonatomic) IBOutlet PHMeMapView *meMapView;


@end

@implementation PHMeController

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

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.meMapView baiduMapViewWillAppear];
    [self.myTimer fire];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.meMapView baiduMapViewWillDisappear];
    [self invalidateTimer];
}

//根据devId号，获取信息当前最新位置信息
- (void)getDeviceIdInfomation
{
    PH_WS(ws);
    GMHistoryManager *history = [GMHistoryManager manager];
    history.mapType = GMMapTypeOfBAIDU;
    history.deviceId = [PHTool getDeviceIdFromUserDefault];
    [history getNewestInformationSuccessBlockDeviceInfo:^(GMDeviceInfo *deviceInfo) {
        ws.meMapView.device = deviceInfo;
    } failureBlock:^(NSError *error) {
        if (error) PHLog(@"error %@",error);
    }];
}



@end














