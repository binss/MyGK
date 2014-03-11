//
//  BINZoomImageView.m
//  MyGK
//
//  Created by bin on 14-3-8.
//  Copyright (c) 2014年 bin. All rights reserved.
//
//为了实现图片缩放效果，使用两层ScrollView嵌套的方法。添加三个图层

#import "BINZoomImageView.h"
#import "BINZoomScrollView.h"
#import "UIImageView+AFNetworking.h"

@interface BINZoomImageView ()

@property BINZoomScrollView * zoomScrollView;
@end

@implementation BINZoomImageView
@synthesize zoomScrollView;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    //图层1:往当前view的superview中添加黑色的背景层（遮住当前视图）
    self = [super initWithFrame:CGRectMake(0, 0, 320, 480)];
    if (self)
    {
        //设置图层1的背景为黑色
        [self setBackgroundColor:[UIColor colorWithRed:0
                                                   green:0
                                                    blue:0
                                                   alpha:1.0]];
        
        //图层2:加入外层scrollview,用于放大图片后的上下左右滚动
        UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
//        scrollView.delegate = self;
        scrollView.pagingEnabled = YES;
        scrollView.userInteractionEnabled = YES;
        //隐藏滚动导航条
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        //作为图层1的subview
        [self addSubview:scrollView];
        
        //图层3:内层scrollview,由BINZoomScrollView实现,用于图片的滚动
        zoomScrollView = [[BINZoomScrollView alloc] init];
        CGRect frame = scrollView.frame;
        frame.origin.x = 0;
        frame.origin.y = 0;
        zoomScrollView.frame = frame;
        
        [scrollView addSubview:zoomScrollView];
        
        UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(handleSingleTap:)];
        [singleTapGesture setNumberOfTapsRequired:1];
        [zoomScrollView addGestureRecognizer:singleTapGesture];
        
        
        UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(handleDoubleTap:)];
        [doubleTapGesture setNumberOfTapsRequired:2];
        [zoomScrollView.imageView addGestureRecognizer:doubleTapGesture];
        
        [singleTapGesture requireGestureRecognizerToFail:doubleTapGesture];
        

    }
    return self;
}

- (void)handleSingleTap:(UIGestureRecognizer *)gesture      //处理单击事件
{
    [delegate removeViewCallback];
    
    [self removeFromSuperview];
}


- (void)handleDoubleTap:(UIGestureRecognizer *)gesture      //处理双击事件
{
    float newScale = zoomScrollView.zoomScale * 1.5;
    CGRect zoomRect = [zoomScrollView zoomRectForScale:newScale withCenter:[gesture locationInView:gesture.view]];
    [zoomScrollView zoomToRect:zoomRect animated:YES];
    
}

- (void)setImage:(NSString *)str
{
//    NSURL *url = [NSURL URLWithString:str];
//    [zoomScrollView.imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"profile-image-placeholder"]];
    [zoomScrollView getLargeImage:str];
}













@end
