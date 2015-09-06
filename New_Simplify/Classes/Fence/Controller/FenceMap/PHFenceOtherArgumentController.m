//
//  PHFenceOtherArgumentController.m
//  New_Simplify
//
//  Created by Kowloon on 15/9/6.
//  Copyright (c) 2015年 Goome. All rights reserved.
//
#define PH_FenceOtherArgument_fenceid   @"围栏号"
#define PH_FenceOtherArgument_shape     @"围栏形状"
#define PH_FenceOtherArgument_radius    @"围栏半径"

#define PH_FenceOtherArgument_enable    @"围栏开启状态"
#define PH_FenceOtherArgument_devIn     @"进入围栏报警状态"
#define PH_FenceOtherArgument_devOut    @"离开围栏报警状态"
#define PH_FenceOtherArgument_name      @"围栏名称"
#define PH_FenceOtherArgument_threshold @"围栏报警阈值"

#define PH_FenceOtherArgument_devid     @"围栏已绑定设备号"

#import "PHFenceOtherArgumentController.h"
#import "PHSettingGroup.h"
#import "PHSettingItem.h"
#import "PHSettingArrowItem.h"
#import "PHSettingSwitchItem.h"
#import "PHFenceOtherArguemntCell.h"
#import "PHPickerView.h"
@interface PHFenceOtherArgumentController ()
{
    __block NSString *_devIn;
    __block NSString *_devOut;
}
@property (nonatomic, strong)PHSettingGroup *groupThree;

@property (nonatomic, strong)NSIndexPath *selectedIndexPath;

@end

@implementation PHFenceOtherArgumentController

- (void)dealloc
{
    PHLog(@"%@->dealloc",NSStringFromClass([self class]));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.fenceInfo.name.length != 0 ? self.fenceInfo.name : self.fenceInfo.fenceid;
    _devIn = self.fenceInfo.devInOut.dev_in;
    _devOut = self.fenceInfo.devInOut.dev_out;
    
    PH_WS(ws);
    PHSettingSwitchItem *enable = [PHSettingSwitchItem itemWithTitle:PH_FenceOtherArgument_enable completion:^(BOOL enable) {
        [GMFenceManager modifyFenceWithFenceId:ws.fenceInfo.fenceid enable:enable completion:^(BOOL success) {
            success ? PHLog(@"modify enable Fence success") : PHLog(@"modify enable Fence failure");
        } failureBlock:nil];
    }];
    enable.enabled = [self.fenceInfo.enable boolValue];
    
    
    PHSettingSwitchItem *devIn = [PHSettingSwitchItem itemWithTitle:PH_FenceOtherArgument_devIn completion:^(BOOL enable) {
        __strong typeof(ws) strongSelf = ws;
        strongSelf -> _devIn = [NSString stringWithFormat:@"%d",enable];
        [ws modifyDevinfo];
    }];
    devIn.enabled = [self.fenceInfo.devInOut.dev_in boolValue];
    
    PHSettingSwitchItem *devOut = [PHSettingSwitchItem itemWithTitle:PH_FenceOtherArgument_devOut completion:^(BOOL enable) {
        __strong typeof(ws) strongSelf = ws;
        strongSelf -> _devOut = [NSString stringWithFormat:@"%d",enable];
        [ws modifyDevinfo];
    }];
    devOut.enabled = [self.fenceInfo.devInOut.dev_out boolValue];

    PHSettingItem *name = [PHSettingArrowItem itemWithTitle:PH_FenceOtherArgument_name];
    name.subtitle = self.fenceInfo.name;
    name.option = ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入围栏名称" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"围栏名称";
        }];
        [alertController addAction:[ws actionWithTitle:@"取消" actionStyle:UIAlertActionStyleCancel handler:nil]];
        [alertController addAction:[ws actionWithTitle:@"确定" actionStyle:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            UITextField *textF =  [alertController.textFields firstObject];
            textF.text.length != 0 ? [ws modifyFenceName:textF.text] : nil;
        }]];
        [ws presentViewController:alertController animated:YES completion:nil];
    };
    
    PHSettingItem *threshold = [PHSettingArrowItem itemWithTitle:PH_FenceOtherArgument_threshold];
    threshold.subtitle = self.fenceInfo.threshold;
    threshold.option = ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入围栏报警阈值" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"围栏报警阈值，限数字";
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }];
        [alertController addAction:[ws actionWithTitle:@"取消" actionStyle:UIAlertActionStyleCancel handler:nil]];
        [alertController addAction:[ws actionWithTitle:@"确定" actionStyle:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            UITextField *textF =  [alertController.textFields firstObject];
            textF.text.length != 0 ? [ws modifyFenceThreshold:textF.text] : nil;
        }]];
        [ws presentViewController:alertController animated:YES completion:nil];

    };
    
    PHSettingItem *fenceid = [PHSettingItem itemWithTitle:PH_FenceOtherArgument_fenceid];
    fenceid.subtitle = self.fenceInfo.fenceid;
    
    PHSettingItem *shape = [PHSettingItem itemWithTitle:PH_FenceOtherArgument_shape];
    if ([self.fenceInfo.shape isEqualToString:@"1"]) {
        NSArray *array = [NSArray seprateString:self.fenceInfo.area characterSet:@","];
        NSString *radius = [NSString stringWithFormat:@"半径:%@米",[array lastObject]];
        shape.subtitle = [@"圆形," stringByAppendingString:radius];
    }
    else if ([self.fenceInfo.shape isEqualToString:@"2"]) {
        NSArray *array = [NSArray seprateString:self.fenceInfo.area characterSet:@";"];
        shape.subtitle = [NSString stringWithFormat:@"%ld边形",array.count];
    }
    
    PHSettingGroup *groupOne = [[PHSettingGroup alloc] init];
    groupOne.header = @"围栏状态信息";
    groupOne.items = @[enable, devIn, devOut, name, threshold];
    
    
    PHSettingGroup *groupTwo = [[PHSettingGroup alloc] init];
    groupTwo.header = @"围栏基本信息";
    groupTwo.items = @[fenceid, shape];
    
    PHSettingGroup *groupThree = [[PHSettingGroup alloc] init];
    groupThree.header = PH_FenceOtherArgument_devid;
    PHSettingItem *devid = [PHSettingItem itemWithTitle:@"设备号1"];
    devid.subtitle = self.fenceInfo.devInOut.devid;
    groupThree.items = @[devid];
    self.groupThree = groupThree;
    
    [self.dataSource addObject:groupOne];
    [self.dataSource addObject:groupTwo];
    [self.dataSource addObject:groupThree];

    [self searchDevidFromFenceid:self.fenceInfo.fenceid];
}

