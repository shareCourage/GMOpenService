//
//  PHSettingViewController.m
//  FamilyCare
//
//  Created by Kowloon on 15/2/27.
//  Copyright (c) 2015年 Goome. All rights reserved.
//
#define PH_Setting_Open_UploadMyLocation     @"开启上传位置"
#define PH_Setting_TelephoneLinkAccount      @"手机账号绑定"
#define PH_Setting_About                     @"关于"
#define PH_Setting_MessageTips               @"消息设置"
#define PH_Setting_LogOut                    @"注销当前账户"
#define PH_Setting_OffLineMap                @"离线地图"
#define PH_Setting_CountOfRemotePush         @"远程推送总数"
#import "PHSettingViewController.h"
#import "PHAcountLinkViewController.h"
#import "PHMessageTipsViewController.h"
#import "PHAboutViewController.h"
#import "PHUploadLocController.h"
#import "PHLoginController.h"
#import "PHOfflineMapController.h"
#import "PHDeviceInfoController.h"
#import "PHPushViewController.h"
#import "PHAlarmInfoController.h"
#import "PHHistoryLocationController.h"
#import "PHNearbyPeopleController.h"
#import "PHHeatMapController.h"
#import "PHSettingGroup.h"
#import "PHSettingItem.h"
#import "PHSettingArrowItem.h"
#import "PHSettingSwitchItem.h"
#import "PHNavigationController.h"
#import "AppDelegate.h"
@interface PHSettingViewController ()<UIAlertViewDelegate>
{
    int _pushNumber;
}
@property(nonatomic, strong)UIAlertView *alertView;
@property(nonatomic, strong)UIAlertView *alertViewTwo;
@end

