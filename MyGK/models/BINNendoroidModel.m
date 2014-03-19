//
//  BINNendoroidModel.m
//  MyGK
//
//  Created by bin on 14-3-18.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import "BINNendoroidModel.h"
static BINNendoroidModel *_sharedNendoroid= nil;

@implementation BINNendoroidModel
@synthesize database;
@synthesize nendoroidList;
@synthesize workName;
@synthesize price;
@synthesize time;
@synthesize description;
@synthesize imageNum;
@synthesize selectedNendoroid;

+ (BINNendoroidModel*) sharedNendoroid
{
    @synchronized (self)   //@synchronized 的作用是创建一个互斥锁，保证此时没有其它线程对self对象进行修改
    {
        if (_sharedNendoroid == nil)
        {
            _sharedNendoroid = [[self alloc] init];
        }
    }
    return _sharedNendoroid;
}

+ (id) allocWithZone:(NSZone *)zone
{
    @synchronized (self) {
        if (_sharedNendoroid == nil) {
            _sharedNendoroid = [super allocWithZone:zone];
            return _sharedNendoroid;
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
            //初始化
            nendoroidList = [NSMutableArray array];

            NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"MyGKDataBase" ofType:@"db"];
            
            //由于SQLite3是采用可移植的C，因此需要将NSString字符串类型转换成C字符串
            const char *charPath = [dbPath UTF8String];
            //
            
            //打开数据库，如果等于SQLITE_OK，则表示数据库已成功打开
            int result = sqlite3_open(charPath, &database);
            if(result == SQLITE_OK)
            {
                NSLog(@"数据库打开成功");
            }
            else
            {
                NSLog(@"数据库打开失败");
            }
            
        }
        return self;
    }
}

- (void)addNendoroidRecord
{
    NSString *querySQL = [NSString stringWithFormat:@"select * from Nendoroid WHERE id > %i and id <= %i",
                          [nendoroidList count],[nendoroidList count] + 16];
    sqlite3_stmt *statement;
    //执行查询
    int result2 = sqlite3_prepare(database, [querySQL UTF8String], -1, &statement, nil);
    
    if (result2 == SQLITE_OK)
    {
        //如果查询有语句就执行step来添加数据
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            char * itemNum_char = (char *)sqlite3_column_text(statement, 1);
            NSString *itemNum = [NSString stringWithUTF8String:itemNum_char];
            char * productName_char = (char *)sqlite3_column_text(statement, 2);
            NSString *productName = [NSString stringWithUTF8String:productName_char];
            NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:itemNum,@"itemNum",productName,@"productName", nil];
            [nendoroidList addObject:dict];
        }
        sqlite3_finalize(statement);
    }
}

- (void)getNendoroidDetail:(NSString *)itemNum
{
    NSString *querySQL = [NSString stringWithFormat:@"select * from Nendoroid WHERE itemNum = '%@'",
                          itemNum];
    selectedNendoroid = itemNum;
    
//    NSString *querySQL = @"select * from Nendoroid WHERE itemNum = '403'";
    sqlite3_stmt *statement;
    //执行查询
    int result = sqlite3_prepare(database, [querySQL UTF8String], -1, &statement, nil);

    if (result == SQLITE_OK)
    {

        //如果查询有语句就执行step来添加数据
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            char * workName_char = (char *)sqlite3_column_text(statement, 3);
            workName = [NSString stringWithUTF8String:workName_char];
            char * price_char = (char *)sqlite3_column_text(statement, 4);
            price = [NSString stringWithUTF8String:price_char];
            char * time_char = (char *)sqlite3_column_text(statement, 5);
            time = [NSString stringWithUTF8String:time_char];
            imageNum = sqlite3_column_int(statement, 6);
            char * description_char = (char *)sqlite3_column_text(statement, 8);
            description = [NSString stringWithUTF8String:description_char];
        }
        sqlite3_finalize(statement);
    }
}

@end
