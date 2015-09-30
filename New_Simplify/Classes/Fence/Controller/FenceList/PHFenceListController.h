//
//  PHFenceListController.h
//  Demo_Monitor
//
//  Created by Kowloon on 15/4/7.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import "PHTableViewController.h"

@interface PHFenceListController : PHTableViewController

@property (nonatomic, assign, getter = isFenceArgumentChanged) BOOL fenceArgumentChanged;

@property(nonatomic, strong)NSMutableArray *dataSource;//tableView的数据源

@end
