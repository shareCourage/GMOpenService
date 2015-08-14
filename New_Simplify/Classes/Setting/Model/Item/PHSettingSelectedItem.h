//
//  PHSettingSelectedItem.h
//  FamilyCare
//
//  Created by Kowloon on 15/3/6.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import "PHSettingItem.h"

@interface PHSettingSelectedItem : PHSettingItem

@property(nonatomic, assign, getter=isSelectedItem)BOOL selectedItem;

+ (instancetype)itemWithTitle:(NSString *)title withSelected:(BOOL)select;
@end
