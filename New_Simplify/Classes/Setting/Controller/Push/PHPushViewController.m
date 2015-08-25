//
//  PHPushViewController.m
//  SimplifiedApp
//
//  Created by Kowloon on 15/6/29.
//  Copyright (c) 2015年 Goome. All rights reserved.
//
#define PH_Input_Height 300

#define PH_Chinese  @"中文"
#define PH_English  @"English"
#define PH_None     @"关闭"
#define PH_Have     @"开启"
#define PH_In       @"进入报警"
#define PH_Out      @"出去报警"
#define PH_InOut    @"进出报警"

#define PH_Push_lang        @"推送语言"
#define PH_Push_type        @"报警类型"
#define PH_Push_timeZone    @"报警时区"
#define PH_Push_sound       @"报警声音"
#define PH_Push_shake       @"报警振动"
#define PH_Push_startTime   @"报警起始时间"
#define PH_Push_endTime     @"报警结束时间"

#import "PHPushViewController.h"
#import "PHSettingGroup.h"
#import "PHSettingItem.h"
#import "PHSettingSwitchItem.h"
#import "PHSettingArrowItem.h"

@interface PHPushViewController ()
{
    GMPushManager *_pushM;
    __block NSUInteger _actionRow;
}
@property (nonatomic, strong)NSIndexPath *selectedIndexPath;
@property (nonatomic, strong)PHSettingItem *selectedItem;

@property (nonatomic, weak)UIDatePicker *datePicker;

@end

@implementation PHPushViewController
- (void)dealloc
{
    PHLog(@"%@ ---> dealloc",NSStringFromClass([self class]));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.automaticallyAdjustsScrollViewInsets = NO;
    [self loadTableViewData:nil];
    _pushM = [GMPushManager manager];
    [_pushM getPushInfoWithDevid:[PHTool getDeviceIdFromUserDefault] completionBlock:^(GMPushInfo *pushInfo) {
        [self loadTableViewData:pushInfo];
    } failureBlock:nil];
    UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), PH_Input_Height)];
    UIToolbar *tool = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.inputView.frame), 30)];
    
    UIDatePicker *picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 30, CGRectGetWidth(self.inputView.frame), 260)];
    [picker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    picker.datePickerMode = UIDatePickerModeTime;
    [inputView addSubview:tool];
    [inputView addSubview:picker];
    [self.view addSubview:inputView];
    
    self.datePicker = picker;
    
//    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)]];
}
- (void)tapClick
{
    PHLog(@"tapClick");
    [self pickViewAnimation:self.datePicker willHidden:YES];
}
- (void)datePickerValueChanged:(UIDatePicker *)sender
{
    PHLog(@"%@",sender.date);
}
- (void)loadTableViewData:(GMPushInfo *)push
{
    [self.dataSource removeAllObjects];
    
    PHSettingItem *alarm  = [PHSettingSwitchItem itemWithTitle:@"是否开启消息推送"];
    
    PHSettingItem *lang = [PHSettingArrowItem itemWithTitle:PH_Push_lang];
    [push.lang isEqualToString:@"en"] ? (lang.subtitle = PH_English) : (lang.subtitle = PH_Chinese);
    
    PH_WS(ws);
    lang.option = ^{
        [ws alertViewShow:nil actionOne:PH_Chinese actionTwo:PH_English actionThree:nil];
    };
    
    
    PHSettingItem *alarmType = [PHSettingArrowItem itemWithTitle:PH_Push_type];
    if ([push.alarmType isEqualToString:@"1"]) {
        alarmType.subtitle = PH_In;
    }
    else if ([push.alarmType isEqualToString:@"2"]) {
        alarmType.subtitle = PH_Out;
    }
    else if ([push.alarmType isEqualToString:@"1,2"]) {
        alarmType.subtitle = PH_InOut;
    }
    else {
        alarmType.subtitle = PH_InOut;
    }
    alarmType.option = ^{
        [ws alertViewShow:nil actionOne:PH_In actionTwo:PH_Out actionThree:PH_InOut];
    };
    
    PHSettingItem *sound = [PHSettingArrowItem itemWithTitle:PH_Push_sound];
    if ([push.sound isEqualToString:@"1"]) {
        sound.subtitle = PH_Have;
    }
    else if ([push.sound isEqualToString:@"0"]) {
        sound.subtitle = PH_None;
    }
    else {
        sound.subtitle = push.sound;
    }
    sound.option = ^{
        [ws alertViewShow:nil actionOne:PH_None actionTwo:PH_Have actionThree:nil];
    };
    
    
    PHSettingItem *shake = [PHSettingArrowItem itemWithTitle:PH_Push_shake];
    if ([push.shake isEqualToString:@"1"]) {
        shake.subtitle = PH_Have;
    }
    else if ([push.shake isEqualToString:@"0"]) {
        shake.subtitle = PH_None;
    }
    else {
        shake.subtitle = push.shake;
    }
    shake.option = ^{
        [ws alertViewShow:nil actionOne:PH_None actionTwo:PH_Have actionThree:nil];
    };
    
    PHSettingItem *timeZone = [PHSettingArrowItem itemWithTitle:PH_Push_timeZone];
    timeZone.subtitle = push.timeZone;
    timeZone.option = ^{
        [ws alertViewShow:nil actionOne:@"28800" actionTwo:@"29600" actionThree:nil];
    };
    
    PHSettingItem *start = [PHSettingArrowItem itemWithTitle:PH_Push_startTime];
    start.subtitle = push.startTime;
    start.option = ^{
//        [ws alertViewShow:nil actionOne:@"0" actionTwo:@"720" actionThree:@"1200"];
        [self pickViewAnimation:self.datePicker willHidden:NO];
    };
    
    PHSettingItem *end = [PHSettingArrowItem itemWithTitle:PH_Push_endTime];
    end.subtitle = push.endTime;
    end.option = ^{
//        [ws alertViewShow:nil actionOne:@"0" actionTwo:@"720" actionThree:@"1200"];
        [self pickViewAnimation:self.datePicker willHidden:NO];
    };
    
    PHSettingGroup *groupOne = [[PHSettingGroup alloc] init];
    groupOne.items = @[alarm];
    
    PHSettingGroup *groupTwo = [[PHSettingGroup alloc] init];
    groupTwo.items = @[lang, alarmType, sound, shake, timeZone, start, end];
    [self.dataSource addObject:groupOne];
    [self.dataSource addObject:groupTwo];
    [self.tableView reloadData];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    self.selectedIndexPath = indexPath;
    PHSettingGroup *group = self.dataSource[indexPath.section];
    PHSettingItem *item = group.items[indexPath.row];
    self.selectedItem = item;
}

