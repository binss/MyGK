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
@property (strong,nonatomic) NSString * selected_itemNum;
@property int imageNum;
@property (strong,nonatomic) NSString * selected_productName;
@property (strong,nonatomic) NSString * selected_workName;
@property (strong,nonatomic) NSString * selected_price;
@property (strong,nonatomic) NSString * selected_time;
@property (strong,nonatomic) NSString * selected_description;

- (void)addNendoroidRecord;
- (void)getNendoroidDetail:(NSString *)itemNum;
- (void)checkItemNum:(NSString *)itemNum;
@end
