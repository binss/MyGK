//
//  BINGKlistModel.h
//  MyGK
//
//  Created by bin on 14-2-27.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface BINGKlistModel : NSObject
@property (strong,nonatomic) NSMutableArray *list;
@property int loadedRows;
@property int selectedRow;
@property BOOL isSearch;
@property (strong,nonatomic) NSString *selectedDescription;
@property (strong,nonatomic) NSString *selectedName;
@property (strong,nonatomic) NSString *selectedPrice;
@property (strong,nonatomic) NSString *selectedDiscount;
@property (strong,nonatomic) NSString *selectedPicURL;

@property int loadedSearchRows;
@property int totalSearchRows;

@property (strong,nonatomic) NSMutableArray *searchList;
@property (strong,nonatomic) AFHTTPRequestOperationManager *manager;

+ (BINGKlistModel*) GKlist;

- (void)getDataFromServer;
- (void)getDetailFromServer;
- (void)generalData;
- (void)getMoreDataFromServer;
- (void)getSearchResultFromServer:(NSString *)searchString;
- (void)getMoreSearchResultFromServer:(NSString *)searchString;

@end
