//
//  BINDynamicModel.m
//  MyGK
//
//  Created by bin on 14-3-5.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import "BINDynamicModel.h"
#import "ServerAddressSetting.h"

static BINDynamicModel *_userDynamic= nil;


@implementation BINDynamicModel
@synthesize manager;
@synthesize loadedRows;
@synthesize list;



+ (BINDynamicModel*) userDynamic
{
    @synchronized (self)
    {
        if (_userDynamic == nil)
        {
            _userDynamic = [[self alloc] init];
        }
    }
    return _userDynamic;
}

+ (id) allocWithZone:(NSZone *)zone
{
    @synchronized (self) {
        if (_userDynamic == nil) {
            _userDynamic = [super allocWithZone:zone];
            return _userDynamic;
        }
    }
    return nil;
}

- (id) copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)init
{
    @synchronized(self)
    {
        self = [super init];
        if (self != nil)
        {
            manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
            loadedRows = 0;
            list = [[NSMutableArray alloc] initWithCapacity:24];
            
        }
        return self;
    }
}

- (void)getDynamicFromServer
{
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:@"dynamic",@"dynamic",@"0",@"row",nil];
    [manager GET:userDynamicServerAddress parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if(loadedRows)
         {
             [list removeAllObjects];
         }
         [list addObjectsFromArray:[responseObject objectForKey:@"Data"]];
         
         [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadUserDynamic" object:@"refresh"];
         loadedRows = 6;
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
     }];
}

- (void)getMoreDynamicFromServer
{
    NSString *row = [NSString stringWithFormat:@"%i",loadedRows];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:@"dynamic",@"dynamic",row,@"row",nil];
    [manager GET:userDynamicServerAddress parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //            NSLog(@"JSON: %@", responseObject);
         [list addObjectsFromArray:[responseObject objectForKey:@"Data"]];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadUserDynamic" object:@"loadmore"];
         loadedRows = loadedRows + 6;
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
     }];
}
@end
