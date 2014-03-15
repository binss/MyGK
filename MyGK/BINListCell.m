//
//  BINListCell.m
//  MyGK
//
//  Created by bin on 14-2-25.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import "BINListCell.h"
#import "UIImageView+AFNetworking.h"
#import "BINUserModel.h"

@implementation BINListCell
@synthesize cellID;
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
    NSLog(@"%@",cellID);
    if([[BINUserModel sharedUserData] loginState])
    {
        if(self.heartButton.selected)
        {
            [self.heartButton setSelected:NO];
            [[[BINUserModel sharedUserData] favList] removeObject:cellID];
            NSLog(@"%@",[[BINUserModel sharedUserData] favList]);
        }
        else
        {
            [self.heartButton setSelected:YES];
            [[[BINUserModel sharedUserData] favList] addObject:cellID];
            NSLog(@"%@",[[BINUserModel sharedUserData] favList]);

        }
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请先登录"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
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
