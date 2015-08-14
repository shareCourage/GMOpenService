//
//  PHOfflineMapCell.h
//  SimplifiedApp
//
//  Created by Kowloon on 15/5/13.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PHSearchRecord;
@interface PHOfflineMapCell : UITableViewCell

+ (instancetype)offlineMapCellWithTableView:(UITableView *)tableView;

@property(nonatomic, strong)PHSearchRecord *searchRecord;

@end
