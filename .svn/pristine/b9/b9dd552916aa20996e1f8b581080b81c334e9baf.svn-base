//
//  PHFilterButton.m
//  SimplifiedApp
//
//  Created by Kowloon on 15/5/19.
//  Copyright (c) 2015年 Goome. All rights reserved.
//
#define PH_ImageName_RadiosCheck    @"radio_checked"
#define PH_ImageName_RadiosUncheck  @"radio_unchecked"
#define Q_RADIO_ICON_WH                     (16.0)
#define Q_ICON_TITLE_MARGIN                 (5.0)

#import "PHFilterButton.h"

@implementation PHFilterButton
- (void)dealloc
{
    PHLog(@"PHFilterButton->dealloc");
}


- (instancetype)initWithTitle:(NSString *)title withFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [self.titleLabel setFont:[UIFont systemFontOfSize:PHSystemFontSize]];
        [self setImage:[UIImage imageNamed:PH_ImageName_RadiosUncheck] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:PH_ImageName_RadiosCheck] forState:UIControlStateSelected];
    }
    return self;
}

+ (instancetype)fileterButtonWithTitle:(NSString *)title withFrame:(CGRect)frame
{
    PHFilterButton *button = [[self alloc] initWithTitle:title withFrame:frame];
    button.frame = frame;
    return button;
}
+ (instancetype)fileterButtonWithTitle:(NSString *)title
{
    return [self fileterButtonWithTitle:title withFrame:CGRectZero];
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    return CGRectMake(0, (CGRectGetHeight(contentRect) - Q_RADIO_ICON_WH)/2.0, Q_RADIO_ICON_WH, Q_RADIO_ICON_WH);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    return CGRectMake(Q_RADIO_ICON_WH + Q_ICON_TITLE_MARGIN, 0,
                      CGRectGetWidth(contentRect) - Q_RADIO_ICON_WH - Q_ICON_TITLE_MARGIN,
                      CGRectGetHeight(contentRect));
}
@end





