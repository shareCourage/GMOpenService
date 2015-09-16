//
//  PHSettingArgumentController.m
//  New_Simplify
//
//  Created by Kowloon on 15/9/9.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import "PHSettingArgumentController.h"


@interface PHSettingArgumentController ()

@property (nonatomic, copy)void (^completion)(NSString *value);

@property (nonatomic, weak)UITextField *arguTextField;

@end

@implementation PHSettingArgumentController
- (void)dealloc {
    PHLog(@"%@ -> dealloc", NSStringFromClass([self class]));
}

- (id)init
{
    return [super initWithStyle:UITableViewStyleGrouped];
}
- (id)initWithStyle:(UITableViewStyle)style
{
    return [super initWithStyle:UITableViewStyleGrouped];
}
- (instancetype)initWithCompletion:(void (^)(NSString *value))completion {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.completion = completion;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(sureClick)];
    self.view.backgroundColor = [UIColor whiteColor];
}
- (void)backClick {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)sureClick {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    self.completion(self.arguTextField.text);
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID =@"settingArgumentCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    UITextField *textField = [[UITextField alloc] initWithFrame:cell.contentView.frame];
    if ([self.titleArgument isEqualToString:@"围栏名称"]) {
        textField.keyboardType = UIKeyboardTypeDefault;
        textField.placeholder = @"请输入围栏名称";
    } else {
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.placeholder = @"请输入围栏报警阈值";
    }
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.text = self.subtitleArgument;
    [textField becomeFirstResponder];
    [cell.contentView addSubview:textField];
    self.arguTextField = textField;
    
    return cell;
}
@end







