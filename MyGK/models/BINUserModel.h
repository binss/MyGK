//
//  BINUserModel.h
//  MyGK
//
//  Created by bin on 14-2-23.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BINUserModel : NSObject
@property bool loginState;
@property (strong,nonatomic) NSString *user;
@property (strong,nonatomic) NSString *name;
@property int level;
@property (strong,nonatomic) NSMutableArray *favList;
@property (strong,nonatomic) UIImage *icon;
+ (BINUserModel*) sharedUserData;
@end
