//
//  BINMyGKViewController.h
//  MyGK
//
//  Created by bin on 14-2-23.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BINMyGKViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;
@property (weak, nonatomic) IBOutlet UIButton *signoutButton;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *IconButton;
- (IBAction)signoutButtonPressed:(UIButton *)sender;



- (IBAction)UploadPictureButtonPressed:(UIButton *)sender;
- (IBAction)visitDynamicButtonPressed:(UIButton *)sender;

@end
