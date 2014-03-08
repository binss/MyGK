//
//  BINDynamicModel.h
//  MyGK
//
//  Created by bin on 14-3-5.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface BINDynamicModel : NSObject
@property (strong,nonatomic) NSMutableArray *list;
@property int loadedRows;

@property (strong,nonatomic) AFHTTPRequestOperationManager *manager;
+ (BINDynamicModel*) userDynamic;
- (void)getDynamicFromServer;
- (void)getMoreDynamicFromServer;

@end
