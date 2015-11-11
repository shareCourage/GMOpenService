//
//  PHFenceOtherArgumentController.m
//  New_Simplify
//
//  Created by Kowloon on 15/9/6.
//  Copyright (c) 2015年 Goome. All rights reserved.
//
#define PH_MaxOfThreshold 99
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
#import "PHFenceListController.h"
#import "PHNavigationController.h"
#import "PHSettingArgumentController.h"
#import "AppDelegate.h"
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
    _devIn = self.fenceInfo ? self.fenceInfo.devInOut.dev_in : [NSString stringWithFormat:@"%@",@(self.fenceM.getIn)];
    _devOut = self.fenceInfo ? self.fenceInfo.devInOut.dev_out : [NSString stringWithFormat:@"%@",@(self.fenceM.getOut)];
    
    PH_WS(ws);
    PHSettingSwitchItem *enable = [PHSettingSwitchItem itemWithTitle:PH_FenceOtherArgument_enable completion:^(BOOL enable) {
        if (ws.fenceM) {
            ws.fenceM.enable = enable;
        }
        else {
            [GMFenceManager modifyFenceWithFenceId:ws.fenceInfo.fenceid enable:enable completion:^(BOOL success) {
                success ? PHLog(@"modify enable Fence success") : PHLog(@"modify enable Fence failure");
            } failureBlock:nil];
            ws.fenceInfo.enable = [NSString stringWithFormat:@"%d",enable];
            [ws rootViewControllerShouldRefresh];
        }
    }];
    enable.enabled = self.fenceInfo ? [self.fenceInfo.enable boolValue] : self.fenceM.enable;
    
    
    PHSettingSwitchItem *devIn = [PHSettingSwitchItem itemWithTitle:PH_FenceOtherArgument_devIn completion:^(BOOL enable) {
        __strong typeof(ws) strongSelf = ws;
        strongSelf -> _devIn = [NSString stringWithFormat:@"%d",enable];
        [ws modifyDevinfo];
    }];
    devIn.enabled = self.fenceInfo ? [self.fenceInfo.devInOut.dev_in boolValue] : self.fenceM.getIn;
    
    PHSettingSwitchItem *devOut = [PHSettingSwitchItem itemWithTitle:PH_FenceOtherArgument_devOut completion:^(BOOL enable) {
        __strong typeof(ws) strongSelf = ws;
        strongSelf -> _devOut = [NSString stringWithFormat:@"%d",enable];
        [ws modifyDevinfo];
    }];
    devOut.enabled = self.fenceInfo ? [self.fenceInfo.devInOut.dev_out boolValue] : self.fenceM.getOut;

    PHSettingItem *name = [PHSettingArrowItem itemWithTitle:PH_FenceOtherArgument_name];
    name.subtitle = self.fenceInfo ? self.fenceInfo.name : self.fenceM.fenceName;
    __weak PHSettingItem *nameWeak = name;
    name.option = ^{
        if (PH_iOS(8.0)) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入围栏名称" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                textField.placeholder = @"围栏名称";
                textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            }];
            [alertController addAction:[ws actionWithTitle:@"取消" actionStyle:UIAlertActionStyleCancel handler:nil]];
            [alertController addAction:[ws actionWithTitle:@"确定" actionStyle:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                UITextField *textF =  [alertController.textFields firstObject];
                if (textF.text.length > 20) {
                    [MBProgressHUD showError:@"字符长度不能超过20"];
                    return ;
                }
                NSString *modify = textF.text;
                modify = [modify stringByReplacingOccurrencesOfString:@" " withString:@""];
                textF.text.length != 0 && modify.length != 0 ? [ws modifyFenceName:modify] : nil;
            }]];
            [ws presentViewController:alertController animated:YES completion:nil];
        }
        else {//在iOS7以下版本使用这串代码
            PHSettingArgumentController *settingArgu = [[PHSettingArgumentController alloc] initWithCompletion:^(NSString *value) {
                if (value.length > 20) {
                    [MBProgressHUD showError:@"字符长度不能超过20"];
                    return ;
                }
                NSString *modify = value;
                modify = [modify stringByReplacingOccurrencesOfString:@" " withString:@""];
                value.length != 0&& modify.length != 0 ? [ws modifyFenceName:modify] : nil;
            }];
            settingArgu.titleArgument = nameWeak.title;
            settingArgu.subtitleArgument = nameWeak.subtitle;
            PHNavigationController *navi = [[PHNavigationController alloc] initWithRootViewController:settingArgu];
            [ws.navigationController presentViewController:navi animated:YES completion:nil];
        }
    };
    
    PHSettingItem *threshold = [PHSettingArrowItem itemWithTitle:PH_FenceOtherArgument_threshold];
    threshold.subtitle = self.fenceInfo ? self.fenceInfo.threshold : [NSString stringWithFormat:@"%@",@(self.fenceM.threshold)];
    __weak PHSettingItem *threholdWeak = threshold;
    threshold.option = ^{
        if (PH_iOS(8.0)) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入围栏报警阈值" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                textField.placeholder = @"围栏报警阈值，限数字";
                textField.keyboardType = UIKeyboardTypeNumberPad;
                textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            }];
            [alertController addAction:[ws actionWithTitle:@"取消" actionStyle:UIAlertActionStyleCancel handler:nil]];
            [alertController addAction:[ws actionWithTitle:@"确定" actionStyle:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                UITextField *textF =  [alertController.textFields firstObject];
                if ([textF.text integerValue] > PH_MaxOfThreshold) {
                    [MBProgressHUD showError:[NSString stringWithFormat:@"阈值最大%d",PH_MaxOfThreshold]];
                    return;
                }
                if ([textF.text integerValue] == 0) {
                    [MBProgressHUD showError:@"阈值不能为0"];
                    return;
                }
                NSString *modify = textF.text;
                modify = [modify stringByReplacingOccurrencesOfString:@" " withString:@""];
                textF.text.length != 0 && modify.length != 0 ? [ws modifyFenceThreshold:modify] : nil;
            }]];
            [ws presentViewController:alertController animated:YES completion:nil];
        }
        else {//在iOS7以下版本使用这串代码
            PHSettingArgumentController *settingArgu = [[PHSettingArgumentController alloc] initWithCompletion:^(NSString *value) {
                if ([value integerValue] > PH_MaxOfThreshold) {
                    [MBProgressHUD showError:[NSString stringWithFormat:@"阈值最大%d",PH_MaxOfThreshold]];
                    return;
                }
                if ([value integerValue] == 0) {
                    [MBProgressHUD showError:@"阈值不能为0"];
                    return;
                }
                NSString *modify = value;
                modify = [modify stringByReplacingOccurrencesOfString:@" " withString:@""];
                value.length != 0 && modify.length != 0 ? [ws modifyFenceThreshold:modify] : nil;
            }];
            settingArgu.titleArgument = threholdWeak.title;
            settingArgu.subtitleArgument = threholdWeak.subtitle;
            PHNavigationController *navi = [[PHNavigationController alloc] initWithRootViewController:settingArgu];
            [ws.navigationController presentViewController:navi animated:YES completion:nil];
        }
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
        shape.subtitle = [NSString stringWithFormat:@"%ld边形",(unsigned long)array.count];
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

