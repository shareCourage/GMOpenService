//
//  PHFilterButton.h
//  SimplifiedApp
//
//  Created by Kowloon on 15/5/19.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PHFilterButton : UIButton

- (instancetype)initWithTitle:(NSString *)title withFrame:(CGRect)frame;
+ (instancetype)fileterButtonWithTitle:(NSString *)title withFrame:(CGRect)frame;
+ (instancetype)fileterButtonWithTitle:(NSString *)title;
@end
