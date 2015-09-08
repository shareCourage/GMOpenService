//
//  PHFenceTableViewCell.m
//  New_Simplify
//
//  Created by Kowloon on 15/9/1.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import "PHFenceTableViewCell.h"

static BOOL isRegisted = NO;
@interface PHFenceTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *fenceBasicInfoL;
@property (weak, nonatomic) IBOutlet UILabel *fenceShapeL;

@property (weak, nonatomic) IBOutlet UILabel *fenceRadiusL;
@property (weak, nonatomic) IBOutlet UISwitch *fenceEnable;

- (IBAction)enableAction:(UISwitch *)sender;

@end

@implementation PHFenceTableViewCell

- (void)dealloc {
    isRegisted = NO;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.fenceRadiusL.hidden = YES;
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"fenceTableCell";
    if (!isRegisted) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:ID];
        isRegisted = YES;
    }
    PHFenceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}

- (void)setDevFence:(GMDeviceFence *)devFence
{
    _devFence = devFence;
    [self setupData];
    [self setupUI];
}

- (void)setupData {
    
    if (self.devFence.name.length != 0) {
        self.fenceBasicInfoL.text = self.devFence.name;
    }
    else {
        self.fenceBasicInfoL.text = [NSString stringWithFormat:@"围栏号:%@",self.devFence.fenceid];
    }
    
    if ([self.devFence.shape isEqualToString:@"1"]) {
        self.fenceShapeL.text = @"圆形围栏";
        NSArray *array = [NSArray seprateString:self.devFence.area characterSet:@","];
        self.fenceRadiusL.text = [NSString stringWithFormat:@"半径:%@米",[array lastObject]];
        self.fenceRadiusL.hidden = NO;
    }
    else {
        NSArray *array = [NSArray seprateString:self.devFence.area characterSet:@";"];
        self.fenceShapeL.text = [NSString stringWithFormat:@"%ld边形围栏",(unsigned long)array.count];
        self.fenceRadiusL.hidden = YES;
    }
    
    self.fenceEnable.on = [self.devFence.enable boolValue];

}
- (void)setupUI {
}

- (IBAction)enableAction:(UISwitch *)sender {
    PH_WS(ws);
    [GMFenceManager modifyFenceWithFenceId:self.devFence.fenceid enable:sender.isOn completion:^(BOOL success) {
        if (success) {
            PHLog(@"modify Fence success");
            ws.devFence.enable = [NSString stringWithFormat:@"%d",sender.isOn];//实时更新devFence的属性
//            [MBProgressHUD showSuccess:@"修改成功"];
        }
        else {
            PHLog(@"modify Fence failure");
            [MBProgressHUD showError:@"修改失败"];
        }
    } failureBlock:^(NSError *error) {
        if (error) PHLog(@"modify Fence failure -> %@", error);
        [MBProgressHUD showError:@"修改失败"];
    }];
    
}
@end






