//
//  PHAboutViewController.m
//  SimplifiedApp
//
//  Created by Kowloon on 15/4/22.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import "PHAboutViewController.h"
#import "PHSettingGroup.h"
#import "PHSettingItem.h"
@interface PHAboutViewController ()

@end

@implementation PHAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupGroupOne];
}
/**
 *  第1组数据
 */
- (void)setupGroupOne
{
    
    PHSettingItem *two = [PHSettingItem itemWithTitle:@"反馈QQ群"];
    two.subtitle = @"12213213";
    
    PHSettingItem *three = [PHSettingItem itemWithTitle:@"官方微博"];
    three.subtitle = @"谷米科技";
    
    PHSettingItem *four = [PHSettingItem itemWithTitle:@"版权所有"];
    four.subtitle = @"我的版权";
    
    PHSettingGroup *group = [[PHSettingGroup alloc] init];
    group.items = @[two,three,four];
    [self.dataSource addObject:group];
}

@end





