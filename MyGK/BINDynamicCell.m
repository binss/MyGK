//
//  BINDynamicCell.m
//  MyGK
//
//  Created by bin on 14-3-5.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import "BINDynamicCell.h"
#import "UIImageView+AFNetworking.h"
#import "ServerAddressSetting.h"
@implementation BINDynamicCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (IBAction)nameButtonPressed:(UIButton *)sender
{
    NSLog(@"callll");
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    self.content.contentMode = UIViewContentModeTop;
    self.imageView.frame = CGRectMake(11.0f, 10.0f, 60.0f, 60.0f);
//    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickPicture)];
//    [self.picture addGestureRecognizer:singleTap];
    
}


- (void)setIconView:(NSString *)str
{
    NSString *urlstr = [NSString stringWithFormat:@"%@%@.png",iconServerAddress,str];

    NSURL *url = [NSURL URLWithString:urlstr];
    [self.icon setImageWithURL:url placeholderImage:[UIImage imageNamed:@"profile-image-placeholder"]];
}

- (void)setPictureView:(NSString *)str
{
    NSString *urlstr = [pictureServerAddress_small stringByAppendingString:str];
    NSURL *url = [NSURL URLWithString:urlstr];
    [self.picture setImageWithURL:url placeholderImage:[UIImage imageNamed:@"profile-image-placeholder"]];
}

@end
