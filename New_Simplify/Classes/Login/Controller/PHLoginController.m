//
//  PHLoginController.m
//  SimplifiedApp
//
//  Created by Kowloon on 15/4/23.
//  Copyright (c) 2015年 Goome. All rights reserved.
//
#define PHDisplay_Login                     @"登录中..."
#define PHDisplay_appidValidateFaliure      @"appid验证错误"
#define PHDisplay_appidTextF_Placeholder    @"appid"
#define PHDisplay_devidTextF_Placeholder    @"设备号"
#define PHDisplay_Login_Failure             @"登录失败"
#define PHDisplay_LoginButton_title         @"登录"
#import "PHLoginController.h"
#import "AppDelegate.h"
@interface PHLoginController ()<UITextFieldDelegate>
{
    BOOL _appidStatus;
    BOOL _deviceIDStatus;
}
@property (weak, nonatomic) IBOutlet UITextField *appidTextF;
@property (weak, nonatomic) IBOutlet UITextField *devidTextF;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property(nonatomic, weak)UITextField *editTextField;

@end

@implementation PHLoginController

- (void)dealloc
{
    PHLog(@"PHLoginController->dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)loginClick:(id)sender {
    [self.view endEditing:YES];
    NSString *devidString = self.devidTextF.text;
    NSString *appidString = self.appidTextF.text;
    PH_WS(ws);
    if (devidString.length != 0 && appidString.length != 0) {
        GMLoginManager *login = [GMLoginManager manager];
        login.mapType = GMMapTypeOfBAIDU;
        [MBProgressHUD showMessage:PHDisplay_Login toView:self.view];
        [login loginWithDevid:devidString completionBlock:^(BOOL success) {
            [MBProgressHUD hideHUDForView:ws.view];
            if (success) {
                PHLog(@"登录成功");
                [ws loginSuccessWithAppid:appidString devid:devidString];
                [GMPushManager registerDeviceToken:[PH_UserDefaults objectForKey:PH_UniqueDevicetoken]];
            }
            else {
                PHLog(@"登录失败");
                [MBProgressHUD showError:PHDisplay_Login_Failure];
            }
        } failureBlock:^(NSError *error) {
            [MBProgressHUD hideHUDForView:ws.view];
            [MBProgressHUD showError:@"登录超时"];
        }];

    }
}
- (void)loginSuccessWithAppid:(NSString *)appid devid:(NSString *)devid
{
    [PHTool loginSuccessWithAppid:appid devid:devid accessToken:nil];
    UIStoryboard *storyA = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [storyA instantiateViewControllerWithIdentifier:@"PHTabBarControllerIdentity"];
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    [delegate loadHistoryDataToLocal];
    delegate.window.rootViewController = vc;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self textFieldSetup];//textField的初始化
    [self loginButtonSetup];//登录按钮的设定
    [self keyBoardSetup];//给self.view添加点击手势，以此来控制键盘
    
    _deviceIDStatus = NO;
    _appidStatus = NO;
    if (self.appidTextF.text.length != 0) {
        _appidStatus = YES;
        [self validateAppid:self.appidTextF];
    }
}
- (void)textFieldSetup
{
    self.appidTextF.keyboardType = UIKeyboardTypeNumberPad;
    self.devidTextF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    self.appidTextF.placeholder = PHDisplay_appidTextF_Placeholder;
    self.devidTextF.placeholder = PHDisplay_devidTextF_Placeholder;
    self.appidTextF.font = [UIFont systemFontOfSize:25];
    self.devidTextF.font = [UIFont systemFontOfSize:20];
    self.appidTextF.delegate = self;
    self.devidTextF.delegate = self;
    self.appidTextF.text = [PHTool getAppidFromUserDefault];
    self.devidTextF.text = [PHTool getDeviceIdFromUserDefault];
}
- (void)loginButtonSetup
{
    [self loginButtonStatusSetting];
    [self.loginButton setTitle:PHDisplay_LoginButton_title forState:UIControlStateNormal];
    self.loginButton.layer.cornerRadius = 5;
    self.loginButton.layer.masksToBounds = YES;
}
- (void)keyBoardSetup
{
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)]];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    //1.谁去处理
    //2.如何处理
    //3.监听感兴趣的内容
    [center addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyBoardWillShow:(NSNotification *)sender
{
    NSDictionary *userInfo = sender.userInfo;
    NSValue *frameValue = userInfo[@"UIKeyboardFrameEndUserInfoKey"];
    CGSize keyboardSize = [frameValue CGRectValue].size;
    CGFloat myHeight = PH_HeightOfScreen;
    CGFloat value = (myHeight - keyboardSize.height) - CGRectGetMaxY(self.editTextField.frame);
    if (value < 0) {
        CGFloat centerY = self.view.center.y + value ;
        [UIView animateWithDuration:0.3f animations:^{
            self.view.center = CGPointMake(self.view.center.x, centerY);
        }];
    }
}
- (void)keyBoardWillHide:(NSNotification *)sender
{
    CGFloat contentW = PH_WidthOfScreen;
    CGFloat contentX = 0;
    CGFloat contentY = 0;
    CGFloat contentH = PH_HeightOfScreen;
    CGRect contentF = CGRectMake(contentX, contentY, contentW, contentH);
    [UIView animateWithDuration:0.3f animations:^{
        self.view.frame = contentF;
    }];
}
- (void)hideKeyboard
{
    [self.view endEditing:YES];
}


#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.editTextField = textField;
    textField.textColor = [UIColor blackColor];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.appidTextF) {
        BOOL isMatch = [self matchWithRegex:@"^[0-9]*$" string:textField.text];
        if (textField.text.length == 0) isMatch = NO;
        isMatch ? [self validateAppid:textField] : [self setupViewStatus:NO textField:textField];
    }
    else if (textField == self.devidTextF) {
        BOOL isMatch = [self matchWithRegex:@"^[a-zA-Z0-9_]+$" string:textField.text];
        if (textField.text.length == 0) isMatch = NO;
        [self setupViewStatus:isMatch textField:textField];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.appidTextF) {
        [self showTheStatus:textField replacementString:string regex:@"^[0-9]*$"];
    }
    else if (textField == self.devidTextF){//^[a-zA-Z0-9_\u4e00-\u9fa5]+$ ^[a-zA-Z0-9_]+$
        [self showTheStatus:textField replacementString:string regex:@"^[a-zA-Z0-9_]+$"];
    }
    return YES;
}


