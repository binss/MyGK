//
//  BINListCell.m
//  MyGK
//
//  Created by bin on 14-2-25.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import "BINListCell.h"
#import "UIImageView+AFNetworking.h"

@implementation BINListCell

//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        // Initialization code
//    }
//
//    return self;
//}

//-(id)init
//{
//    self = [super init];
//    self.nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    NSLog(@"call");
//    return self;
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
//    [super setSelected:selected animated:animated];
    // Configure the view for the selected state

}

- (IBAction)heartButtonPressed:(UIButton *)sender
{
    NSLog(@"aa");
    if(self.heartButton.selected)
        [self.heartButton setSelected:NO];
    else
        [self.heartButton setSelected:YES];
}

- (void)setImage:(NSString *)str
{
    NSURL *url = [NSURL URLWithString:str];
    [self.imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"profile-image-placeholder"]];

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(10.0f, 4.0f, 65.0f, 65.0f);
    
}

@end
