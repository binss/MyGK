//
//  BINMyGKViewController.m
//  MyGK
//
//  Created by bin on 14-2-23.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import "BINMyGKViewController.h"
#import "BINUserModel.h"
@interface BINMyGKViewController ()

@end

@implementation BINMyGKViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self checkLoginState];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)checkLoginState
{
    if ([[BINUserModel sharedUserData] loginState])
    {
//        NSLog(@"login successful");

        self.loginButton.hidden = YES;
        self.signupButton.hidden = YES;
        self.signoutButton.hidden = NO;
        self.levelLabel.hidden = NO;
        self.levelLabel.text = [[NSString alloc] initWithFormat:@"Lv %d",[[BINUserModel sharedUserData] level]];
        self.nameLabel.text = [[BINUserModel sharedUserData] name];
    }
}
- (IBAction)signoutButtonPressed:(UIButton *)sender
{
    self.loginButton.hidden = NO;
    self.signupButton.hidden = NO;
    self.signoutButton.hidden = YES;
    self.levelLabel.hidden = YES;
    self.nameLabel.text = @"未登录";
}


@end
