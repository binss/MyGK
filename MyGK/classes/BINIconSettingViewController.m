//
//  BINIconSettingViewController.m
//  MyGK
//
//  Created by bin on 14-3-4.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import "BINIconSettingViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "BINUserModel.h"
#import "BINUploadModel.h"

@interface BINIconSettingViewController ()

@end

@implementation BINIconSettingViewController
@synthesize image;
@synthesize chosenMediaType;
@synthesize uploadingAleatView;

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
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(uploadDone:) name:@"iconUploadDone" object:nil];
    self.imageView.image = [[BINUserModel sharedUserData] icon];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    if([[BINUserModel sharedUserData] icon])
//    {
//        self.saveButton.enabled = YES;
//    }
//    else
//    {
//        self.saveButton.enabled = NO;
//    }
    
    
    self.uploadButton.enabled = NO;
    if ([self.chosenMediaType isEqual:(NSString *)kUTTypeImage])
    {
        self.imageView.image = image;
        self.uploadButton.enabled = YES;
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
        //上传成功后设置头像
        [BINUserModel sharedUserData].icon = image;
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        image = [self shrinkImage:chosenImage
                                            toSize:CGSizeMake(200,200)];
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

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    if(error != NULL)
    {
        msg = @"保存头像失败" ;
    }else
    {
        msg = @"保存头像成功" ;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}


- (IBAction)saveButtonPressed:(UIButton *)sender
{
    //如果有头像的话,保存头像
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
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

- (IBAction)uploadButtonPressed:(UIButton *)sender
{
    uploadingAleatView= [[UIAlertView alloc]initWithTitle:@"正在上传中，请等待"
                                                  message:nil
                                                 delegate:nil
                                        cancelButtonTitle:nil
                                        otherButtonTitles:nil];
    [uploadingAleatView show];


    BINUploadModel * upload = [[BINUploadModel alloc] init];
    upload.upLoadImage = image;
    [upload uploadIcon];

}
@end
