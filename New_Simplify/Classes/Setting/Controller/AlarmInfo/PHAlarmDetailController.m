//
//  PHAlarmDetailController.m
//  New_Simplify
//
//  Created by Kowloon on 15/8/19.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import "PHAlarmDetailController.h"
#import "GMAlarmInfo.h"
#import "PHSettingGroup.h"
#import "PHSettingItem.h"
@interface PHAlarmDetailController ()

@end

@implementation PHAlarmDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupGroupOne];
}
/**
 *  第1组数据
 */
- (void)setupGroupOne
{
    PHSettingItem *one = [PHSettingItem itemWithTitle:@"报警序号"];
    one.subtitle = self.alarmInfo.alarmId;
    
    PHSettingItem *two = [PHSettingItem itemWithTitle:@"报警状态"];
    two.subtitle = [self.alarmInfo.typeId isEqualToString:@"1"] ? @"进入围栏" : @"离开围栏";
    
    PHSettingItem *three = [PHSettingItem itemWithTitle:@"GPS时间"];
    three.subtitle = self.alarmInfo.gpsTime;
    
    PHSettingItem *four = [PHSettingItem itemWithTitle:@"纬度"];
    four.subtitle = self.alarmInfo.lat;
    
    PHSettingItem *five = [PHSettingItem itemWithTitle:@"经度"];
    five.subtitle = self.alarmInfo.lng;
    
    PHSettingItem *six = [PHSettingItem itemWithTitle:@"速度"];
    six.subtitle = self.alarmInfo.speed;
    
    PHSettingItem *seven = [PHSettingItem itemWithTitle:@"方向"];
    seven.subtitle = self.alarmInfo.course;
    
    PHSettingItem *eight = [PHSettingItem itemWithTitle:@"报警时间"];
    eight.subtitle = self.alarmInfo.alartTime;
    
    PHSettingItem *night = [PHSettingItem itemWithTitle:@"围栏号"];
    night.subtitle = self.alarmInfo.fenceId;
    
    PHSettingGroup *group = [[PHSettingGroup alloc] init];
    group.items = @[one,two,three,four,five,six,seven,eight,night];
    [self.dataSource addObject:group];
}
@end











