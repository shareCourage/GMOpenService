//
//  PHDownloadMapCell.m
//  SimplifiedApp
//
//  Created by Kowloon on 15/5/13.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import "PHDownloadMapCell.h"
#import <BaiduMapAPI/BMKOfflineMap.h>
@implementation PHDownloadMapCell

+ (instancetype)downloadMapCellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"download";
    PHDownloadMapCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[PHDownloadMapCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}

- (void)setElement:(BMKOLUpdateElement *)element
{
    _element = element;
    self.textLabel.text = element.cityName;
    [self setDetailLabel];
}
- (void)setDetailLabel
{
    ///下载状态, -1:未定义 1:正在下载　2:等待下载　3:已暂停　4:完成 5:校验失败 6:网络异常 7:读写异常 8:Wifi网络异常 9:未完成的离线包有更新包 10:已完成的离线包有更新包 11:没有完全下载完成的省份 12:该省份的所有城市都已经下载完成 13:该省份的部分城市需要更新
    NSString *string = nil;
    switch (self.element.status) {
        case -1:
            string = @"未定义";
            break;
        case 1:
            string = [NSString stringWithFormat:@"正在下载%d%%",self.element.ratio];
            break;
        case 2:
            string = @"等待下载";
            break;
        case 3:
            string = @"已暂停";
            break;
        case 4:
            string = @"完成";
            break;
        case 5:
            string = @"校验失败";
            break;
        case 6:
            string = @"网络异常";
            break;
        case 7:
            string = @"读写异常";
            break;
        case 8:
            string = @"Wifi网络异常";
            break;
        case 9:
            string = @"未完成的离线包有更新包";
            break;
        case 10:
            string = @"没有完全下载完成的省份";
            break;
        case 11:
            string = @"已完成的离线包有更新包";
            break;
        case 12:
            string = @"该省份的所有城市都已经下载完成";
            break;
        case 13:
            string = @"该省份的部分城市需要更新";
            break;
            
        default:
            break;
    }
    self.detailTextLabel.text = string;

}
@end





