//
//  PHFilterView.m
//  SimplifiedApp
//
//  Created by Kowloon on 15/5/19.
//  Copyright (c) 2015年 Goome. All rights reserved.
//
#define PH_DataFormat @"yyyy-MM-dd HH:mm"
#define PH_HeightOfInputAccessoryView 30
#define PHFilterView_NormalHeight   30
#define PHFilterView_Offset         5
#import "PHFilterView.h"
#import "PHFilterButton.h"
#import "PHInputView.h"
@interface PHFilterView ()<UITextFieldDelegate,PHInputViewDelegate>

@property(nonatomic, strong)NSMutableArray *buttons;
@property(nonatomic, weak)PHFilterButton *selectedButton;
@property(nonatomic, weak)UITextField *startTextF;
@property(nonatomic, weak)UITextField *endTextF;
@property(nonatomic, weak)UIView *contentView;
@property(nonatomic, weak)UILabel *filterTitle;
@property(nonatomic, weak)UIButton *leftBtn;
@property(nonatomic, weak)UIButton *rightBtn;

@property(nonatomic, strong)NSDate *beginDate;
@property(nonatomic, strong)NSDate *endDate;
@property(nonatomic, weak)PHInputView *myInputView;
@property(nonatomic, weak)UITextField *editingTextField;
@end

