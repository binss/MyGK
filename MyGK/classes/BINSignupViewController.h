//
//  BINSignupViewController.h
//  MyGK
//
//  Created by bin on 14-2-23.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BINSignupViewController : UITableViewController

- (IBAction)checkButtonPressed:(UIButton *)sender;
- (IBAction)signupButtonPressed:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
- (IBAction)userEditingChanged:(UITextField *)sender;
- (IBAction)nameEditingChanged:(UITextField *)sender;
- (IBAction)passwordEditingChanged:(UITextField *)sender;


@property BOOL userChecked;
@end
