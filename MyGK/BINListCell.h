//
//  BINListCell.h
//  MyGK
//
//  Created by bin on 14-2-25.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BINListCell : UITableViewCell

@property NSNumber *cellID;
//@property (copy,nonatomic) NSString *name;
//@property int price;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)heartButtonPressed:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *heartButton;

- (void)setImage:(NSString *)str;
@end
