//
//  PHAlarmInfoController.m
//  New_Simplify
//
//  Created by Kowloon on 15/8/18.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import "PHAlarmInfoController.h"
#import "MJRefresh.h"
#import "GMAlarmInfo.h"

@interface PHAlarmInfoController ()
{
    GMAlarmManager *_alarmM;
}
@property (nonatomic, assign)NSUInteger pageNum;

@property (nonatomic, copy)NSString *alarmFilePath;

@property (nonatomic, strong)NSMutableArray *dataSource;

@end

@implementation PHAlarmInfoController
- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNum = 0;
    _alarmM = [GMAlarmManager manager];
    [self displayAlarm];
    PH_WS(ws);
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        ws.pageNum ++;
        [ws displayAlarm];
    }];
    self.tableView.tableFooterView = [[UIView alloc] init];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)displayAlarm
{
    PH_WS(ws);
    _alarmM.pageNum = ws.pageNum;
//    _alarmM.pageSize = 50;
//    _alarmM.typeId = @"1";
    [_alarmM getAlarmInformationWithDevid:[PHTool getDeviceIdFromUserDefault] completionBlock:^(NSArray *array) {
        if (array.count != 0) {
            [self.dataSource addObjectsFromArray:array];
            [ws.tableView reloadData];
            [ws.tableView.footer endRefreshing];
        }
    } failureBlock:^(NSError *error) {
        [ws.tableView.footer endRefreshing];
    }];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"alarm";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    GMAlarmInfo *alarmInfo = self.dataSource[indexPath.row];
    NSString *fence = [NSString stringWithFormat:@" %@围栏",alarmInfo.fenceId];
    cell.textLabel.text = [alarmInfo.typeId isEqualToString:@"1"] ? [@"Into" stringByAppendingString:fence] : [@"Out" stringByAppendingString:fence];
    cell.detailTextLabel.text = alarmInfo.alartTime;

    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end









