//
//  PHOfflineMapController.m
//  SimplifiedApp
//
//  Created by Kowloon on 15/5/12.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import "PHOfflineMapController.h"
#import <BaiduMapAPI/BMapKit.h>
#import "PHSettingGroup.h"
#import "PHSearchRecord.h"
#import "PHOfflineMapCell.h"
#import "PHDownloadMapCell.h"
#import "PHOfflineHeaderView.h"
@interface PHOfflineMapController ()<BMKOfflineMapDelegate, UITableViewDataSource, UITableViewDelegate,PHOfflineHeaderViewDelegate, UIActionSheetDelegate>
{
    BOOL _isClickDownloaded;
    BMKOfflineMap *_offlineMap;
    UITableView *_downloadManagerTV;
    UITableView *_cityListTV;
}
@property(nonatomic, weak)UISegmentedControl *segment;
@property(nonatomic, strong)NSMutableArray *cityListDatasource;
@property(nonatomic, strong)NSMutableArray *downloadDatasource;
@property(nonatomic, strong)NSMutableArray *indexPaths;
@property(nonatomic, strong)NSIndexPath *downIndexPath;
@end

@implementation PHOfflineMapController
- (NSMutableArray *)indexPaths
{
    if (_indexPaths == nil) {
        _indexPaths = [NSMutableArray array];
    }
    return _indexPaths;
}
- (NSMutableArray *)cityListDatasource
{
    if (_cityListDatasource == nil) {
        _cityListDatasource = [NSMutableArray array];
    }
    return _cityListDatasource;
}
- (NSMutableArray *)downloadDatasource
{
    if (_downloadDatasource == nil) {
        _downloadDatasource = [NSMutableArray array];
    }
    return _downloadDatasource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.view.backgroundColor = [UIColor whiteColor];
    [self addSegmentControll];
    [self offlineMapImplementation];
    [self tableViewImplementation];
}
/*
 *两个tableView的实例化
 */
- (void)tableViewImplementation
{
    CGFloat heightOfTV = PH_HeightOfScreen - PH_HeightOfNavigationBar;
    CGRect downFrame = CGRectMake(0, 0, PH_WidthOfScreen, PH_HeightOfScreen);
    CGRect cityFram = CGRectMake(0, PH_HeightOfNavigationBar, PH_WidthOfScreen, heightOfTV);
    _downloadManagerTV = [[UITableView alloc] initWithFrame:downFrame style:UITableViewStyleGrouped];
    _cityListTV = [[UITableView alloc] initWithFrame:cityFram style:UITableViewStylePlain];
    _downloadManagerTV.delegate = self;
    _downloadManagerTV.dataSource = self;
    _cityListTV.delegate = self;
    _cityListTV.dataSource = self;
    _downloadManagerTV.tableFooterView = [[UIView alloc] init];
    _cityListTV.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_downloadManagerTV];
    [self.view addSubview:_cityListTV];
    _downloadManagerTV.hidden = NO;
    _cityListTV.hidden = YES;
}

/*
 *offlineMap的实例化
 */
- (void)offlineMapImplementation
{
    //初始化离线地图服务
    _offlineMap = [[BMKOfflineMap alloc]init];
    
    [self downloadDatasourceImplementation];
    [self cityDataSourceImplementation];
}
/*
 *装载downloadDatasource数据
 */
- (void)downloadDatasourceImplementation
{
    [self.downloadDatasource removeAllObjects];
    NSArray *downs = [_offlineMap getAllUpdateInfo];
    NSMutableArray *downloads = [NSMutableArray array];
    NSMutableArray *nonDownloads = [NSMutableArray array];
    PHSettingGroup *downloading = [PHSettingGroup settingGoup];
    PHSettingGroup *downloaded = [PHSettingGroup settingGoup];
    for (BMKOLUpdateElement *element in downs) {
        if (element.status == 4) {// 已经下载完成
            [downloads addObject:element];
        }
        else {
            [nonDownloads addObject:element];
        }
    }
    downloaded.items = downloads;
    downloaded.header = @"已下载";
    downloaded.opened = YES;
    downloading.items = nonDownloads;
    downloading.header = @"正在下载";
    downloading.opened = YES;
    [self.downloadDatasource addObject:downloading];
    [self.downloadDatasource addObject:downloaded];
//    PHLog(@"downloadDatasource->%ld",self.downloadDatasource.count);
}

/*
 *装载cityListDatasource数据
 */
