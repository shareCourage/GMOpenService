//
//  PHFenceTableViewCell.m
//  New_Simplify
//
//  Created by Kowloon on 15/9/1.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import "PHFenceTableViewCell.h"

@implementation PHFenceTableViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"fenceTableCell";
    PHFenceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[PHFenceTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}

- (void)setDevFence:(GMDeviceFence *)devFence
{
    _devFence = devFence;
    [self setupData];
    [self setupUI];
}

- (void)setupData {
    
    if (self.devFence.name.length != 0) {
        self.textLabel.text = self.devFence.name;
    }
    else {
        self.textLabel.text = [NSString stringWithFormat:@"围栏号:%@",self.devFence.fenceid];
    }
    
    if ([self.devFence.shape isEqualToString:@"1"]) {
        self.detailTextLabel.text = @"圆形";
    }
    else {
        NSArray *array = [NSArray seprateString:self.devFence.area characterSet:@";"];
        self.detailTextLabel.text = [NSString stringWithFormat:@"%ld边形",array.count];
    }

}
- (void)setupUI {
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

@end






