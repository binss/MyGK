//
//  BINNendoroidModel.h
//  MyGK
//
//  Created by bin on 14-3-18.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface BINNendoroidModel : NSObject
+ (BINNendoroidModel*) sharedNendoroid;

@property (strong,nonatomic) NSMutableArray * nendoroidList;

@property sqlite3 *database;
@property (strong,nonatomic) NSString * selectedNendoroid;
@property (strong,nonatomic) NSString * workName;
@property (strong,nonatomic) NSString * price;
@property int imageNum;
@property (strong,nonatomic) NSString * time;
@property (strong,nonatomic) NSString * description;

- (void)addNendoroidRecord;
- (void)getNendoroidDetail:(NSString *)itemNum;
@end
