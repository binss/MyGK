//
//  BINGKlistModel.h
//  MyGK
//
//  Created by bin on 14-2-27.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BINGKlistModel : NSObject
@property (strong,nonatomic) NSMutableArray *list;
@property int loadedRows;
@property (strong,nonatomic) NSString *serverAddress;
@property int selectedRow;
@property (strong,nonatomic) NSString *selectedDescription;
@property (strong,nonatomic) NSString *selectedName;
@property (strong,nonatomic) NSString *selectedPrice;
@property (strong,nonatomic) NSString *selectedDiscount;
@property (strong,nonatomic) NSString *selectedPicURL;

@property (strong,nonatomic) NSMutableArray *searchList;
@property BOOL refresh;

- (void)getDataFromServer;
- (void)getDetailFromServer;
- (void)generalData;
- (void)getMoreDataFromServer;
+ (BINGKlistModel*) GKlist;

@end