- (void)searchDevidFromFenceid:(NSString *)fenceid
{
    GMFenceManager *fenceM = [GMFenceManager manager];
    PH_WS(ws);
    [fenceM obtainFenceWithFenceId:fenceid successBlockFenceInfo:^(GMNumberFence *numberFence) {
        if (numberFence) {
            NSMutableArray *array = [NSMutableArray array];
            NSUInteger i = 1;
            for (GMDevInOut *devInOut in numberFence.devinfos) {
                PHSettingItem *devid = [PHSettingItem itemWithTitle:[NSString stringWithFormat:@"设备号%ld",i]];
                devid.subtitle = devInOut.devid;
                [array addObject:devid];
                i ++;
            }
            ws.groupThree.items = [array copy];
            [ws.tableView reloadData];
        }
    } failureBlock:nil];
}

- (void)modifyDevinfo {
    NSString *devinfo = [NSString stringWithFormat:@"%@,%@,%@",self.fenceInfo.devInOut.devid,_devIn,_devOut];
    [GMFenceManager modifyFenceWithFenceId:self.fenceInfo.fenceid devinfo:devinfo completion:^(BOOL success) {
        success ? PHLog(@"modify devinfo Fence success") : PHLog(@"modify devinfo Fence failure");
    } failure:nil];
}

- (void)modifyFenceName:(NSString *)name {
    PHSettingGroup *group = self.dataSource[self.selectedIndexPath.section];
    PHSettingItem *item = group.items[self.selectedIndexPath.row];
    item.subtitle = name;
    self.title = name;
    [self.tableView reloadRowsAtIndexPaths:@[self.selectedIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [GMFenceManager modifyFenceWithFenceId:self.fenceInfo.fenceid name:name completion:^(BOOL success) {
        success ? PHLog(@"modify name Fence success") : PHLog(@"modify name Fence failure");
    } failure:nil];
    
}

- (void)modifyFenceThreshold:(NSString *)threshold {
    PHSettingGroup *group = self.dataSource[self.selectedIndexPath.section];
    PHSettingItem *item = group.items[self.selectedIndexPath.row];
    item.subtitle = threshold;
    [self.tableView reloadRowsAtIndexPaths:@[self.selectedIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [GMFenceManager modifyFenceWithFenceId:self.fenceInfo.fenceid threshold:threshold completion:^(BOOL success) {
        success ? PHLog(@"modify threshold Fence success") : PHLog(@"modify threshold Fence failure");
    } failure:nil];
}

- (UIAlertAction *)actionWithTitle:(NSString *)title actionStyle:(UIAlertActionStyle)style handler:(void (^)(UIAlertAction *action))handler
{
    if (style == UIAlertActionStyleCancel) {
        return [UIAlertAction actionWithTitle:title style:style handler:handler];
    }
    return [UIAlertAction actionWithTitle:title style:style handler:handler];
    
}

#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PHFenceOtherArguemntCell *cell = [PHFenceOtherArguemntCell cellWithTableView:tableView];
    PHSettingGroup *group = self.dataSource[indexPath.section];
    cell.phItem = group.items[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    self.selectedIndexPath = indexPath;
}

@end





