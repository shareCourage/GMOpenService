//
//  PHPushViewController.m
//  SimplifiedApp
//
//  Created by Kowloon on 15/6/29.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

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

#define PH_HeightOfPickView 220

#import "PHPushViewController.h"
#import "PHSettingGroup.h"
#import "PHSettingItem.h"
#import "PHSettingSwitchItem.h"
#import "PHSettingArrowItem.h"

@interface PHPushViewController ()<UIActionSheetDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
{
    GMPushManager *_pushM;
    __block NSUInteger _actionRow;
}
@property (nonatomic, strong)NSIndexPath *selectedIndexPath;
@property (nonatomic, strong)PHSettingItem *selectedItem;

@property (nonatomic, weak) UIPickerView *pickerView;
@property (nonatomic, strong)NSMutableArray *pickDataSource;
@end

@implementation PHPushViewController
- (NSMutableArray *)pickDataSource {
    if (!_pickDataSource) {
        _pickDataSource = [NSMutableArray array];
        for (NSUInteger i = 0; i < 25; i ++) {
            [_pickDataSource addObject:[NSString stringWithFormat:@"%ld",(unsigned long)i]];
        }
    }
    return _pickDataSource;
}
- (void)dealloc
{
    PHLog(@"%@ ---> dealloc",NSStringFromClass([self class]));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self pickViewInstance];
    [self loadTableViewData:nil];
    _pushM = [GMPushManager manager];
    [_pushM getPushInfoWithDevid:[PHTool getDeviceIdFromUserDefault] completionBlock:^(GMPushInfo *pushInfo) {
        [self loadTableViewData:pushInfo];
    } failureBlock:nil];
}

- (void)loadTableViewData:(GMPushInfo *)push
{
    _pushM.startTime = @([push.startTime floatValue]);
    _pushM.endTime = @([push.endTime floatValue]);
    [self.dataSource removeAllObjects];
    
    PHSettingItem *alarm  = [PHSettingSwitchItem itemWithTitle:@"是否开启消息推送"];
    
    PHSettingItem *lang = [PHSettingArrowItem itemWithTitle:PH_Push_lang];
    if(push.lang.length != 0) [push.lang isEqualToString:@"en"] ? (lang.subtitle = PH_English) : (lang.subtitle = PH_Chinese);
    
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
    else if ([push.alarmType hasPrefix:@"1,2"]){
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
    timeZone.subtitle = [push.timeZone isEqualToString:@"28800"] ? @"北京" : push.timeZone;
    timeZone.option = ^{
        [ws alertViewShow:nil actionOne:@"28800" actionTwo:@"29600" actionThree:@"30400"];
    };
    
    PHSettingItem *start = [PHSettingArrowItem itemWithTitle:PH_Push_startTime];
    start.subtitle = push.startTime.length == 0 ? nil : [NSString stringWithFormat:@"%@",@([push.startTime floatValue] / 60)];
    start.option = ^{
//        [ws alertViewShow:nil actionOne:@"0" actionTwo:@"720" actionThree:@"1200"];
        [UIView animateWithDuration:0.5f animations:^{
            self.pickerView.frame = CGRectMake(0, PH_HeightOfScreen - PH_HeightOfPickView, PH_WidthOfScreen, PH_HeightOfPickView);
        }];
    };
    
    PHSettingItem *end = [PHSettingArrowItem itemWithTitle:PH_Push_endTime];
    end.subtitle = push.startTime.length == 0 ? nil :[NSString stringWithFormat:@"%@",@([push.endTime floatValue] / 60)];
    end.option = ^{
//        [ws alertViewShow:nil actionOne:@"0" actionTwo:@"720" actionThree:@"1200"];
        [UIView animateWithDuration:0.5f animations:^{
            self.pickerView.frame = CGRectMake(0, PH_HeightOfScreen - PH_HeightOfPickView, PH_WidthOfScreen, PH_HeightOfPickView);
        }];
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
    [UIView animateWithDuration:0.5f animations:^{
        self.pickerView.frame = CGRectMake(0, PH_HeightOfScreen, PH_WidthOfScreen, PH_HeightOfPickView);
    }];
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    self.selectedIndexPath = indexPath;
    PHSettingGroup *group = self.dataSource[indexPath.section];
    PHSettingItem *item = group.items[indexPath.row];
    self.selectedItem = item;
}
- (void)alertViewShow:(NSString *)alertTitle actionOne:(NSString *)one actionTwo:(NSString *)two actionThree:(NSString *)three
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:alertTitle delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:one, two, three, nil];
    [actionSheet showInView:self.view];
}

