//
//  PHFenceOtherArguemntCell.m
//  New_Simplify
//
//  Created by Kowloon on 15/9/6.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import "PHFenceOtherArguemntCell.h"
#import "PHSettingItem.h"
#import "PHSettingArrowItem.h"
#import "PHSettingSwitchItem.h"

typedef void (^PHFenceOtherArgumentCompletion)(BOOL enable);


@interface PHFenceOtherArguemntCell ()
/**
 *  开关
 */
@property (nonatomic, strong) UISwitch *switchView;


@end

@implementation PHFenceOtherArguemntCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"PHFenceOtherArguemntCell";
    PHFenceOtherArguemntCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[PHFenceOtherArguemntCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}

- (UISwitch *)switchView
{
    if (_switchView == nil) {
        _switchView = [[UISwitch alloc] init];
        [_switchView addTarget:self action:@selector(switchStateChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _switchView;
}

/**
 *  监听开关状态改变
 */
- (void)switchStateChange:(UISwitch *)sender
{
    PHSettingSwitchItem *switchItem = (PHSettingSwitchItem *)self.phItem;
    if (switchItem.status) switchItem.status(sender.isOn);
}

- (void)setPhItem:(PHSettingItem *)phItem
{
    _phItem = phItem;
    // 1.设置数据
    [self setupData];
    
    // 2.设置右边的内容
    [self setupRightContent];
}

/**
 *  设置数据
 */
- (void)setupData
{
    if (self.phItem.icon) {
        self.imageView.image = [UIImage imageNamed:self.phItem.icon];
    }
    self.textLabel.text = self.phItem.title;
    self.detailTextLabel.text = self.phItem.subtitle;
}
/**
 *  设置右边的内容
 */
- (void)setupRightContent
{
    if ([self.phItem isKindOfClass:[PHSettingArrowItem class]]) { // 箭头
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if ([self.phItem isKindOfClass:[PHSettingSwitchItem class]]) { // 开关
        self.accessoryView = self.switchView;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        // 设置开关的状态
        PHSettingSwitchItem *switchItem = (PHSettingSwitchItem *)self.phItem;
        self.switchView.on = switchItem.isEnabled;
    }
    else if ([self.phItem isKindOfClass:[PHSettingItem class]])//最初状态
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
    }
    else {//防止复用问题
        self.accessoryView = nil;
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
}
@end











