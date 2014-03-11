//
//  BINZoomScrollView.m
//  MyGK
//
//  Created by bin on 14-3-8.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import "BINZoomScrollView.h"

#define ScreenWidth      CGRectGetWidth([UIScreen mainScreen].applicationFrame)
#define ScreenHeight     CGRectGetHeight([UIScreen mainScreen].applicationFrame)

@interface BINZoomScrollView (Utility)

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center;

@end

@implementation BINZoomScrollView

@synthesize imageView;
@synthesize activityIndicatorView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.delegate = self;
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        [self initImageView];
        
        
    }
    return self;
}

- (void)initImageView
{
    activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((ScreenWidth-30)/2,(ScreenHeight-30)/2,30.0,30.0)];
    activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [self addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
    
    
    imageView = [[UIImageView alloc] init];
    
    
    [self setMinimumZoomScale:1];
    [self setZoomScale:1];

    imageView.userInteractionEnabled = YES;
    [self addSubview:imageView];

    
     
//    imageView = [[UIImageView alloc] init];
//    
//    //设置最大只能放大到2.5倍
//    imageView.frame = CGRectMake(0, 0, ScreenWidth * 2.5, ScreenHeight * 2.5);
//    imageView.userInteractionEnabled = YES;
//    [self addSubview:imageView];
//    
//    
//    float minimumScale = self.frame.size.width / imageView.frame.size.width;
//    NSLog(@"%f",imageView.frame.size.width);
//    [self setMinimumZoomScale:minimumScale];
//    [self setZoomScale:minimumScale];
}

- (void)getLargeImage:(NSString *)url;
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if([data length] > 0 && error==nil)
         {
             NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             
             NSRange range = [result rangeOfString:@"404 Not Found"];
             
             //移除正在加载的菊花
             [activityIndicatorView stopAnimating];
             [activityIndicatorView removeFromSuperview];
             
             if(range.location != 0)
             {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误"
                                                                 message:@"图片下载失败,请检查网络"
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil];
                 [alert show];
             }
             else   //如果下载图片成功
             {

                 UIImage *image = [UIImage imageWithData:data];
                 float width = image.size.width;
                 float height = image.size.height;
                 float widthRatio = width / ScreenWidth;
                 float heightRatio = height / ScreenHeight;
                 if(widthRatio > 1 && heightRatio > 1)
                 {
                     float maxRatio = (widthRatio > heightRatio)?widthRatio:heightRatio;
                     float newHeight = height / maxRatio;
                     float newWidth = width / maxRatio;
                     imageView.frame = CGRectMake((ScreenWidth - newWidth)/2, (ScreenHeight - newHeight)/2, newWidth, newHeight);
                     [self setMaximumZoomScale:maxRatio];
                 }
                 else if(widthRatio > 1 && heightRatio < 1)
                 {
                     float newHeight = height / widthRatio;
                     imageView.frame = CGRectMake(0, (ScreenHeight - newHeight)/2, ScreenWidth, newHeight);
                     [self setMaximumZoomScale:widthRatio];
                 }
                 else if(widthRatio < 1 && heightRatio > 1)
                 {
                     float newWidth = width / heightRatio;
                     imageView.frame = CGRectMake((ScreenWidth - newWidth)/2, 0, newWidth, ScreenHeight);
                     [self setMaximumZoomScale:heightRatio];
                 }
                 else
                 {
                     imageView.frame = CGRectMake((ScreenWidth - width)/2, (ScreenHeight - height)/2, width, height);
                     //禁止缩放
                     [self setMaximumZoomScale:1];
                 }
                 [self.imageView setImage:image];
             }

         }
     }];

}




- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height = self.frame.size.height / scale;
    zoomRect.size.width  = self.frame.size.width  / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    return zoomRect;
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView;
}

//- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
//{
//    [scrollView setZoomScale:scale animated:NO];
//    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
//    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
//    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
//    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
//    imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
//                            scrollView.contentSize.height * 0.5 + offsetY);
//}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                            scrollView.contentSize.height * 0.5 + offsetY);
}


@end
