//
//  MessageTipsViewController.m
//  FamilyCare
//
//  Created by Kowloon on 15/2/27.
//  Copyright (c) 2015年 Goome. All rights reserved.
//
#define PH_MessageTips_Warn_Message         @"信息条提醒"
#define PH_MessageTips_Warn_PopUpWindow     @"弹出框提醒"
#define PH_MessageTips_Warn_Vibration       @"震动铃声提醒"
#import "PHMessageTipsViewController.h"
#import "PHSettingGroup.h"
#import "PHSettingItem.h"
#import "PHSettingSwitchItem.h"
@interface PHMessageTipsViewController ()

@end

@implementation PHMessageTipsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 2.添加数据
    [self setupGroupOne];
    [self setupGroupTwo];
}
/**
 *  第1组数据
 */
- (void)setupGroupOne
{
    PHSettingItem *message = [PHSettingSwitchItem itemWithTitle:PH_MessageTips_Warn_Message];
    PHSettingItem *tips = [PHSettingSwitchItem itemWithTitle:PH_MessageTips_Warn_PopUpWindow];
    PHSettingGroup *group = [[PHSettingGroup alloc] init];
    group.items = @[message,tips];
    [self.dataSource addObject:group];
}

/**
 *  第2组数据
 */
- (void)setupGroupTwo
{
    PHSettingItem *message = [PHSettingSwitchItem itemWithTitle:PH_MessageTips_Warn_Vibration];
    PHSettingGroup *group = [[PHSettingGroup alloc] init];
    group.items = @[message];
    [self.dataSource addObject:group];
}


@end




