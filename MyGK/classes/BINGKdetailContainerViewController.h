//
//  BINGKdetailContainerViewController.h
//  MyGK
//
//  Created by bin on 14-2-26.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BINGKdetailContainerViewController : UIViewController
@property (strong,nonatomic) NSString * url;
@property (strong,nonatomic) NSString * name;
@property (strong,nonatomic) NSString * description;
@property (strong,nonatomic) NSString * tablename;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextField;

@end
