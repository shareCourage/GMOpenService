//
//  AcountLinkViewController.m
//  FamilyCare
//
//  Created by Kowloon on 15/3/2.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import "PHAcountLinkViewController.h"

@interface PHAcountLinkViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;

@end

@implementation PHAcountLinkViewController
- (IBAction)phoneNumberSureClick {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.phoneNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)]];
}
- (void)tapClick
{
    [self.view endEditing:YES];
}

@end







