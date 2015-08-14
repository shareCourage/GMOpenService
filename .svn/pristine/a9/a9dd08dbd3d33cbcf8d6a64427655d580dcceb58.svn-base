//
//  PHOfflineHeaderView.h
//  SimplifiedApp
//
//  Created by Kowloon on 15/5/14.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PHOfflineHeaderView, PHSettingGroup;

@protocol PHOfflineHeaderViewDelegate <NSObject>

@optional
- (void)OfflineHeaderViewDidClickedNameView:(PHOfflineHeaderView *)headerView;

@end

@interface PHOfflineHeaderView : UITableViewHeaderFooterView

@property(nonatomic, strong)PHSettingGroup *group;
@property(nonatomic, assign)id<PHOfflineHeaderViewDelegate>delegate;
+ (instancetype)offlineHeaderViewWithTableView:(UITableView *)tableView;

@end