//    [self testAndcouldDelete];
    [self searchDevidFromFenceid:self.fenceInfo.fenceid];
}

//可删除
- (void)testAndcouldDelete {
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    PHSettingGroup *group = [[PHSettingGroup alloc] init];
    group.header = delegate.remoteAlarmInfo;
    PHSettingItem *devid = [PHSettingItem itemWithTitle:@"测试"];
    devid.subtitle = self.fenceInfo.devInOut.devid;
    group.items = @[devid];
    [self.dataSource addObject:group];
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
                PHSettingItem *devid = [PHSettingItem itemWithTitle:[NSString stringWithFormat:@"设备号%ld",(unsigned long)i]];
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
    if (self.fenceM) {
        self.fenceM.getIn = [_devIn boolValue];
        self.fenceM.getOut = [_devOut boolValue];
    }
    else {
        NSString *devinfo = [NSString stringWithFormat:@"%@,%@,%@",self.fenceInfo.devInOut.devid,_devIn,_devOut];
        [GMFenceManager modifyFenceWithFenceId:self.fenceInfo.fenceid devinfo:devinfo completion:^(BOOL success) {
//            success ? PHLog(@"modify devinfo Fence success") : PHLog(@"modify devinfo Fence failure");
        } failure:nil];
        [self rootViewControllerShouldRefresh];
        self.fenceInfo.devInOut.dev_in = _devIn;
        self.fenceInfo.devInOut.dev_out = _devOut;
    }
}

- (void)modifyFenceName:(NSString *)name {
    PH_WS(ws);
    if (self.fenceM) {
        self.fenceM.fenceName = name;
    }
    else {
        [GMFenceManager modifyFenceWithFenceId:self.fenceInfo.fenceid name:name completion:^(BOOL success) {
            if (success) {
                PHLog(@"modify name Fence success");
                ws.fenceInfo.name = name;
            } else {
                PHLog(@"modify name Fence failure");
            }
        } failure:nil];
    }
    [self updateTableView:name];

}

- (void)modifyFenceThreshold:(NSString *)threshold {
    PH_WS(ws);
    if (self.fenceM) {
        self.fenceM.threshold = (NSUInteger)[threshold integerValue];
    }
    else {
        [GMFenceManager modifyFenceWithFenceId:self.fenceInfo.fenceid threshold:threshold completion:^(BOOL success) {
            if (success) {
                PHLog(@"modify threshold Fence success");
                ws.fenceInfo.threshold = threshold;
            } else {
                PHLog(@"modify threshold Fence failure");
            }
        } failure:nil];
    }
    [self updateTableView:threshold];

}

- (void)updateTableView:(NSString *)subtitle {
    PHSettingGroup *group = self.dataSource[self.selectedIndexPath.section];
    PHSettingItem *item = group.items[self.selectedIndexPath.row];
    item.subtitle = subtitle;
    [self.tableView reloadRowsAtIndexPaths:@[self.selectedIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self rootViewControllerShouldRefresh];
}

- (UIAlertAction *)actionWithTitle:(NSString *)title actionStyle:(UIAlertActionStyle)style handler:(void (^)(UIAlertAction *action))handler
{
    if (style == UIAlertActionStyleCancel) {
        return [UIAlertAction actionWithTitle:title style:style handler:handler];
    }
    return [UIAlertAction actionWithTitle:title style:style handler:handler];
}

- (void)rootViewControllerShouldRefresh {
    PHFenceListController *fenceList = [self.navigationController.viewControllers firstObject];
    fenceList.fenceArgumentChanged = YES;
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