@implementation PHFilterView
- (void)dealloc
{
    PHLog(@"PHFilterView->dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (NSMutableArray *)buttons
{
    if (_buttons == nil) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.buttonTitles = @[@"今天",@"昨天",@"前天",@"一小时前",@"自定义"];
        self.title = @"选择回放时间";
        self.displayTextField = YES;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        
        UIView *contentV = [self addContentView];
        [self addfilterTitleView:contentV];
        [self addTextField:contentV];
        [self addFileterButtonWithContentView:contentV];
        [self addBottomButton:contentV];
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)]];
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        //1.谁去处理
        //2.如何处理
        //3.监听感兴趣的内容
        [center addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [center addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}
- (void)keyBoardWillShow:(NSNotification *)sender
{
    PHLog(@"keyBoardWillShow");
    NSDictionary *userInfo = sender.userInfo;
    NSValue *frameValue = userInfo[@"UIKeyboardFrameEndUserInfoKey"];
    CGSize keyboardSize = [frameValue CGRectValue].size;
    PHLog(@"%@",NSStringFromCGSize(keyboardSize));
    CGFloat myHeight = self.frame.size.height;
    
    CGFloat value = (myHeight - keyboardSize.height) - CGRectGetMaxY(self.contentView.frame);
    if (value < 0) {
        CGFloat centerY = self.contentView.center.y + value ;
        [UIView animateWithDuration:0.3f animations:^{
            self.contentView.center = CGPointMake(self.contentView.center.x, centerY);
        }];
    }
}
- (void)keyBoardWillHide:(NSNotification *)sender
{
    PHLog(@"keyBoardWillHide");
    CGFloat contentW = self.contentView.frame.size.width;
    CGFloat contentX = self.center.x - contentW / 2;
    CGFloat contentY = 0;
    CGFloat contentH = self.contentView.frame.size.height;
    CGRect contentF = CGRectMake(contentX, contentY, contentW, contentH);
    [UIView animateWithDuration:0.3f animations:^{
        self.contentView.frame = contentF;
    }];
}
- (void)tapClick
{
    [self endEditing:YES];
}
- (void)layoutSubviews
{
    if (!self.isDisplayTextField) {
        self.startTextF.hidden = YES;
        self.endTextF.hidden = YES;
    }
    CGFloat contentViewY = 0;
    CGFloat contentViewW = 180;
    if (self.frame.size.width < contentViewW) {
        contentViewW = self.frame.size.width;
    }
    CGFloat contentViewH = PHFilterView_NormalHeight * 2 + (PHFilterView_NormalHeight + PHFilterView_Offset) * self.buttonTitles.count + PHFilterView_Offset;
    if (self.isDisplayTextField) {
        contentViewH = contentViewH + PHFilterView_NormalHeight * 2 + PHFilterView_Offset * 2;
    }
    CGFloat contentViewX = self.center.x - contentViewW / 2;
    CGRect contentViewF = CGRectMake(contentViewX, contentViewY, contentViewW, contentViewH);
    //1、contentView frame
    self.contentView.frame = contentViewF;
    //2、filterTiltle frame
    self.filterTitle.frame = CGRectMake(0, 0, contentViewW, PHFilterView_NormalHeight);
    
    
    //3、buttons frame
    for (int i = 0; i < self.buttons.count; i ++) {
        PHFilterButton *button = self.buttons[i];
        CGFloat buttonX = 10;
        CGFloat buttonY = (PHFilterView_NormalHeight  + PHFilterView_Offset) * (i + 1);
        CGFloat buttonW = self.contentView.frame.size.width;
        CGFloat buttonH = PHFilterView_NormalHeight;
        CGRect buttonF = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        button.frame = buttonF;
    }
    
    //4、startTextF and endTextF frame
    CGFloat startX = 10;
    CGFloat startY = PHFilterView_NormalHeight + (PHFilterView_NormalHeight + PHFilterView_Offset) * self.buttonTitles.count + PHFilterView_Offset;
    CGFloat startW = 150;
    CGFloat startH = PHFilterView_NormalHeight;
    CGRect startFrame = CGRectMake(startX, startY, startW, startH);
    CGFloat endX = startX;
    CGFloat endY = startY + startH + PHFilterView_Offset;
    CGFloat endW = startW;
    CGFloat endH = startH;
    CGRect endFrame = CGRectMake(endX, endY, endW, endH);
    self.startTextF.frame = startFrame;
    self.endTextF.frame = endFrame;
    
    //5、leftBtn and rightBtn frame
    CGFloat slip = 0.3f;
    CGFloat buttonX = 0;
    CGFloat buttonH = PHFilterView_NormalHeight;
    CGFloat buttonY = self.contentView.frame.size.height - buttonH;
    CGFloat buttonW = self.contentView.frame.size.width / 2 - slip;
    CGRect buttonF = CGRectMake(buttonX, buttonY, buttonW, buttonH);
    self.leftBtn.frame = buttonF;
    buttonX = self.contentView.frame.size.width / 2 + slip;
    buttonF = CGRectMake(buttonX, buttonY, buttonW, buttonH);
    self.rightBtn.frame = buttonF;
}

- (void)addBottomButton:(UIView *)contentView;
{
    
    UIButton *buttonOne = [UIButton buttonWithFrame:CGRectZero target:self action:@selector(bottomButtonClick:) normalImage:nil title:@"取消"];
    [contentView addSubview:buttonOne];
    buttonOne.tag = PHFilterViewStatuOfCancel;

    UIButton *buttonTwo = [UIButton buttonWithFrame:CGRectZero target:self action:@selector(bottomButtonClick:) normalImage:nil title:@"确定"];
    buttonTwo.tag = PHFilterViewStatuOfSure;
    [contentView addSubview:buttonTwo];
    [buttonOne setBackgroundColor:[[UIColor blueColor] colorWithAlphaComponent:0.5f]];
    [buttonTwo setBackgroundColor:[[UIColor blueColor] colorWithAlphaComponent:0.5f]];
    self.leftBtn = buttonOne;
    self.rightBtn = buttonTwo;

}
- (void)addTextField:(UIView *)contentView
{
    UIFont *textFont = [UIFont systemFontOfSize:12.0f];
    UITextField *startTextF = [UITextField textFieldWithFrame:CGRectZero
                                                  borderStyle:UITextBorderStyleRoundedRect
                                              backgroundColor:[UIColor whiteColor]
                                                  placeholder:@"开始时间"
                                                    textColor:nil
                                                textAlignment:NSTextAlignmentCenter
                                                         font:textFont];
    
    UITextField *endTextF = [UITextField textFieldWithFrame:CGRectZero
                                                  borderStyle:UITextBorderStyleRoundedRect
                                              backgroundColor:[UIColor whiteColor]
                                                  placeholder:@"结束时间"
                                                    textColor:nil
                                                textAlignment:NSTextAlignmentCenter
                                                         font:textFont];
    [contentView addSubview:startTextF];
    [contentView addSubview:endTextF];
    self.startTextF = startTextF;
    self.endTextF = endTextF;
    startTextF.delegate = self;
    endTextF.delegate = self;
    
    PHInputView *inputView = [[PHInputView alloc] initWithFrame:CGRectMake(0, 0, PH_WidthOfScreen, 250)];
    inputView.delegate = self;
    startTextF.inputView = inputView;
    endTextF.inputView = inputView;
    self.myInputView = inputView;
}
- (UIView *)addContentView
{
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = PH_RGBColor(230, 230, 230);
    [self addSubview:contentView];
    self.contentView = contentView;
    contentView.layer.cornerRadius = 5;
    contentView.layer.masksToBounds = YES;
    return contentView;
}
- (void)addfilterTitleView:(UIView *)contentView
{
    UILabel *filterTitle = [[UILabel alloc] init];
    filterTitle.text = self.title;
    filterTitle.textColor = [UIColor blackColor];
    filterTitle.textAlignment = NSTextAlignmentCenter;
    filterTitle.font = [UIFont boldSystemFontOfSize:PHSystemFontSize];
    filterTitle.backgroundColor = [UIColor clearColor];
    filterTitle.backgroundColor = [UIColor lightGrayColor];
    [contentView addSubview:filterTitle];
    self.filterTitle = filterTitle;
}
- (void)addFileterButtonWithContentView:(UIView *)contentView
{
    for (int i = 0; i < self.buttonTitles.count; i ++) {
        NSString *title = self.buttonTitles[i];
        PHFilterButton *fileterButton = [PHFilterButton fileterButtonWithTitle:title];
        fileterButton.tag = i;
        [fileterButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttons addObject:fileterButton];
        [contentView addSubview:fileterButton];
        if (i == 0) {
            [self buttonClick:fileterButton];
        }
    }
}

- (void)buttonClick:(PHFilterButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(filterView:didSelectButtonFrom:to:)]) {
        [self.delegate filterView:self didSelectButtonFrom:self.selectedButton.tag to:sender.tag];
    }
    // 1.让当前选中的按钮取消选中
    self.selectedButton.selected = NO;
    // 2.让新点击的按钮选中
    sender.selected = YES;
    // 3.新点击的按钮就成为了"当前选中的按钮"
    self.selectedButton = sender;
    if (![self.selectedButton isEqual:[self.buttons lastObject]] || self.buttons.count == 1) {
        [self endEditing:YES];
        [self textFieldLoadValue:sender.tag];
    }
    
}
- (void)textFieldLoadValue:(NSUInteger)tag
{
    NSDate *date = [NSDate date];
    switch (tag) {
        case 0://当天
            self.beginDate = [NSDate midnightDateFromDate:date];
            self.endDate = date;
            break;
        case 1://昨天
            self.beginDate = [NSDate midnightDateFromDate:[date dateAfterDay:-1]];
            self.endDate = [NSDate lastMinuteFromDate:[date dateAfterDay:-1]];
            break;
        case 2://前天
            self.beginDate = [NSDate midnightDateFromDate:[date dateAfterDay:-2]];
            self.endDate = [NSDate lastMinuteFromDate:[date dateAfterDay:-2]];
            break;
        case 3://一小时前
            self.beginDate = [date dateHoursAgo:-1];
            self.endDate = date;
            break;
            
        default:
            break;
    }
    PHLog(@"beginDate->%@",self.beginDate);
    PHLog(@"endDate->%@",self.endDate);
    self.startTextF.text = [self.beginDate stringFromDateFormat:PH_DataFormat];
    self.endTextF.text = [self.endDate stringFromDateFormat:PH_DataFormat];
}


