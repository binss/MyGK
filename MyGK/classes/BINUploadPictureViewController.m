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
@synthesize uploadingAleatView;
@synthesize showImage;
@synthesize image;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(uploadDone:) name:@"uploadDone" object:nil];

}

- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
    self.upLoadButton.enabled = NO;
    if ([self.chosenMediaType isEqual:(NSString *)kUTTypeImage])
    {
        self.imageView.image = showImage;
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

- (void)uploadDone:(NSNotification *) notification
{
    //移除“正在上传”对话框
    [uploadingAleatView dismissWithClickedButtonIndex:0 animated:YES];

    NSString *type = [notification object];
    UIAlertView *alert;
    if([type isEqualToString:@"success"])
    {
        alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"上传成功"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    }
    else
    {
        alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"上传失败"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    }
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex //ALertView即将消失时的事件
{
    [self.navigationController popViewControllerAnimated:YES];
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

- (IBAction)resetButtonPressed:(UIButton *)sender
{
    self.nameField.text = @"";
    self.priceField.text = @"";
    self.descriptionField.text = @"";
    self.imageView.image = [UIImage imageNamed:@"profile-image-placeholder"];
}

- (IBAction)uploadButtonPressed:(UIButton *)sender
{
    if(self.nameField.text.length && self.priceField.text.length)
    {
        uploadingAleatView= [[UIAlertView alloc]initWithTitle:@"正在上传中，请等待"
                                                       message:nil
                                                      delegate:nil
                                             cancelButtonTitle:nil
                                             otherButtonTitles:nil];
        [uploadingAleatView show];
        
        
        BINUploadModel * upload = [[BINUploadModel alloc] init];
//        upload.upLoadUser = @"bin";
//        upload.upLoadName = @"管理员";

        upload.name = self.nameField.text;
        upload.price = self.priceField.text;
        if(self.descriptionField.text.length)
            upload.description = self.descriptionField.text;
        else
            upload.description = [NSString stringWithFormat:@"我分享了手办：%@",self.nameField.text];
        upload.upLoadImage = image;
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
        UIImage *shrunkenImage = [self shrinkImage:chosenImage
                                            toSize:self.imageView.bounds.size];
        image = chosenImage;
        showImage = shrunkenImage;
    }
    else if ([chosenMediaType isEqual:(NSString *)kUTTypeMovie])
    {
        NSLog(@"我是视频");
    }
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark - Background View raise and resume
- (IBAction)backgroundTap:(UIControl *)sender
{
    [self.nameField resignFirstResponder];
    [self.priceField resignFirstResponder];
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
