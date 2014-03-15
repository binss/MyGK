//
//  BINUserModel.m
//  MyGK
//
//  Created by bin on 14-2-23.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import "BINUserModel.h"
static BINUserModel *_sharedUserData= nil;   //第一步：静态实例，并初始化

@implementation BINUserModel
@synthesize loginState;
@synthesize level;
@synthesize user;
@synthesize name;
@synthesize favList;
@synthesize icon;


+ (BINUserModel*) sharedUserData  //第二步：实例构造检查静态实例是否为nil
{
    @synchronized (self)   //@synchronized 的作用是创建一个互斥锁，保证此时没有其它线程对self对象进行修改
    {
        if (_sharedUserData == nil)
        {
            _sharedUserData = [[self alloc] init];
        }
    }
    return _sharedUserData;
}

+ (id) allocWithZone:(NSZone *)zone //第三步：重写allocWithZone方法
{
    @synchronized (self) {
        if (_sharedUserData == nil) {
            _sharedUserData = [super allocWithZone:zone];
            return _sharedUserData;
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
            loginState = NO;
            icon = [UIImage imageNamed:@"profile-image-placeholder"];
            favList = [NSMutableArray array];
        }
        return self;
    }
}

@end
