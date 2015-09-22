//
//  AppDelegate.m
//  New_Simplify
//
//  Created by Kowloon on 15/7/7.
//  Copyright (c) 2015年 Goome. All rights reserved.
//
#define GM_Appid [PH_UserDefaults objectForKey:PH_UniqueAppid]
#define PH_HeightOfRemoteNotificationLabel 30

#import "AppDelegate.h"
#import "PHLoginController.h"
#import <BaiduMapAPI/BMapKit.h>
#import "GMOpenKit.h"
#import "PHNavigationController.h"
#import "PHHistoryLoc.h"
#import "PHFenceListController.h"
#import "PHRemoteViewController.h"
#import <AudioToolbox/AudioToolbox.h>
@interface AppDelegate ()<BMKGeneralDelegate>
{
    BMKMapManager * _bmkManager;
}
@property (nonatomic, strong) NSTimer *myTimer;//周期获取设备历史位置信息定时器

@property (nonatomic, strong) UIView *remoteNotificationView;
@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation AppDelegate
- (void)remoteNotificationViewInstance {
    if (!_remoteNotificationView) {
        _remoteNotificationView = [[UIView alloc] initWithFrame:CGRectMake(0, - PH_HeightOfRemoteNotificationLabel, PH_WidthOfScreen, PH_HeightOfRemoteNotificationLabel)];
        _remoteNotificationView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8f];
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, PH_WidthOfScreen, PH_HeightOfRemoteNotificationLabel)];
        _tipLabel.textColor = [UIColor whiteColor];
        _tipLabel.font = [UIFont systemFontOfSize:15.f];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        [_remoteNotificationView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(remoteNotificationLabelClick)]];
        [self.window addSubview:_remoteNotificationView];
        [_remoteNotificationView addSubview:_tipLabel];
    }
}

- (UIView *)remoteNotificationView {
    if (!_remoteNotificationView) {
        [self remoteNotificationViewInstance];
    }
    _remoteNotificationView.userInteractionEnabled = YES;
    return _remoteNotificationView;
}
- (void)remoteNotificationLabelClick {
    UITabBarController *tabBar = (UITabBarController *)[UIViewController activityViewController];
    PHNavigationController *navi = (PHNavigationController *)tabBar.selectedViewController;
    PHRemoteViewController *remoteVC = [[PHRemoteViewController alloc] init];
    remoteVC.remoteAlarmInfo = self.remoteAlarmInfo;
    [navi pushViewController:remoteVC animated:YES];
    self.remoteNotificationView.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.5f animations:^{
        self.remoteNotificationView.frame = CGRectMake(0, - PH_HeightOfRemoteNotificationLabel, PH_WidthOfScreen, PH_HeightOfRemoteNotificationLabel);
    } completion:nil];
}

- (GMHistoryManager *)hisM
{
    if (!_hisM) {
        _hisM = [GMHistoryManager manager];
        _hisM.mapType = GMMapTypeOfBAIDU;
    }
    if (_hisM.deviceId.length == 0) {
        _hisM.deviceId = [PHTool getDeviceIdFromUserDefault];
    }
    return _hisM;
}

- (void)loadHistoryDataToLocal//把服务器近两个月时间的数据全部加载到本地
{
    PHHistoryLoc *hisLoc = [self.hisM selectMaxGpstimeHistoryInfosWithDevice:[[PHHistoryLoc alloc] init]];
    NSTimeInterval end = [NSDate date].timeIntervalSince1970;
    NSTimeInterval start = end - 2 * 30 * 24 * 60 * 60;//计算出两个月之前的那个时间点
    self.hisM.startTime = hisLoc.gps_time.length == 0 ? [NSString stringWithFormat:@"%.f",start] : hisLoc.gps_time;//如果数据库当中没有时间，就从当前时间的前两个月算起，从服务器中读取
    self.hisM.endTime = [NSString stringWithFormat:@"%.f",end];
//    PHLog(@"start ->%@, end -> %@", self.hisM.startTime, self.hisM.endTime);
    PH_WS(ws);
    [self.hisM getHistoryInformationAndSaveToLocalDatabaseWithCompletion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [ws.myTimer fire];
        });
    }];
    [self invalidateMytimer];//把定时器干掉的目的是为了，当内部在加载历史位置信息时，不至于这里又重复去请求数据。只有当数据请求完成之后，执行内部的block，再来启动定时器.
}

- (NSTimer *)myTimer
{
    if (_myTimer == nil) {
        _myTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(loadHistoryDataToLocal) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_myTimer forMode:NSRunLoopCommonModes];
    }
    return _myTimer;
}

- (void)dealloc {
    [self invalidateMytimer];
}

- (void)invalidateMytimer {
    [self.myTimer invalidate];
    self.myTimer = nil;
}
/**
 *  百度的密钥验证
 */
- (void)validateTheBMKKey
{
    _bmkManager = [[BMKMapManager alloc] init];
    BOOL flag = [_bmkManager start:PH_BaiduMap_AppKey generalDelegate:self];
//    flag ? PHLog(@"bmk->success") : PHLog(@"bmk->fail");
}

