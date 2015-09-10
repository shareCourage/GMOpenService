//
//  PHSettingArgumentController.h
//  New_Simplify
//
//  Created by Kowloon on 15/9/9.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PHSettingArgumentController : UITableViewController

@property (nonatomic, strong) NSString *titleArgument;

@property (nonatomic, strong) NSString *subtitleArgument;

- (instancetype)initWithCompletion:(void (^)(NSString *value))completion;

@end
