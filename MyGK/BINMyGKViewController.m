//
//  BINMyGKViewController.m
//  MyGK
//
//  Created by bin on 14-2-23.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import "BINMyGKViewController.h"
#import "BINUserModel.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
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
    self.tabBarController.hidesBottomBarWhenPushed = YES;

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
        
        self.IconButton.enabled = YES;
        [self.IconButton setImage:[[BINUserModel sharedUserData] icon] forState:UIControlStateNormal];
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
    [[BINUserModel sharedUserData] setLoginState:NO];
    
    self.IconButton.enabled = NO;
    self.loginButton.hidden = NO;
    self.signupButton.hidden = NO;
    self.signoutButton.hidden = YES;
    self.levelLabel.hidden = YES;
    self.nameLabel.text = @"未登录";
}


- (IBAction)UploadPictureButtonPressed:(UIButton *)sender
{
    if([[BINUserModel sharedUserData] loginState])
    {
        [self performSegueWithIdentifier:@"uploadPicture" sender:self];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请先登录"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }

    
}

- (IBAction)visitDynamicButtonPressed:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"visitDynamic" sender:self];
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //隐藏toolbar
    [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
//    self.navigationItem.backBarButtonItem= [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:nil];
}



@end