- (void)cityDataSourceImplementation
{
    //获取热门城市
    NSArray *hotcity = [_offlineMap getHotCityList];
    NSMutableArray *hotCityMutable = [NSMutableArray array];
    for (BMKOLSearchRecord *record in hotcity) {
        PHSearchRecord *searchR = [PHSearchRecord searchRecord];
        searchR.record = record;
        searchR.statusStr = [self stausOfCity:record];
        [hotCityMutable addObject:searchR];
    }
    PHSettingGroup *groupOne = [PHSettingGroup settingGoup];
    groupOne.opened = YES;
    groupOne.items = hotCityMutable;
    groupOne.header = @"热门城市";

    //获取支持离线下载城市列表
    NSArray *offlineCity = [_offlineMap getOfflineCityList];
    NSMutableArray *offlineCityMutable = [NSMutableArray array];
    for (BMKOLSearchRecord *record in offlineCity) {
        if (record.cityType == 1) {//1、省份
            
            if (record.childCities.count != 0) {
                PHSettingGroup *group = [PHSettingGroup settingGoup];
                group.header = record.cityName;
                NSMutableArray *groupMut = [NSMutableArray array];
                for (BMKOLSearchRecord *obj in record.childCities) {
                    PHSearchRecord *search = [PHSearchRecord searchRecord];
                    search.record = obj;
                    search.statusStr = [self stausOfCity:obj];
                    [groupMut addObject:search];
                }
                group.items = groupMut;
                [self.cityListDatasource addObject:group];
            }
            
        }
        else if (record.cityType == 2) {//2、城市
            PHSearchRecord *searchR = [PHSearchRecord searchRecord];
            searchR.record = record;
            searchR.statusStr = [self stausOfCity:record];
            [offlineCityMutable addObject:searchR];
        }
    }
    PHSettingGroup *groupTwo = [PHSettingGroup settingGoup];
    groupTwo.opened = YES;
    groupTwo.items = offlineCityMutable;
    groupTwo.header = @"全国";
    [self.cityListDatasource insertObject:groupOne atIndex:0];
    [self.cityListDatasource insertObject:groupTwo atIndex:1];
}

/*
 *判断指定的city的状态
 */
- (NSString *)stausOfCity:(BMKOLSearchRecord *)record
{
    BMKOLUpdateElement *element = [_offlineMap getUpdateInfo:record.cityID];
    return [self cuttentStatus:element.status];
}
- (NSString *)cuttentStatus:(int)status
{
    ///下载状态, -1:未定义 1:正在下载　2:等待下载　3:已暂停　4:完成 5:校验失败 6:网络异常 7:读写异常 8:Wifi网络异常 9:未完成的离线包有更新包 10:已完成的离线包有更新包 11:没有完全下载完成的省份 12:该省份的所有城市都已经下载完成 13:该省份的部分城市需要更新
    NSString *string = nil;
    switch (status) {
        case -1:
            string = @"未定义";
            break;
        case 1:
            string = @"正在下载";
            break;
        case 2:
            string = @"等待下载";
            break;
        case 3:
            string = @"已暂停";
            break;
        case 4:
            string = @"完成下载";
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
    return string;
}
/*
 *添加segmentControll
 */
- (void)addSegmentControll
{
    NSArray *array = @[@"下载管理",@"城市列表"];
    UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:array];
    seg.tintColor = [UIColor blueColor];
    [seg addTarget:self action:@selector(mySegmentValuedChanged:) forControlEvents:UIControlEventValueChanged];
    seg.selectedSegmentIndex = 0;
    self.navigationItem.titleView = seg;
    self.segment = seg;
}

- (void)mySegmentValuedChanged:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == 0) {
        _downloadManagerTV.hidden = NO;
        _cityListTV.hidden = YES;
        if (_isClickDownloaded) {
            [self downloadDatasourceImplementation];
            [_downloadManagerTV reloadData];
        }
    }
    else if (sender.selectedSegmentIndex == 1){
        _downloadManagerTV.hidden = YES;
        _cityListTV.hidden = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _offlineMap.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _offlineMap.delegate = nil;
}