#pragma mark - method
- (void)showTheStatus:(UITextField *)textField replacementString:(NSString *)string regex:(NSString *)regex
{
    NSString *textFAndString = [self getTextFieldCurrentText:textField replacementString:string];
    BOOL isMatch = [self matchWithRegex:regex string:textFAndString];
    if (textFAndString.length == 0) isMatch = NO;
    [self setupViewStatus:isMatch textField:textField];
}
- (NSString *)getTextFieldCurrentText:(UITextField *)textField replacementString:(NSString *)string
{
    NSString *textFAndString = nil;
    if (string.length != 0) {
        //针对写入
        textFAndString = [textField.text stringByAppendingString:string];
    }
    else {
        //针对删除
        textFAndString = [textField.text substringWithRange:NSMakeRange(0, textField.text.length - 1)];
    }
    return textFAndString;
}

- (BOOL)matchWithRegex:(NSString *)regex string:(NSString *)string
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:string];
}

- (void)setupViewStatus:(BOOL)status textField:(UITextField *)textField
{
    if (textField == self.appidTextF) {
        _appidStatus = status;
    }
    else if (textField == self.devidTextF) {
        _deviceIDStatus = status;
    }
    [self loginButtonStatusSetting];
}

- (void)loginButtonStatusSetting
{
    if (_appidStatus && _deviceIDStatus) {
        self.loginButton.enabled = YES;
        [self.loginButton setBackgroundColor:PH_RGBColor(85, 136, 158)];
    }
    else{
        self.loginButton.enabled = NO;
        [self.loginButton setBackgroundColor:[UIColor grayColor]];
    }
}


- (void)validateAppid:(UITextField *)textField
{
    PH_WS(ws);
    GMOpenManager *open = [GMOpenManager manager];
    [open validateWithKey:textField.text completionBlock:^(GMOpenPermissionStatus status) {
        if (status == GMOpenPermissionStatusOfSuccess) {
            PHLog(@"appid验证成功");
            [PH_UserDefaults setObject:textField.text forKey:PH_UniqueAppid];
            [ws setupViewStatus:YES textField:textField];
            textField.textColor = PH_RGBColor(85, 136, 158);
        }
        else if (status == GMOpenPermissionStatusOfFailure) {
            PHLog(@"appid验证失败");
            [PH_UserDefaults setObject:nil forKey:PH_UniqueAppid];
            [ws setupViewStatus:NO textField:textField];
            [MBProgressHUD showError:PHDisplay_appidValidateFaliure];
            textField.textColor = [UIColor grayColor];
        }
    }];
}

@end














