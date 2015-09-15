//
//  PHRemoteViewController.m
//  New_Simplify
//
//  Created by Kowloon on 15/9/15.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import "PHRemoteViewController.h"
#import "PHSettingGroup.h"
#import "PHSettingItem.h"
@implementation PHRemoteViewController
- (void)dealloc
{
    PHLog(@"%@->dealloc",NSStringFromClass([self class]));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    if (self.remoteAlarmInfo.length != 0) {
        NSArray *arraySep = [NSArray seprateString:self.remoteAlarmInfo characterSet:@","];
        NSString *devid = [arraySep firstObject];
        NSString *status = arraySep[1];
        NSString *time = arraySep[2];
        NSString *lat = arraySep[3];
        NSString *lng = arraySep[4];
        NSString *fenceid = [arraySep lastObject];
        
        PHSettingItem *one = [PHSettingItem itemWithTitle:@"报警设备号"];
        one.subtitle = [devid stringByReplacingOccurrencesOfString:@"*" withString:@""];
        PHSettingItem *two = [PHSettingItem itemWithTitle:@"报警状态"];
        two.subtitle = [status isEqualToString:@"1"] ? @"进入" : @"离开";
        
        PHSettingItem *three = [PHSettingItem itemWithTitle:@"报警时间"];
        three.subtitle = [time convertGpstimeToDateFormate:@"yyyy-MM-dd HH:mm:ss"];
        
        PHSettingGroup *group = [[PHSettingGroup alloc] init];
        group.header = @"报警基本信息";
        group.items = @[one,two,three];
        [self.dataSource addObject:group];
        
        GMNearbyManager *nearbyM = [GMNearbyManager manager];
        CLLocationCoordinate2D *coord = malloc(sizeof(CLLocationCoordinate2D) * 1);
        coord[0] = CLLocationCoordinate2DMake([lat doubleValue], [lng doubleValue]);
        [nearbyM reverseGeocode:coord count:1 completionBlock:^(NSArray *array) {
            if (array.count > 0) {
                GMGeocodeResult *result = [array firstObject];
                PHSettingGroup *groupAddress = [[PHSettingGroup alloc] init];
                groupAddress.header = result.address;
                PHSettingItem *address = [PHSettingItem itemWithTitle:@"经纬度"];
                address.subtitle = [NSString stringWithFormat:@"%@,%@",lat, lng];
                groupAddress.items = @[address];
                [self.dataSource insertObject:groupAddress atIndex:1];
                [self.tableView reloadData];
            }
            
        } failureBlock:nil];
        
        GMFenceManager *fenceM = [GMFenceManager manager];
        [fenceM obtainFenceWithFenceId:fenceid successBlockFenceInfo:^(GMNumberFence *numberFence) {
            [self setupGroupFence:numberFence];
            [self.tableView reloadData];
        } failureBlock:nil];
    }
    
}
/**
 *  第1组数据
 */
- (void)setupGroupFence:(GMNumberFence *)fence
{
    PHSettingItem *one = [PHSettingItem itemWithTitle:@"围栏名称"];
    one.subtitle = fence.name;
    
    PHSettingItem *two = [PHSettingItem itemWithTitle:@"围栏号"];
    two.subtitle = fence.fenceid;
    
    PHSettingItem *three = [PHSettingItem itemWithTitle:@"围栏形状"];
    three.subtitle = [fence.shape isEqualToString:@"1"] ? @"圆形" : @"多边形";
    
    PHSettingItem *four = [PHSettingItem itemWithTitle:@"围栏阈值"];
    four.subtitle = fence.threshold;
    
    PHSettingGroup *group = [[PHSettingGroup alloc] init];
    group.header = @"报警围栏信息";
    group.items = @[one,two,three,four];
    [self.dataSource addObject:group];
}


@end
