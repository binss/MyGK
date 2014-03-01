//
//  BINLoginViewController.h
//  MyGK
//
//  Created by bin on 14-2-23.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BINLoginViewController : UITableViewController


@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

- (IBAction)userEditingChanged:(UITextField *)sender;
- (IBAction)passwordEditingChanged:(UITextField *)sender;
- (IBAction)loginButtonPressed:(UIButton *)sender;


@end
