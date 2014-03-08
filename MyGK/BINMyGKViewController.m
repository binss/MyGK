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



- (IBAction)uploadPIC:(id)sender
{
//    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1:8000/pic/UserUploadPic/kankore-bath-shimakaze.png/"];
//    [self.picccccc setImageWithURL:url placeholderImage:[UIImage imageNamed:@"profile-image-placeholder"]];
    
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //隐藏toolbar
    [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
//    self.navigationItem.backBarButtonItem= [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:nil];
}



@end