- (void)validateTheGMAppid
{
    GMOpenManager *open = [GMOpenManager manager];
    NSString *appid = GM_Appid;
    [open validateWithKey:appid completionBlock:^(GMOpenPermissionStatus status) {
//        status == GMOpenPermissionStatusOfSuccess ? PHLog(@"appid validate success") : PHLog(@"appid validate failure");
    }];
    
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self validateTheBMKKey];//验证百度地图是否正确
    [self validateTheGMAppid];
    if (PH_iOS(8.0)) {
        [GMPushManager iOS8RegisterForRemoteNotificationTypes:(UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound) categories:nil];
    }
    else {
        [GMPushManager iOS7RegisterForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    }
    [GMPushManager setupWithOption:launchOptions];
    if (launchOptions) {//判断推送来的时候(app被干掉的情况下),点击推送图标执行的语句
        NSDictionary *alarmInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
        NSString *alarm = alarmInfo[@"alarm"];
        self.remoteAlarmInfo = alarm;
    }
    if (!PH_BoolForKey(PH_LoginSuccess)) {
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [self.window makeKeyAndVisible];
        [PHTool loginViewControllerImplementation];
    }
    [self.myTimer fire];
    
    
    return YES;
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    PHLog(@"deviceToken ->%@",deviceToken);
    NSData *oldToken = [[NSUserDefaults standardUserDefaults] objectForKey:PH_KeyOfDeviceToken];
    if ([deviceToken isEqualToData:oldToken]) {
        return;
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:deviceToken forKey:PH_KeyOfDeviceToken];
    }
    [GMPushManager registerDeviceToken:deviceToken];
    [PH_UserDefaults setObject:deviceToken forKey:PH_UniqueDevicetoken];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    PHLog(@"failToRegister -> %@",error);
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    PHLog(@"applicationDidEnterBackground");
    [PH_UserDefaults setBool:YES forKey:PH_DidEnterBackground];
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    PHLog(@"applicationDidBecomeActive");
    [PH_UserDefaults setBool:NO forKey:PH_DidEnterBackground];
}

//这个方法会比applicationDidBecomeActive早一步执行完成
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    PHLog(@"~~~~~~~~~~~~~~~~~~~~~~~~~~didReceiveRemoteNotification~~~~~~~~~~~~~~~~~~~~~~~~~->\n%@",userInfo);
    [GMPushManager handleRemoteNotification:userInfo];
    if (userInfo) {
        NSString *alarm = userInfo[@"alarm"];
        self.remoteAlarmInfo = alarm;
        NSArray *arraySep = [NSArray seprateString:alarm characterSet:@","];
        NSString *deviceId = [arraySep firstObject];
        NSString *status = arraySep[1];
        NSString *fenceid = [arraySep lastObject];
        NSString *fenceIdADD = [fenceid stringByAppendingString:@" 围栏"];
        NSString *fenceName = [NSString getFenceNameFromUserInfo:userInfo];
        NSString *information = [NSString stringWithFormat:@"设备%@ %@ %@",deviceId, [status isEqualToString:@"1"] ? @"进入" : @"离开", fenceName.length == 0 ? fenceIdADD : [fenceName stringByAppendingString:@" 围栏"]];
        if (PH_BoolForKey(PH_DidEnterBackground)) {//如果是点击系统的推送消息进来，那么执行下面代码
            [self remoteNotificationLabelClick];
        } else {//如果是app在前台，那么执行下面的代码
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            [self remoteNotificationViewInstance];
            [self.window bringSubviewToFront:self.remoteNotificationView];//加这句话的目的是为了解决重新注销登录切换窗口后显示通知的bug
            [self remoteNotificationLabelDisplayWithInfo:information application:application];
        }

    }
    
}
- (void)remoteNotificationLabelDisplayWithInfo:(NSString *)info application:(UIApplication *)application {
    self.tipLabel.text = info;
    [UIView animateWithDuration:0.5f animations:^{
        self.remoteNotificationView.frame = CGRectMake(0, 0, PH_WidthOfScreen, PH_HeightOfRemoteNotificationLabel);
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5f animations:^{
                self.remoteNotificationView.frame = CGRectMake(0, - PH_HeightOfRemoteNotificationLabel, PH_WidthOfScreen, PH_HeightOfRemoteNotificationLabel);
            } completion:^(BOOL finished) {
                self.remoteNotificationView.frame = CGRectMake(0, - PH_HeightOfRemoteNotificationLabel, PH_WidthOfScreen, PH_HeightOfRemoteNotificationLabel);
            }];
        });
    }];
}

#pragma mark - BMKGeneralDelegate
/**
 *返回网络错误
 *@param iError 错误号  222221121122
 */
- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        PHLog(@"联网成功");
    }
    else{
        PHLog(@"onGetNetworkState %d",iError);
    }
}

/**
 *返回授权验证错误
 *@param iError 错误号 : 为0时验证通过，具体参加BMKPermissionCheckResultCode
 */
- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        PHLog(@"授权成功");
    }
    else {
        PHLog(@"onGetPermissionState %d",iError);
    }
}









@end










