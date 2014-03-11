//
//  BINZoomImageView.h
//  MyGK
//
//  Created by bin on 14-3-8.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BINZoomImageDelegate <NSObject>
- (void)removeViewCallback;
@end


@interface BINZoomImageView : UIView
{
    id <BINZoomImageDelegate> delegate;

}
@property (strong,nonatomic) NSString *imageURL;
@property (nonatomic, retain) id <BINZoomImageDelegate> delegate;

- (void)setImage:(NSString *)str;
@end
