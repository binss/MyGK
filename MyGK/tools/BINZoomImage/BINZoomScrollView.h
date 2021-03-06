//
//  BINZoomScrollView.h
//  MyGK
//
//  Created by bin on 14-3-8.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BINZoomScrollView : UIScrollView <UIScrollViewDelegate>

@property (strong,nonatomic) UIImageView *imageView;
@property (strong,nonatomic) UIActivityIndicatorView *activityIndicatorView;

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center;
- (void)getLargeImage:(NSString *)url;
@end
