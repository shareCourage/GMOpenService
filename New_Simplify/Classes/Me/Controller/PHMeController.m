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
#import "AppDelegate.h"
@interface PHMeController ()

@property(nonatomic, strong)NSTimer *myTimer;//周期获取设备最新位置定时器
@property (weak, nonatomic) IBOutlet PHMeMapView *meMapView;

@property (nonatomic, strong)__block NSMutableArray *deviceInfos;

@end

@implementation PHMeController
- (NSMutableArray *)deviceInfos
{
    if (_deviceInfos == nil) {
        _deviceInfos = [NSMutableArray array];
    }
    if (_deviceInfos.count >= 100) {
        [_deviceInfos removeObjectAtIndex:0];
    }
    return _deviceInfos;
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
//    self.title = @"我的设备";
    self.navigationItem.title = @"我的设备";
    [self barButtonItemImplementation];
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
/**
 *  导航栏UIBarButtonItem的放置
 */
- (void)barButtonItemImplementation
{
    UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(removeMeMapPloyline)];
    deleteItem.tintColor = [UIColor blueColor];
    self.navigationItem.rightBarButtonItem = deleteItem;
}
//UIBarButtonItem->deleteFence执行，开启tableView的删除模式
- (void)removeMeMapPloyline
{
    [self.meMapView removeAllOfPolyline];
}
//根据devId号，获取信息当前最新位置信息
- (void)getDeviceIdInfomation
{
    PH_WS(ws);
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    [delegate.hisM getNewestInformationSuccessBlockDeviceInfo:^(GMDeviceInfo *deviceInfo) {
        [ws configMeMapViewWithDeviceInfo:deviceInfo];
    } failureBlock:^(NSError *error) {
        if (error) PHLog(@"error %@",error);
    }];
}

- (void)configMeMapViewWithDeviceInfo:(GMDeviceInfo *)deviceInfo
{
    self.meMapView.device = deviceInfo;
    [self.deviceInfos addObject:deviceInfo];
    NSUInteger count = self.deviceInfos.count;
    if (count >= 2) {
        [self.meMapView configurePolylineWithStartDevice:[self.deviceInfos objectAtIndex:count - 2] end:[self.deviceInfos lastObject]];
    }
}

@end














