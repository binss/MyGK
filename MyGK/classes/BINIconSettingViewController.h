//
//  BINIconSettingViewController.h
//  MyGK
//
//  Created by bin on 14-3-4.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BINIconSettingViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

- (IBAction)shootPicture:(UIButton *)sender;
- (IBAction)selectExistingPicture:(UIButton *)sender;
- (IBAction)uploadButtonPressed:(UIButton *)sender;
- (IBAction)saveButtonPressed:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *uploadButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;




@property (strong, nonatomic) UIAlertView *uploadingAleatView;
@property (strong, nonatomic) UIImage *image;
@property (copy, nonatomic) NSString *chosenMediaType;

@end