- (void)reloadMyTableViewWithSubtitle:(NSString *)subtitle
{
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
        {
            PHLog(@"starttime->%@",subtitle);
            _pushM.startTime = @([subtitle floatValue] * 60);
            if ([_pushM.startTime floatValue] >= [_pushM.endTime floatValue]) {
                [MBProgressHUD showError:@"必须小于结束时间"];
                return;
            }
        }
            break;
        case 6:
        {
            PHLog(@"endtime->%@",subtitle);
            _pushM.endTime = @([subtitle floatValue] * 60);
            if ([_pushM.startTime floatValue] >= [_pushM.endTime floatValue]) {
                [MBProgressHUD showError:@"必须大于起始时间"];
                return;
            }
        }
            break;
        default:
            break;
    }
    self.selectedItem.subtitle = subtitle;
    [self.tableView reloadRowsAtIndexPaths:@[self.selectedIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [_pushM updatePushTypeWithDevid:[PHTool getDeviceIdFromUserDefault] completionBlock:^(BOOL success) {
//        success ? PHLog(@"update success") : PHLog(@"update failure");
    } failureBlock:nil];


}
#pragma mark - UIPickerView Instance
- (void)pickViewInstance {
    UIPickerView *pick = [[UIPickerView alloc] initWithFrame:CGRectMake(0, PH_HeightOfScreen, PH_HeightOfScreen, PH_HeightOfPickView)];
    pick.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.6f];
    pick.dataSource = self;
    pick.delegate = self;
    [self.view addSubview:pick];
    self.pickerView = pick;
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"取消"]) return;
    _actionRow = buttonIndex;
    [self reloadMyTableViewWithSubtitle:title];
    PHLog(@"title %@",title);
}
#pragma mark - UIPickerViewDataSource UIPickerViewDelegate
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 24;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = self.pickDataSource[row];
    return title;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *title = self.pickDataSource[row];
    PHLog(@"select %@",title);
    [self reloadMyTableViewWithSubtitle:title];
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        if (self.pickerView.frame.origin.y < PH_HeightOfScreen) {
            [UIView animateWithDuration:0.5f animations:^{
                self.pickerView.frame = CGRectMake(0, PH_HeightOfScreen, PH_WidthOfScreen, PH_HeightOfPickView);
            }];
        }
    }
}
#if 0
- (void)alertViewShow:(NSString *)alertTitle actionOne:(NSString *)one actionTwo:(NSString *)two actionThree:(NSString *)three
{
    if (PH_iOS(8.0)) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertTitle message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alertController addAction:[self actionWithTitle:@"取消" actionStyle:UIAlertActionStyleCancel handler:nil]];
        if (one) {
            [alertController addAction:[self actionWithTitle:one actionStyle:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                _actionRow = 0;
                [self reloadMyTableViewWithSubtitle:one];
            }]];
        }
        if (two) {
            [alertController addAction:[self actionWithTitle:two actionStyle:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                _actionRow = 1;
                [self reloadMyTableViewWithSubtitle:two];
            }]];
        }
        if (three) {
            [alertController addAction:[self actionWithTitle:three actionStyle:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                _actionRow = 2;
                [self reloadMyTableViewWithSubtitle:three];
            }]];
        }
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:one, two, three, nil];
        [actionSheet showInView:self.view];
    }
}
- (UIAlertAction *)actionWithTitle:(NSString *)title actionStyle:(UIAlertActionStyle)style handler:(void (^)(UIAlertAction *action))handler
{
    if (style == UIAlertActionStyleCancel) {
        return [UIAlertAction actionWithTitle:title style:style handler:handler];
    }
    return [UIAlertAction actionWithTitle:title style:style handler:handler];
    
}
#endif

@end


