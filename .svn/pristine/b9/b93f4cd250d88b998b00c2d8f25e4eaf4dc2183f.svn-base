//
//  PHDeviceInfoController.m
//  SimplifiedApp
//
//  Created by Kowloon on 15/5/22.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import "PHDeviceInfoController.h"
#import "PHSettingItem.h"
#import "PHSettingGroup.h"
@implementation PHDeviceInfoController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupGroupOne];
}
/**
 *  第1组数据
 */
- (void)setupGroupOne
{
    
    PHSettingItem *device = [PHSettingItem itemWithTitle:@"设备号"];
    device.subtitle = [PHTool getDeviceIdFromUserDefault];
    
    PHSettingItem *appid = [PHSettingItem itemWithTitle:@"Appid号"];
    appid.subtitle = [PHTool getAppidFromUserDefault];
    
    PHSettingGroup *group = [[PHSettingGroup alloc] init];
    group.items = @[appid,device];
    [self.dataSource addObject:group];
}
@end
