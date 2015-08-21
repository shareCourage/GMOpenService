//
//  PHPushViewController.m
//  SimplifiedApp
//
//  Created by Kowloon on 15/6/29.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

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
    PHSettingItem *alarm  = [PHSettingSwitchItem itemWithTitle:@"是否开启消息推送"];

#if 0
    PHSettingItem *two = [PHSettingItem itemWithTitle:PH_CountOfRemotePush_Active];
    two.subtitle = [NSString stringWithFormat:@"%ld",(long)[PH_UserDefaults integerForKey:PH_CountOfRemotePush_Active]];
    
    PHSettingItem *three = [PHSettingItem itemWithTitle:PH_CountOfRemotePush_InActive];
    three.subtitle = [NSString stringWithFormat:@"%ld",(long)[PH_UserDefaults integerForKey:PH_CountOfRemotePush_InActive]];
#endif
    PHSettingItem *lang = [PHSettingArrowItem itemWithTitle:@"推送语言"];
    PH_WS(ws);
    lang.option = ^{
        [ws alertViewShow:nil actionOne:@"中文" actionTwo:@"En" actionThree:nil];
    };
    PHSettingItem *alarmType = [PHSettingArrowItem itemWithTitle:@"报警类型"];
    alarmType.option = ^{
        [ws alertViewShow:nil actionOne:@"进入" actionTwo:@"出去" actionThree:@"进出"];
    };
    PHSettingItem *timeZone = [PHSettingArrowItem itemWithTitle:@"报警时区"];
    
    PHSettingItem *sound = [PHSettingArrowItem itemWithTitle:@"报警声音"];
    sound.option = ^{
        [ws alertViewShow:nil actionOne:@"无" actionTwo:@"有" actionThree:nil];
    };
    PHSettingItem *shake = [PHSettingArrowItem itemWithTitle:@"报警振动"];
    shake.option = ^{
        [ws alertViewShow:nil actionOne:@"无" actionTwo:@"有" actionThree:nil];
    };
    PHSettingItem *start = [PHSettingArrowItem itemWithTitle:@"报警起始时间"];
    PHSettingItem *end = [PHSettingArrowItem itemWithTitle:@"报警结束时间"];

    PHSettingGroup *groupOne = [[PHSettingGroup alloc] init];
    groupOne.items = @[alarm];
    
    PHSettingGroup *groupTwo = [[PHSettingGroup alloc] init];
    groupTwo.items = @[lang, alarmType, timeZone, sound, shake, start, end];
    [self.dataSource addObject:groupOne];
    [self.dataSource addObject:groupTwo];

    GMPushManager *push = [GMPushManager manager];
    push.lang = @"en";//@"zh_CN";
    [push updatePushTypeWithDevid:[PHTool getDeviceIdFromUserDefault] completionBlock:^(BOOL success) {
        success ? PHLog(@"update success") : PHLog(@"update failure");
    } failureBlock:nil];
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







