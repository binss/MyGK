//
//  BINNendoroidDetailViewController.h
//  MyGK
//
//  Created by bin on 14-3-19.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BINNendoroidDetailViewController : UIViewController <UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (strong,nonatomic) UIPageControl *pageControl;

@property bool pageControlScrolling;
@property int currentImageX;
@end
