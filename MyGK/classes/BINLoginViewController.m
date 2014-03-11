//
//  BINLoginViewController.m
//  MyGK
//
//  Created by bin on 14-2-23.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import "BINLoginViewController.h"
#import "AFNetworking.h"
#import "BINUserModel.h"
#import "ServerAddressSetting.h"

@interface BINLoginViewController ()

@end

@implementation BINLoginViewController

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
//    [self.tabBarController setHidesBottomBarWhenPushed:YES];
    self.loginButton.enabled = NO;
    [self.userTextField becomeFirstResponder];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButtonPressed:(UIButton *)sender
{
    if([self checkUserTextFieldLegal] && [self checkPasswordTextFieldLegal])
    {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        NSDictionary *parameters = @{@"user":self.userTextField.text,@"password":self.passwordTextField.text};
        [manager POST:@"http://127.0.0.1:8000/login/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
        {
            NSLog(@"JSON: %@",responseObject);
            NSNumber *state = [responseObject objectForKey:@"state"];
            NSNumber *level = [responseObject objectForKey:@"level"];

            if(state.boolValue)
            {
                [[BINUserModel sharedUserData] setLoginState:YES];
                [[BINUserModel sharedUserData] setUser:self.userTextField.text];
                [[BINUserModel sharedUserData] setName:[responseObject objectForKey:@"name"]];
                [[BINUserModel sharedUserData] setLevel:level.intValue];
                [self getIcon:self.userTextField.text];

                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录成功" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            else
            {
                self.errorLabel.text = [responseObject objectForKey:@"content"];
            }


        } failure:^(AFHTTPRequestOperation *operation, NSError *error)
        {
            NSLog(@"Error:%@",error);
        }];
    }
    
//    [[BINUserModel sharedUserData] setLoginState:YES];
//    [self performSegueWithIdentifier:@"loginSuccessful" sender:self];


}

- (void)getIcon:(NSString *)user
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSString *str = [NSString stringWithFormat:@"%@%@.png",iconServerAddress,user];
    NSURL *URL = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response)
    {
      NSURL *documentsDirectoryPath = [NSURL fileURLWithPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]];
      return [documentsDirectoryPath URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error)
    {
      [[BINUserModel sharedUserData] setIcon:[UIImage imageWithData:[NSData dataWithContentsOfURL:filePath]]];
        NSLog(@"%@",filePath);
    }];
    [downloadTask resume];
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if([[segue identifier] isEqualToString:@"loginSuccessful"])
//    {
//        UITabBarController *viewController = [segue destinationViewController];
//        viewController.selectedIndex = 1;
//        
//    }
//}

-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    //出栈，返回”我的手办“界面
    [self.navigationController popToRootViewControllerAnimated:YES];
}



- (IBAction)userEditingChanged:(UITextField *)sender
{
    [self checkTextFieldLength];
}

- (IBAction)passwordEditingChanged:(UITextField *)sender
{
    [self checkTextFieldLength];

}

- (void)checkTextFieldLength
{
    if(self.userTextField.text.length && self.passwordTextField.text.length)
    {
        self.loginButton.enabled = YES;
    }
    else
    {
        self.loginButton.enabled = NO;
    }
    
}

- (BOOL)checkUserTextFieldLegal
{
    self.errorLabel.text = @"";
    NSString * regex = @"^[A-Za-z0-9_]{3,14}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:self.userTextField.text];
    if(!isMatch)
    {
        self.errorLabel.text = @"用户名格式错误,请重新输入";
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
        self.errorLabel.text = @"密码格式错误,请重新输入";
        [self.passwordTextField becomeFirstResponder];
        return NO;
    }
    return YES;
}
@end
