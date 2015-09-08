//
//  PHFenceOtherArgumentController.h
//  New_Simplify
//
//  Created by Kowloon on 15/9/6.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import "PHBaseSettingViewController.h"
@class GMDeviceFence;

@interface PHFenceOtherArgumentController : PHBaseSettingViewController

@property (nonatomic, strong) GMDeviceFence *fenceInfo;

@property (nonatomic, strong) GMFenceManager *fenceM;

@end
