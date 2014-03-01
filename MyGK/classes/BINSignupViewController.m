//
//  BINSignupViewController.m
//  MyGK
//
//  Created by bin on 14-2-23.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import "BINSignupViewController.h"
#import "AFNetworking.h"

@interface BINSignupViewController ()

@end

@implementation BINSignupViewController
@synthesize userChecked;


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
    [self.userTextField becomeFirstResponder];
    self.signupButton.enabled = NO;
    userChecked = NO;
    [self checkTextFieldLength];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)checkButtonPressed:(UIButton *)sender
{
    if([self checkUserTextFieldLegal])
    {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        NSDictionary *parameters = @{@"check": self.userTextField.text};
        [manager GET:@"http://127.0.0.1:8000/signup/" parameters:parameters
             success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSLog(@"JSON: %@", responseObject);
             bool state = [responseObject objectForKey:@"state"];
             if(state)
             {
                 userChecked = YES;
             }
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[responseObject objectForKey:@"content"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];

         }
             failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             NSLog(@"Error: %@", error);
         }];
    }

}


- (IBAction)signupButtonPressed:(UIButton *)sender
{
    if(!userChecked)
    {
        self.errorLabel.text = @"请先检查用户名是否可用";
    }
    else
    {
        self.signupButton.enabled = NO;
        if([self checkPasswordTextFieldLegal])
        {
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
            NSDictionary *parameters = @{@"user":self.userTextField.text,@"name":self.nameTextField.text,@"password":self.passwordTextField.text};
            [manager POST:@"http://127.0.0.1:8000/signup/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
             {
                 bool state = [responseObject objectForKey:@"state"];

                 if(state)
                 {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"注册成功" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                     [alert show];
                 }
                 
             } failure:^(AFHTTPRequestOperation *operation, NSError *error)
             {
                 NSLog(@"Error:%@",error);
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接服务端失败" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [alert show];
             }];
        }
    }
    
}

-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self performSegueWithIdentifier:@"signupSuccessful" sender:self];
}


- (IBAction)userEditingChanged:(UITextField *)sender
{
    [self checkTextFieldLength];
    userChecked = NO;
}

- (IBAction)nameEditingChanged:(UITextField *)sender
{
    [self checkTextFieldLength];
}

- (IBAction)passwordEditingChanged:(UITextField *)sender
{
    [self checkTextFieldLength];
}

- (void)checkTextFieldLength
{
    if(self.userTextField.text.length && self.nameTextField.text.length && self.passwordTextField.text.length)
    {
        self.signupButton.enabled = YES;
    }
    else
    {
        self.signupButton.enabled = NO;
    }
    
}

- (BOOL)checkUserTextFieldLegal
{
    self.errorLabel.text = @"";
    NSString * regex = @"^[A-Za-z0-9_]{6,14}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:self.userTextField.text];
    if(!isMatch)
    {
        self.errorLabel.text = @"你的用户名不符合要求,请重新输入";
        [self.userTextField becomeFirstResponder];
        return NO;
    }
    return YES;
}

- (BOOL)checkPasswordTextFieldLegal
{
    self.errorLabel.text = @"";
    NSString * regex = @"^[A-Za-z0-9_]{6,14}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:self.passwordTextField.text];
    if(!isMatch)
    {
        self.errorLabel.text = @"你的密码不符合要求,请重新输入";
        [self.passwordTextField becomeFirstResponder];
        return NO;
    }
    return YES;
}


@end
