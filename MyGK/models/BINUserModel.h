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
@property NSString *name;
@property int level;
@property (copy,nonatomic) NSArray *favList;
+ (BINUserModel*) sharedUserData;
@end
