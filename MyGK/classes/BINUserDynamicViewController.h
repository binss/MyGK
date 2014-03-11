//
//  BINUserDynamicViewController.h
//  MyGK
//
//  Created by bin on 14-3-5.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BINZoomImageView.h"

@interface BINUserDynamicViewController : UITableViewController<BINZoomImageDelegate>
@property CGFloat lastScale;
@end
