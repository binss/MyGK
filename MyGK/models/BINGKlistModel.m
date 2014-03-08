//
//  BINGKlistModel.m
//  MyGK
//
//  Created by bin on 14-2-27.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import "BINGKlistModel.h"
#import "ServerAddressSetting.h"
static BINGKlistModel *_GKlist= nil;


@implementation BINGKlistModel
@synthesize manager;
@synthesize list;
@synthesize loadedRows;
@synthesize selectedRow;
@synthesize selectedDescription;
@synthesize selectedName;
@synthesize selectedPrice;
@synthesize selectedDiscount;
@synthesize selectedPicURL;
@synthesize searchList;
@synthesize loadedSearchRows;
@synthesize totalSearchRows;
@synthesize isSearch;

+ (BINGKlistModel*) GKlist
{
    @synchronized (self)   //@synchronized 的作用是创建一个互斥锁，保证此时没有其它线程对self对象进行修改
    {
        if (_GKlist == nil)
        {
            _GKlist = [[self alloc] init];
        }
    }
    return _GKlist;
}

+ (id) allocWithZone:(NSZone *)zone
{
    @synchronized (self) {
        if (_GKlist == nil) {
            _GKlist = [super allocWithZone:zone];
            return _GKlist;
        }
    }
    return nil;
}

- (id) copyWithZone:(NSZone *)zone //第四步
{
    return self;
}

- (id)init
{
    @synchronized(self)
    {
        self = [super init];//往往放一些要初始化的变量.
        if (self != nil)
        {
            manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
            loadedRows = 0;
            loadedSearchRows = 0;
            totalSearchRows = 0;
            isSearch = NO;
            searchList = [[NSMutableArray alloc] initWithCapacity:24];
            list = [[NSMutableArray alloc] initWithCapacity:24];
            
        }
        return self;
    }
}


- (void)getDataFromServer
{
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:@"list",@"list",@"0",@"row",nil];
    [manager GET:gklistServerAddress parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if(loadedRows)
         {
             [list removeAllObjects];
         }
         [list addObjectsFromArray:[responseObject objectForKey:@"Data"]];
         
         [[NSNotificationCenter defaultCenter] postNotificationName:@"reload" object:@"refresh"];
         loadedRows = 8;
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
     }];
}

- (void)getMoreDataFromServer
{
    NSString *row = [NSString stringWithFormat:@"%i",loadedRows];

    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:@"list",@"list",row,@"row",nil];
    [manager GET:gklistServerAddress parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //            NSLog(@"JSON: %@", responseObject);
         [list addObjectsFromArray:[responseObject objectForKey:@"Data"]];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"reload" object:@"loadmore"];
         loadedRows = loadedRows + 8;
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
     }];

}

- (void)getSearchResultFromServer:(NSString *)searchString
{
    [searchList removeAllObjects];

    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:@"search",@"search",searchString,@"searchString",@"0",@"row",nil];
    [manager GET:gklistServerAddress parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSNumber *num = [responseObject objectForKey:@"totalRow"];
         totalSearchRows = num.intValue;
         NSLog(@"total:%i",totalSearchRows);
         
         [searchList addObjectsFromArray:[responseObject objectForKey:@"result"]];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"reload" object:@"search"];

         loadedSearchRows = 8;
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
     }];
}

- (void)getMoreSearchResultFromServer:(NSString *)searchString
{
    if(totalSearchRows > loadedSearchRows)
    {
        NSString *row = [NSString stringWithFormat:@"%i",loadedSearchRows];
        NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:@"search",@"search",searchString,@"searchString",row,@"row",nil];
        [manager GET:gklistServerAddress parameters:parameters
             success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSArray *array = [responseObject objectForKey:@"result"];
             [searchList addObjectsFromArray:array];
             
             loadedSearchRows = loadedSearchRows + [array count];
             
             [[NSNotificationCenter defaultCenter] postNotificationName:@"reload" object:@"searchmore"];
             NSLog(@"load:%d/total:%d",loadedSearchRows,totalSearchRows);

         }
             failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             NSLog(@"Error: %@", error);
         }];
    }
    
}

- (void)getDetailFromServer
{
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *record;

    if(isSearch)
        record = [BINGKlistModel GKlist].searchList[selectedRow];
    else
        record = [BINGKlistModel GKlist].list[selectedRow];
    
    NSString *row = [NSString stringWithFormat:@"%@",[record objectForKey:@"id"]];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:@"detail",@"detail",row,@"row",nil];
    [manager GET:gklistServerAddress parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         _GKlist.selectedDescription = [responseObject objectForKey:@"description"];
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
     }];
}


- (void)generalData
{
    NSDictionary *record;
    if(isSearch)
        record = [BINGKlistModel GKlist].searchList[selectedRow];
    else
        record = [BINGKlistModel GKlist].list[selectedRow];

    selectedName = [record objectForKey:@"name"];
    selectedPrice = [record objectForKey:@"price"];
    selectedDiscount = [record objectForKey:@"discount"];
    selectedPicURL = [record objectForKey:@"picurl"];
}

- (void)setFavoriteGK
{
    
}

@end