- (void)bottomButtonClick:(UIButton *)sender
{
    PHFilterViewStatus status;
    if (sender.tag == PHFilterViewStatuOfCancel) {
        status = PHFilterViewStatuOfCancel;
    }
    else{
        status = PHFilterViewStatuOfSure;
    }

    if ([self.delegate respondsToSelector:@selector(filterView:didSelectStatu:withStartTime:endTime:)]) {
        if (self.isDisplayTextField) {
            [self endEditing:YES];
            [self.delegate filterView:self didSelectStatu:status withStartTime:[self.beginDate timeIntervalSince1970] endTime:[self.endDate timeIntervalSince1970]];
        }
        else {
            [self.delegate filterView:self didSelectStatu:status withStartTime:0 endTime:0];
        }
        
    }
}
#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    PHFilterButton *button = [self.buttons lastObject];
    [self buttonClick:button];
    self.editingTextField = textField;
}

#pragma mark - PHInputViewDelegate
- (void)inputView:(PHInputView *)inputView didSelectedIndex:(NSUInteger)index date:(NSDate *)date
{
    if (index == 0) {
        [self endEditing:YES];
    }
    else if (index == 1){
        [self bottomButtonClick:self.rightBtn];
    }
}

- (void)inputView:(PHInputView *)inputView valueChanged:(NSDate *)date
{
    self.editingTextField.text = [NSDate stringFromDate:date dateFormat:PH_DataFormat];
    if (self.editingTextField == self.startTextF) {
        self.beginDate = date;
    }
    else if (self.editingTextField == self.endTextF){
        self.endDate = date;
    }
}

@end



