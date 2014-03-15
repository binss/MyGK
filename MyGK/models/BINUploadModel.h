//
//  BINUploadModel.h
//  MyGK
//
//  Created by bin on 14-3-3.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BINUploadModel : NSObject
@property (strong,nonatomic) UIImage *upLoadImage;
@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *price;
@property (strong,nonatomic) NSString *description;

- (void)uploadPic;
- (void)uploadIcon;
- (void)uploadUserData;

@end
