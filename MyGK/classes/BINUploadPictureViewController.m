//
//  BINUploadPictureViewController.m
//  MyGK
//
//  Created by bin on 14-3-3.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import "BINUploadPictureViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "BINUploadModel.h"

@interface BINUploadPictureViewController ()

@end

@implementation BINUploadPictureViewController
@synthesize chosenMediaType;

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
//    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(doneWithView:) name:@"reload" object:nil];
    NSLog(@"caaaaa");
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.upLoadButton.enabled = NO;
    if ([self.chosenMediaType isEqual:(NSString *)kUTTypeImage])
    {
        self.imageView.image = self.image;
        self.upLoadButton.enabled = YES;
    }
    else if([chosenMediaType isEqual:(NSString *)kUTTypeMovie])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误"
                                                        message:@"不支持加载视频，请重新选择"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)shootPicture:(UIButton *)sender
{
    //加载来自相机的文件
    [self pickMediaFromSource:UIImagePickerControllerSourceTypeCamera];

}

- (IBAction)selectExistingPicture:(UIButton *)sender
{
    //加载来自媒体库的文件
    [self pickMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];

}

- (void)pickMediaFromSource:(UIImagePickerControllerSourceType)sourceType
{
    //根据传入的sourceType来确定加载什么库
    NSArray *mediaTypes = [UIImagePickerController
                           availableMediaTypesForSourceType:sourceType];
    if ([UIImagePickerController isSourceTypeAvailable:sourceType] && [mediaTypes count] > 0)
    {
        NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.mediaTypes = mediaTypes;
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:NULL];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误"
                                                        message:@"木有照相机的说"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}


- (UIImage *)shrinkImage:(UIImage *)original toSize:(CGSize)size        //缩小图片
{
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    [original drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *final = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return final;
}

#pragma mark - Image Picker Controller delegate methods
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
   chosenMediaType = info[UIImagePickerControllerMediaType];
    if ([chosenMediaType isEqual:(NSString *)kUTTypeImage])
    {
        UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
//        UIImage *shrunkenImage = [self shrinkImage:chosenImage
//                                            toSize:self.imageView.bounds.size];
        self.image = chosenImage;
    }
    else if ([chosenMediaType isEqual:(NSString *)kUTTypeMovie])
    {
//        self.movieURL = info[UIImagePickerControllerMediaURL];
        NSLog(@"我是视频");
    }
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
- (IBAction)resetButtonPressed:(UIButton *)sender
{
    
}

- (IBAction)uploadButtonPressed:(UIButton *)sender
{
    if(self.nameField.text.length && self.priceField.text.length && self.addressField.text.length)
    {
        BINUploadModel * upload = [[BINUploadModel alloc] init];
        upload.upLoadUser = @"bin";
        upload.name = self.nameField.text;
        upload.price = self.priceField.text;
        upload.address = self.addressField.text;
        upload.description = @"无";
        upload.upLoadImage = self.image;
        [upload uploadPic];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误"
                                                        message:@"请完善信息"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)backgroundTap:(UIControl *)sender
{
    [self.nameField resignFirstResponder];
    [self.priceField resignFirstResponder];
    [self.addressField resignFirstResponder];
    [self.descriptionField resignFirstResponder];
    [self resumeView];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //上移30个单位，按实际情况设置
    CGRect rect=CGRectMake(0.0f,-210,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
    return YES;
}

-(void)resumeView       //界面移动还原
{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //如果当前View是父视图，则Y为0，如果当前View为其他View的子视图，则动态调节Y的高度
    float Y = 0.0f;
    CGRect rect=CGRectMake(0.0f,Y,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
}


@end
