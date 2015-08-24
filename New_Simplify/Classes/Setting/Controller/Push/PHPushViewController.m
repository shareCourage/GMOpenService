//
//  PHPushViewController.m
//  SimplifiedApp
//
//  Created by Kowloon on 15/6/29.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#define PH_Chinese  @"中文"
#define PH_English  @"English"
#define PH_None     @"无"
#define PH_Have     @"有"
#define PH_In       @"进入"
#define PH_Out      @"出去"
#define PH_InOut    @"进出"

#import "PHPushViewController.h"
#import "PHSettingGroup.h"
#import "PHSettingItem.h"
#import "PHSettingSwitchItem.h"
#import "PHSettingArrowItem.h"

@interface PHPushViewController ()
{
    __block NSUInteger _value;
}

@property (nonatomic, strong)NSIndexPath *selectedIndexPath;

@end

@implementation PHPushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    GMPushManager *push = [GMPushManager manager];
    [push getPushInfoWithDevid:[PHTool getDeviceIdFromUserDefault] completionBlock:^(GMPushInfo *pushInfo) {
        [self loadTableViewData:pushInfo];
    } failureBlock:nil];
    
#if 0
    push.lang = @"en";//@"zh_CN";
    [push updatePushTypeWithDevid:[PHTool getDeviceIdFromUserDefault] completionBlock:^(BOOL success) {
        success ? PHLog(@"update success") : PHLog(@"update failure");
    } failureBlock:nil];
#endif
}

- (void)loadTableViewData:(GMPushInfo *)push
{
    PHSettingItem *alarm  = [PHSettingSwitchItem itemWithTitle:@"是否开启消息推送"];
    
    PHSettingItem *lang = [PHSettingArrowItem itemWithTitle:@"推送语言"];
    lang.subtitle = push.lang;
    PH_WS(ws);
    lang.option = ^{
        [ws alertViewShow:nil actionOne:PH_Chinese actionTwo:PH_English actionThree:nil];
    };
    PHSettingItem *alarmType = [PHSettingArrowItem itemWithTitle:@"报警类型"];
    if ([push.alarmType isEqualToString:@"1"]) {
        alarmType.subtitle = @"进入";
    }
    else if ([push.alarmType isEqualToString:@"2"]) {
        alarmType.subtitle = @"离开";
    }
    else if ([push.alarmType isEqualToString:@"1,2"]) {
        alarmType.subtitle = @"进出";
    }
    alarmType.option = ^{
        [ws alertViewShow:nil actionOne:PH_In actionTwo:PH_Out actionThree:PH_InOut];
    };
    PHSettingItem *timeZone = [PHSettingArrowItem itemWithTitle:@"报警时区"];
    timeZone.subtitle = push.timeZone;
    PHSettingItem *sound = [PHSettingArrowItem itemWithTitle:@"报警声音"];
    if ([push.sound isEqualToString:@"1"]) {
        sound.subtitle = @"开启";
    }
    else if ([push.sound isEqualToString:@"0"]) {
        sound.subtitle = @"关闭";
    }
    sound.option = ^{
        [ws alertViewShow:nil actionOne:PH_None actionTwo:PH_Have actionThree:nil];
    };
    PHSettingItem *shake = [PHSettingArrowItem itemWithTitle:@"报警振动"];
    if ([push.shake isEqualToString:@"1"]) {
        shake.subtitle = @"开启";
    }
    else if ([push.shake isEqualToString:@"0"]) {
        shake.subtitle = @"关闭";
    }
    shake.option = ^{
        [ws alertViewShow:nil actionOne:PH_None actionTwo:PH_Have actionThree:nil];
    };
    PHSettingItem *start = [PHSettingArrowItem itemWithTitle:@"报警起始时间"];
    start.subtitle = push.startTime;
    PHSettingItem *end = [PHSettingArrowItem itemWithTitle:@"报警结束时间"];
    end.subtitle = push.endTime;
    PHSettingGroup *groupOne = [[PHSettingGroup alloc] init];
    groupOne.items = @[alarm];
    
    PHSettingGroup *groupTwo = [[PHSettingGroup alloc] init];
    groupTwo.items = @[lang, alarmType, timeZone, sound, shake, start, end];
    [self.dataSource addObject:groupOne];
    [self.dataSource addObject:groupTwo];
    [self.tableView reloadData];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    self.selectedIndexPath = indexPath;
    
}

- (void)alertViewShow:(NSString *)alertTitle actionOne:(NSString *)one actionTwo:(NSString *)two actionThree:(NSString *)three
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertTitle message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    if (one) {
        UIAlertAction *oneAc = [UIAlertAction actionWithTitle:one style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            PHLog(@"%@",one);
            _value = 0;
            
        }];
        [alertController addAction:oneAc];
    }
    
    if (two) {
        UIAlertAction *twoAc = [UIAlertAction actionWithTitle:two style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            PHLog(@"%@",two);
            _value = 1;
        }];
        [alertController addAction:twoAc];
    }
    
    if (three) {
        UIAlertAction *threeAc = [UIAlertAction actionWithTitle:three style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            PHLog(@"%@",three);
            _value = 2;
        }];
        [alertController addAction:threeAc];
    }
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)reloadMyTableView
{
    [self.tableView reloadRowsAtIndexPaths:@[self.selectedIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

}
@end



#if 0
PHSettingItem *two = [PHSettingItem itemWithTitle:PH_CountOfRemotePush_Active];
two.subtitle = [NSString stringWithFormat:@"%ld",(long)[PH_UserDefaults integerForKey:PH_CountOfRemotePush_Active]];


PHSettingItem *three = [PHSettingItem itemWithTitle:PH_CountOfRemotePush_InActive];
three.subtitle = [NSString stringWithFormat:@"%ld",(long)[PH_UserDefaults integerForKey:PH_CountOfRemotePush_InActive]];
#endif



