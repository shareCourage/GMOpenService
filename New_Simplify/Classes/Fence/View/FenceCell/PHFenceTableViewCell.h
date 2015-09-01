//
//  PHFenceTableViewCell.h
//  New_Simplify
//
//  Created by Kowloon on 15/9/1.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GMDeviceFence;

@interface PHFenceTableViewCell : UITableViewCell

@property (nonatomic, strong)GMDeviceFence *devFence;

+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