@implementation PHSettingViewController
- (void)dealloc
{
    PHLog(@"PHSettingViewController->dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}
/**
 *  第1组数据
 */
- (void)telephoneLinkAccount
{
    PHSettingItem *account = [PHSettingArrowItem itemWithTitle:PH_Setting_TelephoneLinkAccount destVcClass:[PHAcountLinkViewController class]];
    PHSettingGroup *group = [[PHSettingGroup alloc] init];
    group.items = @[account];
    [self.dataSource addObject:group];
}

/**
 *  第2组数据
 */
- (void)messageTips
{
    PHSettingItem *message = [PHSettingArrowItem itemWithTitle:PH_Setting_MessageTips destVcClass:[PHMessageTipsViewController class]];
    PHSettingGroup *group = [[PHSettingGroup alloc] init];
    group.items = @[message];
    [self.dataSource addObject:group];
}
/**
 *  第3组数据
 */
- (void)aboutGoome
{
    
}

/**
 *  第4组数据
 */
- (void)uploadMylocation
{
    PHSettingItem *upload = [PHSettingSwitchItem itemWithTitle:PH_Setting_Open_UploadMyLocation destVcClass:[PHUploadLocController class]];
    PHSettingGroup *group = [[PHSettingGroup alloc] init];
    group.items = @[upload];
    [self.dataSource addObject:group];
}

/**
 *  第5组数据
 */
- (void)logOutAccount
{
    PHSettingItem *logout = [PHSettingArrowItem itemWithTitle:PH_Setting_LogOut];
    self.alertView = [[UIAlertView alloc] initWithTitle:@"注销当前账户" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    PH_WS(ws);
    logout.option = ^{
        [ws.alertView show];
    };
    PHSettingItem *about = [PHSettingArrowItem itemWithTitle:PH_Setting_About destVcClass:[PHAboutViewController class]];
    PHSettingGroup *group = [[PHSettingGroup alloc] init];
    group.items = @[about,logout];
    [self.dataSource addObject:group];
}
/**
 *  第6组数据
 */
- (void)setupOffLineMap
{
    PHSettingItem *account = [PHSettingArrowItem itemWithTitle:PH_Setting_OffLineMap destVcClass:[PHOfflineMapController class]];
//    NSString *muString = @"下载后,没网也能用";
//    account.subtitle = muString;
    PHSettingGroup *group = [[PHSettingGroup alloc] init];
    group.items = @[account];
    [self.dataSource addObject:group];
}
/**
 *  第7组数据
 */
- (void)currentDeviceID
{
    PHSettingItem *deviceId = [PHSettingArrowItem itemWithTitle:@"当前设备信息" destVcClass:[PHDeviceInfoController class]];
    PHSettingItem *alarm = [PHSettingArrowItem itemWithTitle:@"历史报警消息" destVcClass:[PHAlarmInfoController class]];
    PHSettingItem *push = [PHSettingArrowItem itemWithTitle:@"消息推送" destVcClass:[PHPushViewController class]];

    PHSettingGroup *group = [[PHSettingGroup alloc] init];
    group.items = @[alarm, push, deviceId,];
    [self.dataSource addObject:group];
}


- (void)nearbyAndHistorys
{
    PHSettingItem *nearby = [PHSettingArrowItem itemWithTitle:@"附近的人" destVcClass:[PHNearbyPeopleController class]];
    PHSettingItem *history = [PHSettingArrowItem itemWithTitle:@"历史位置记录" destVcClass:[PHHistoryLocationController class]];
    PHSettingItem *heat = [PHSettingArrowItem itemWithTitle:@"历史位置热地图" destVcClass:[PHHeatMapController class]];
    PHSettingGroup *group = [[PHSettingGroup alloc] init];
    group.items = @[nearby, history, heat];
    [self.dataSource addObject:group];
}

/**
 *  计算消息的推送总数
 */
- (void)calculateThePushNumber
{
    PHSettingItem *push = [PHSettingItem itemWithTitle:PH_Setting_CountOfRemotePush];
    push.subtitle = @"0";
    self.alertViewTwo = [[UIAlertView alloc] initWithTitle:@"清空当前值" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    PH_WS(ws);
    push.option = ^{
        [ws.alertViewTwo show];
    };
    PHSettingGroup *group = [[PHSettingGroup alloc] init];
    group.items = @[push];
    [self.dataSource addObject:group];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushNumber:) name:PH_PushNotification object:nil];
}
- (void)pushNumber:(NSDictionary *)info
{
    _pushNumber ++;
    [self pushReloadData];
}
- (void)pushReloadData
{
    PHSettingGroup *group = self.dataSource[self.dataSource.count - 1];
    PHSettingItem *item = [group.items firstObject];
    item.subtitle = [NSString stringWithFormat:@"%d",_pushNumber];
    [self.tableView reloadData];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 1.标题
    self.navigationItem.title = @"设置";
    // 2.添加数据
//    [self telephoneLinkAccount];
//    [self messageTips];
//    [self uploadMylocation];
    [self setupOffLineMap];
    
    [self currentDeviceID];
    
//    [self nearbyAndHistorys];
    
    [self logOutAccount];

//    [self calculateThePushNumber];

}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == self.alertView) {
        if (buttonIndex == 1) {
            if (PH_BoolForKey(PH_LoginSuccess)) {
                GMLoginManager *login = [GMLoginManager manager];
                [MBProgressHUD showMessage:@"注销中..." toView:self.view];
                [login logoutWithDevid:[PHTool getDeviceIdFromUserDefault] completionBlock:^(BOOL success) {
                    if (success) {
                        [MBProgressHUD hideHUDForView:self.view];
                        [PH_UserDefaults setBool:NO forKey:PH_LoginSuccess];
                        [PH_UserDefaults setBool:NO forKey:@"是否开启消息推送"];
                        [PH_UserDefaults setObject:nil forKey:PH_UniqueAccess_token];
                        [PH_UserDefaults setObject:nil forKey:PH_UniqueAppid];
                        [PH_UserDefaults setObject:nil forKey:PH_UniqueDeviceId];
                        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
                        delegate.remoteAlarmInfo = nil;
                        [PH_UserDefaults synchronize];
                        [PHTool loginViewControllerImplementation];
                    }
                } failureBlock:nil];
            }
        }
    }
    else if (alertView == self.alertViewTwo) {
        if (buttonIndex == 1) {
            _pushNumber = 0;
            [self pushReloadData];
        }
    }
    
}

@end




