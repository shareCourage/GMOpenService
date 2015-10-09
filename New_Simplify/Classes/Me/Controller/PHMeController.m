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
#import "PHRemoteViewController.h"
@interface PHMeController () <CLLocationManagerDelegate>
{
    CLLocationManager *_locationManager;
}
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
- (void)locationManager {
    // 1. 实例化定位管理器
    _locationManager = [[CLLocationManager alloc] init];
    // 2. 设置代理
    _locationManager.delegate = self;
    // 3. 定位精度
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    // 4.请求用户权限：分为：⓵只在前台开启定位⓶在后台也可定位，
    //注意：建议只请求⓵和⓶中的一个，如果两个权限都需要，只请求⓶即可，
    //⓵⓶这样的顺序，将导致bug：第一次启动程序后，系统将只请求⓵的权限，⓶的权限系统不会请求，只会在下一次启动应用时请求⓶
    if (PH_iOS(8.0)) {
//        [_locationManager requestWhenInUseAuthorization];//⓵只在前台开启定位 旅游
        [_locationManager requestAlwaysAuthorization];//⓶在后台也可定位
    }
    // 5.iOS9新特性：将允许出现这种场景：同一app中多个location manager：一些只能在前台定位，另一些可在后台定位（并可随时禁止其后台定位）。
    if (PH_iOS(9.0)) {
#ifdef __IPHONE_9_0
        _locationManager.allowsBackgroundLocationUpdates = YES;
#endif
    }
    // 6. 更新用户位置
    [_locationManager startUpdatingLocation];
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"我的设备";
    self.navigationItem.title = @"我的设备";
    [self barButtonItemImplementation];
#ifdef DEBUG
    [self locationManager];
#endif
    
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    if (delegate.remoteAlarmInfo.length != 0) {
        PHRemoteViewController *remoteVC = [[PHRemoteViewController alloc] init];
        remoteVC.remoteAlarmInfo = delegate.remoteAlarmInfo;
        [self.navigationController pushViewController:remoteVC animated:YES];
    }
}
- (void)viewControllerDidEnterBackground {
    [super viewControllerDidEnterBackground];
    [self viewWillDisappear:YES];
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

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations firstObject];
    PHLog(@"location ->  %.6f, %.6f", location.coordinate.latitude, location.coordinate.longitude);
}
@end














