//
//  PHInputView.m
//  SimplifiedApp
//
//  Created by Kowloon on 15/5/20.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import "PHInputView.h"


@interface PHInputView ()
@property(nonatomic, weak)UIDatePicker *myDatePicker;
@property(nonatomic, weak)UIToolbar *myToolBar;
@end
@implementation PHInputView
- (void)dealloc
{
    PHLog(@"PHInputView->dealloc");
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(barButtonClick:)];
//        UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(barButtonClick:)];
        cancel.tag = 0;
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(barButtonClick:)];

//        UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(barButtonClick:)];
        done.tag = 1;
        UIToolbar *tooBar = [[UIToolbar alloc] init];
        tooBar.barStyle = UIBarStyleDefault;
        tooBar.items = @[cancel, space, done];
        self.myToolBar = tooBar;
        [self addSubview:tooBar];
        
        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
        [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:datePicker];
        self.myDatePicker = datePicker;
    }
    return self;
}

- (void)layoutSubviews
{
    CGFloat toolBarW = self.frame.size.width;
    CGFloat toolBarH = 30;
    self.myToolBar.frame = CGRectMake(0, 0, toolBarW, toolBarH);
    CGFloat datePickerY = toolBarH;
    CGFloat datePickerW = toolBarW;
    CGFloat datePickerH = self.frame.size.height - datePickerY;
    self.myDatePicker.frame = CGRectMake(0, datePickerY, datePickerW, datePickerH);
}
- (void)datePickerValueChanged:(UIDatePicker *)datePicker
{
    if ([self.delegate respondsToSelector:@selector(inputView:valueChanged:)]) {
        [self.delegate inputView:self valueChanged:datePicker.date];
    }
    PHLog(@"%@",datePicker.date);
}
- (void)barButtonClick:(UIBarButtonItem *)sender
{
    if ([self.delegate respondsToSelector:@selector(inputView:didSelectedIndex:date:)]) {
        [self.delegate inputView:self didSelectedIndex:sender.tag date:self.myDatePicker.date];
    }
}

@end
