//
//  BINUploadPictureViewController.h
//  MyGK
//
//  Created by bin on 14-3-3.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BINUploadPictureViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

- (IBAction)shootPicture:(UIButton *)sender;
- (IBAction)selectExistingPicture:(UIButton *)sender;
- (IBAction)resetButtonPressed:(UIButton *)sender;
- (IBAction)uploadButtonPressed:(UIButton *)sender;
- (IBAction)backgroundTap:(UIControl *)sender;

@property (weak, nonatomic) IBOutlet UIButton *upLoadButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *priceField;
@property (weak, nonatomic) IBOutlet UITextField *addressField;
@property (weak, nonatomic) IBOutlet UITextField *descriptionField;



@property (strong, nonatomic) UIImage *image;
@property (copy, nonatomic) NSString *chosenMediaType;


@end
