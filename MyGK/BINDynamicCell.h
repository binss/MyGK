//
//  BINDynamicCell.h
//  MyGK
//
//  Created by bin on 14-3-5.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BINDynamicCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *name;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIImageView *picture;

- (void)setIconView:(NSString *)str;
- (void)setPictureView:(NSString *)str;

- (IBAction)nameButtonPressed:(UIButton *)sender;
@end
