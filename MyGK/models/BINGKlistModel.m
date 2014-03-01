//
//  BINGKlistModel.m
//  MyGK
//
//  Created by bin on 14-2-27.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import "BINGKlistModel.h"
#import "AFNetworking.h"
static BINGKlistModel *_GKlist= nil;


@implementation BINGKlistModel
@synthesize list;
@synthesize loadedRows;
@synthesize serverAddress;
@synthesize selectedRow;
@synthesize selectedDescription;
@synthesize selectedName;
@synthesize selectedPrice;
@synthesize selectedDiscount;
@synthesize selectedPicURL;
@synthesize refresh;

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
            loadedRows = 0;
            refresh = NO;
            list = [[NSMutableArray alloc] initWithCapacity:24];
            
        }
        return self;
    }
}


- (void)getDataFromServer
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:@"client",@"client",@"0",@"row",nil];
    [manager GET:serverAddress parameters:parameters
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
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *row = [NSString stringWithFormat:@"%i",loadedRows];

    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:@"client",@"client",row,@"row",nil];
    [manager GET:serverAddress parameters:parameters
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

- (void)getSearchResultFromServer
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *row = [NSString stringWithFormat:@"%i",loadedRows];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:@"client",@"client",row,@"row",nil];
    [manager GET:serverAddress parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //            NSLog(@"JSON: %@", responseObject);
         [list addObjectsFromArray:[responseObject objectForKey:@"Data"]];
         //         NSLog(@"%@", [[datalist objectAtIndex:0] objectForKey:@"name"]);
         //         [self.tableView reloadData];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"reload" object:@"loadmore"];

         loadedRows = loadedRows + 8;
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
     }];

}

- (void)getDetailFromServer
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *row = [NSString stringWithFormat:@"%i",selectedRow];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:@"detail",@"detail",row,@"row",nil];
    [manager GET:serverAddress parameters:parameters
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
    NSDictionary *record = [BINGKlistModel GKlist].list[selectedRow];
    selectedName = [record objectForKey:@"name"];
    selectedPrice = [record objectForKey:@"price"];
    selectedDiscount = [record objectForKey:@"discount"];
    selectedPicURL = [record objectForKey:@"picurl"];
}

- (void)setFavoriteGK
{
    
}

@end