#pragma mark - UITableViewDataSource UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == _cityListTV) {
        return self.cityListDatasource.count;
    }
    else if (tableView == _downloadManagerTV) {
        return self.downloadDatasource.count;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    PHSettingGroup *group = nil;
    if (tableView == _cityListTV) {
        group = self.cityListDatasource[section];
    }
    else if (tableView == _downloadManagerTV){
        group = self.downloadDatasource[section];
    }
    return group.isOpened ? group.items.count : 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    PHSettingGroup *group = nil;
    if (tableView == _cityListTV) {
        group = self.cityListDatasource[section];
    }
    else if (tableView == _downloadManagerTV) {
        group = self.downloadDatasource[section];
    }
    PHOfflineHeaderView *headerView = [PHOfflineHeaderView offlineHeaderViewWithTableView:tableView];
    headerView.delegate = self;
    headerView.group = group;
    return headerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _cityListTV) {
        PHOfflineMapCell *cell = [PHOfflineMapCell offlineMapCellWithTableView:tableView];
        PHSettingGroup *group = self.cityListDatasource[indexPath.section];
        PHSearchRecord *record = group.items[indexPath.row];
        cell.searchRecord = record;
        return cell;
    }
    else if (tableView == _downloadManagerTV) {
        PHDownloadMapCell *cell = [PHDownloadMapCell downloadMapCellWithTableView:tableView];
        PHSettingGroup *group = self.downloadDatasource[indexPath.section];
        BMKOLUpdateElement *element = group.items[indexPath.row];
        cell.element = element;
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _isClickDownloaded = YES;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    PHLog(@"%@",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]);
    if (tableView == _cityListTV) {
        [self.indexPaths removeAllObjects];
        PHSettingGroup *group = self.cityListDatasource[indexPath.section];
        PHSearchRecord *searchRecord = group.items[indexPath.row];
        [_offlineMap start:searchRecord.record.cityID];
        searchRecord.statusStr = [self stausOfCity:searchRecord.record];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.indexPaths addObject:indexPath];
    }
    if (tableView == _downloadManagerTV) {
        UIActionSheet *action = nil;
        self.downIndexPath = indexPath;
        PHSettingGroup *group = self.downloadDatasource[indexPath.section];
        BMKOLUpdateElement *element = group.items[indexPath.row];
        if (indexPath.section == 0) {
            NSString *pauseOrStart = nil;
            if (element.status != 1 ) {
                pauseOrStart = @"StartDownload";
            }
            else {
                pauseOrStart = @"Pause";
            }
            action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:pauseOrStart,@"Delete", nil];
        }
        else if (indexPath.section == 1) {
            action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Delete", nil];
        }
        
        [action showInView:self.view];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL allowEdit = YES;
    if (tableView == _downloadManagerTV) {
        allowEdit = YES;
    }
    else if (tableView == _cityListTV) {
        allowEdit = NO;
    }
    return allowEdit;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_downloadManagerTV == tableView) {
        PHSettingGroup *group = self.downloadDatasource[indexPath.section];
        BMKOLUpdateElement *element = group.items[indexPath.row];
        if (UITableViewCellEditingStyleDelete == editingStyle) {
            [self offlineMapRemoveCity:element.cityID];
        }
    }
}
#pragma mark - BMKOfflineMapDelegate
- (void)onGetOfflineMapState:(int)type withState:(int)state//state就是当前下载的cityID号,百度SDK解释有错误
{
    BMKOLUpdateElement *updateInfo = nil;
    switch (type) {
        case TYPE_OFFLINE_UPDATE:
            updateInfo = [_offlineMap getUpdateInfo:state];
            [self downloadDatasourceImplementation];
            [_downloadManagerTV reloadData];
            if (updateInfo.ratio == 100) {//下载完成之后,再来更新数据源的值
                _isClickDownloaded = NO;
                [self cityListDataSourceUpdate];
                [_cityListTV reloadRowsAtIndexPaths:self.indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            PHLog(@"城市名：%@,下载比例:%d",updateInfo.cityName,updateInfo.ratio);
            break;
        case TYPE_OFFLINE_ZIPCNT:
            PHLog(@"TYPE_OFFLINE_ZIPCNT");
            
            break;
            
        case TYPE_OFFLINE_UNZIP:
            PHLog(@"TYPE_OFFLINE_UNZIP");
            break;
        default:
            break;
    }
}

- (void)cityListDataSourceUpdate
{
    for (NSIndexPath *indexPath in self.indexPaths) {
        PHSettingGroup *group = self.cityListDatasource[indexPath.section];
        PHSearchRecord *searchRecord = group.items[indexPath.row];
        searchRecord.statusStr = [self stausOfCity:searchRecord.record];
    }
}
#pragma mark - PHOfflineHeaderViewDelegate
- (void)OfflineHeaderViewDidClickedNameView:(PHOfflineHeaderView *)headerView
{
    [_cityListTV reloadData];
    [_downloadManagerTV reloadData];
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    PHSettingGroup *group = self.downloadDatasource[self.downIndexPath.section];
    BMKOLUpdateElement *element = group.items[self.downIndexPath.row];
    if (self.downIndexPath.section == 0) {//正在下载
        if (buttonIndex == 0) {//pause
            if (element.status == 1) {
                [_offlineMap pause:element.cityID];
            }
            else {
                [_offlineMap start:element.cityID];
            }
        }
        else if (buttonIndex == 1) {//delete
            [self offlineMapRemoveCity:element.cityID];
        }
    }
    else if (self.downIndexPath.section == 1) {//已经下载
        if (buttonIndex == 0) {
            [_offlineMap remove:element.cityID];
        }
    }
}
- (void)offlineMapRemoveCity:(int)cityID
{
    [_offlineMap remove:cityID];
    for (PHSettingGroup *group in self.cityListDatasource) {
        for (PHSearchRecord *record in group.items) {
            if (record.record.cityID == cityID) {
                record.statusStr = nil;
            }
        }
    }
    [_cityListTV reloadData];
}
@end


