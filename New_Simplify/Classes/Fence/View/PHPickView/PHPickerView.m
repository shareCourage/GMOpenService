//
//  PHPickerView.m
//  New_Simplify
//
//  Created by Kowloon on 15/9/6.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import "PHPickerView.h"

@interface PHPickerView () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelItem;
@property (weak, nonatomic) IBOutlet UIPickerView *myPickerView;

@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation PHPickerView
- (NSArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"];
    }
    return _dataSource;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
        self.frame = frame;
        self.myPickerView.dataSource = self;
        self.myPickerView.delegate = self;
    }
    return self;
}


- (IBAction)cancelClick:(id)sender {
}

- (IBAction)doneClick:(id)sender {
}


#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 10;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.dataSource[row];
}

@end