- (void)alertViewShow:(NSString *)alertTitle actionOne:(NSString *)one actionTwo:(NSString *)two actionThree:(NSString *)three
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertTitle message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[self actionWithTitle:@"取消" actionStyle:UIAlertActionStyleCancel]];
    if (one) {
        _actionRow = 0;
        [alertController addAction:[self actionWithTitle:one actionStyle:UIAlertActionStyleDefault]];
    }
    if (two) {
        _actionRow = 1;
        [alertController addAction:[self actionWithTitle:two actionStyle:UIAlertActionStyleDefault]];
    }
    if (three) {
        _actionRow = 2;
        [alertController addAction:[self actionWithTitle:three actionStyle:UIAlertActionStyleDefault]];
    }
    [self presentViewController:alertController animated:YES completion:nil];
}

- (UIAlertAction *)actionWithTitle:(NSString *)title actionStyle:(UIAlertActionStyle)style
{
    if (style == UIAlertActionStyleCancel) {
        return [UIAlertAction actionWithTitle:title style:style handler:nil];
    }
    return [UIAlertAction actionWithTitle:title style:style handler:^(UIAlertAction *action) {
        [self reloadMyTableViewWithSubtitle:title];
    }];
    
}
- (void)reloadMyTableViewWithSubtitle:(NSString *)subtitle
{
    self.selectedItem.subtitle = subtitle;
    [self.tableView reloadRowsAtIndexPaths:@[self.selectedIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    switch (self.selectedIndexPath.row) {
        case 0:
            0 == _actionRow ? (_pushM.lang = @"zh_CN") : (_pushM.lang = @"en");
            break;
        case 1:
            if (0 == _actionRow) {
                _pushM.alarmType = @"1";
            }
            else if (1 == _actionRow) {
                _pushM.alarmType = @"2";
            }
            else if (2 == _actionRow) {
                _pushM.alarmType = @"1,2";
            }
            break;
        case 2:
            0 == _actionRow ? ( _pushM.sound = @0 ) : ( _pushM.sound = @1 );
            break;
        case 3:
            0 == _actionRow ? ( _pushM.shake = @0 ) : ( _pushM.shake = @1 );
            break;
        case 4:
            _pushM.timeZone = @([subtitle floatValue]);
            break;
        case 5:
            PHLog(@"starttime->%@",subtitle);
            _pushM.startTime = @([subtitle floatValue]);
            break;
        case 6:
            PHLog(@"endtime->%@",subtitle);
            _pushM.endTime = @([subtitle floatValue]);
            break;
        default:
            break;
    }
    [_pushM updatePushTypeWithDevid:[PHTool getDeviceIdFromUserDefault] completionBlock:^(BOOL success) {
        success ? PHLog(@"update success") : PHLog(@"update failure");
    } failureBlock:nil];


}


- (void)pickViewAnimation:(UIView*)view willHidden:(BOOL)hidden {
    
    [UIView animateWithDuration:0.3 animations:^{
        if (hidden) {
            view.frame = CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), 260);
        } else {
            [view setHidden:hidden];
            view.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - 245, CGRectGetWidth(self.view.frame), 260);
        }
    } completion:^(BOOL finished) {
        [view setHidden:hidden];
    }];
}

@end



#if 0
PHSettingItem *two = [PHSettingItem itemWithTitle:PH_CountOfRemotePush_Active];
two.subtitle = [NSString stringWithFormat:@"%ld",(long)[PH_UserDefaults integerForKey:PH_CountOfRemotePush_Active]];


PHSettingItem *three = [PHSettingItem itemWithTitle:PH_CountOfRemotePush_InActive];
three.subtitle = [NSString stringWithFormat:@"%ld",(long)[PH_UserDefaults integerForKey:PH_CountOfRemotePush_InActive]];
#endif



