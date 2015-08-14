//
//  PHOfflineMapCell.m
//  SimplifiedApp
//
//  Created by Kowloon on 15/5/13.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import "PHOfflineMapCell.h"
#import <BaiduMapAPI/BMKOfflineMap.h>
#import "PHSearchRecord.h"
@interface PHOfflineMapCell ()
@property(nonatomic, strong)UILabel *sizeLabel;

@end

@implementation PHOfflineMapCell
- (UILabel *)sizeLabel
{
    if (_sizeLabel == nil) {
        _sizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
        _sizeLabel.textAlignment = NSTextAlignmentRight;
        _sizeLabel.font = [UIFont systemFontOfSize:15];
        _sizeLabel.textColor = [UIColor redColor];
    }
    return _sizeLabel;
}
+ (instancetype)offlineMapCellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"offline";
    PHOfflineMapCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[PHOfflineMapCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}


- (void)setSearchRecord:(PHSearchRecord *)searchRecord
{
    _searchRecord = searchRecord;
    [self setupAccessoryView];
    [self setupData];
}
- (void)setupAccessoryView
{
    if ([self.searchRecord isKindOfClass:[PHSearchRecord class]]) {
        self.accessoryView = self.sizeLabel;
    }
}
- (void)setupData
{
    self.textLabel.text = [NSString stringWithFormat:@"%@(%d)", self.searchRecord.record.cityName, self.searchRecord.record.cityID];
    NSString *string = [PHTool getDataSizeString:self.searchRecord.record.size];
    if (self.searchRecord.statusStr) {
        self.sizeLabel.textColor = [UIColor grayColor];
        string = [NSString stringWithFormat:@"%@ %@",self.searchRecord.statusStr,string];
    }
    else {
        self.sizeLabel.textColor = [UIColor redColor];
    }
    self.sizeLabel.text = string;
}
@end






