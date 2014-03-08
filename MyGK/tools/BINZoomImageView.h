//
//  BINZoomImageView.h
//  MyGK
//
//  Created by bin on 14-3-8.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface BINZoomImageView : UIView
//@property UIScrollView *scrollView;
@property (strong,nonatomic) NSString *imageURL;
- (void)setImage:(NSString *)str;
@end
