//
//  BINDynamicCell.m
//  MyGK
//
//  Created by bin on 14-3-5.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import "BINDynamicCell.h"
#import "UIImageView+AFNetworking.h"

@implementation BINDynamicCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setImage:(NSString *)str
{
    NSURL *url = [NSURL URLWithString:str];
    [self.icon setImageWithURL:url placeholderImage:[UIImage imageNamed:@"profile-image-placeholder"]];
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

-(void)onClickPicture
{
    
    NSLog(@"图片被点击!");
}



@end
