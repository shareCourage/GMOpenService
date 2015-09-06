//
//  PHFenceOtherArguemntCell.h
//  New_Simplify
//
//  Created by Kowloon on 15/9/6.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PHSettingItem;

@interface PHFenceOtherArguemntCell : UITableViewCell

@property(nonatomic, strong)PHSettingItem *phItem;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
