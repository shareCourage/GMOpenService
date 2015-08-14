//
//  PHUploadLocController.m
//  SimplifiedApp
//
//  Created by Kowloon on 15/4/22.
//  Copyright (c) 2015年 Goome. All rights reserved.
//
#define PH_Setting_UpLoadLocation_PowerSaving    @"省电模式"
#define PH_Setting_UpLoadLocation_TenMins        @"10分钟上传一次"
#define PH_Setting_UpLoadLocation_ThirtyMins     @"30分钟上传一次"
#define PH_Setting_UpLoadLocation_OneHour        @"1个小时上传一次"

#import "PHUploadLocController.h"
#import "PHSettingGroup.h"
#import "PHSettingItem.h"
#import "PHSettingSelectedItem.h"
@interface PHUploadLocController ()

@end

@implementation PHUploadLocController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupGroupOne];
    
}
/**
 *  第1组数据
 */
- (void)setupGroupOne
{
    PHSettingItem *one = [PHSettingSelectedItem itemWithTitle:PH_Setting_UpLoadLocation_PowerSaving withSelected:PH_BoolForKey(PH_Setting_UpLoadLocation_PowerSaving)];
    PHSettingItem *two = [PHSettingSelectedItem itemWithTitle:PH_Setting_UpLoadLocation_TenMins withSelected:PH_BoolForKey(PH_Setting_UpLoadLocation_TenMins)];
    PHSettingItem *three = [PHSettingSelectedItem itemWithTitle:PH_Setting_UpLoadLocation_ThirtyMins withSelected:PH_BoolForKey(PH_Setting_UpLoadLocation_ThirtyMins)];
    PHSettingItem *four = [PHSettingSelectedItem itemWithTitle:PH_Setting_UpLoadLocation_OneHour withSelected:PH_BoolForKey(PH_Setting_UpLoadLocation_OneHour)];
    PHSettingGroup *group = [[PHSettingGroup alloc] init];
    group.items = @[one,two,three,four];
    [self.dataSource addObject:group];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    /**
     1、取出当前状态的所有值
     2、Controller即将消失时，存储起来
     */
    PHSettingGroup *group = self.dataSource[0];
    for (PHSettingSelectedItem *obj in group.items) {
        [PH_UserDefaults setBool:obj.selectedItem forKey:obj.title];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PHSettingGroup *group = self.dataSource[indexPath.section];
    PHSettingSelectedItem *item = group.items[indexPath.row];
    /**
     逻辑：
     1、取出所有的selectedItem状态，并且都设置成NO
     2、将当前选中的cell状态设置为YES
     3、刷新tableView
     */
    for (PHSettingSelectedItem *obj in group.items) {
        obj.selectedItem = NO;
    }
    item.selectedItem = YES;
    [tableView reloadData];
}
@end













