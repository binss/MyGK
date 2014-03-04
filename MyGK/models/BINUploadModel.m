//
//  BINUploadModel.m
//  MyGK
//
//  Created by bin on 14-3-3.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import "BINUploadModel.h"
#import "AFNetworking.h"
#import "ServerAddressSetting.h"

@implementation BINUploadModel
@synthesize upLoadImage;
@synthesize upLoadUser;
@synthesize name;
@synthesize description;
@synthesize address;
@synthesize price;

- (void)uploadPic
{
    //分界线的标识符
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    //根据url初始化request
    
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    
    NSData *data = UIImageJPEGRepresentation(upLoadImage,0.75);
    //http body的字符串
    NSMutableString *body = [[NSMutableString alloc] init];
    //参数的集合的所有key的集合
    
    
    //-----------按分界线，字段名，字段值来添加POST中的字段
//    //添加分界线，换行
//    [body appendFormat:@"%@\r\n",MPboundary];
//    //添加字段名称，换2行
//    [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",@"user"];
//    //添加字段的值
//    [body appendFormat:@"%@\r\n",upLoadUser];
    
    [body appendFormat:@"%@\r\n",MPboundary];
    [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",@"user"];
    [body appendFormat:@"%@\r\n",upLoadUser];
    
    [body appendFormat:@"%@\r\n",MPboundary];
    [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",@"name"];
    [body appendFormat:@"%@\r\n",name];
    
    [body appendFormat:@"%@\r\n",MPboundary];
    [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",@"price"];
    [body appendFormat:@"%@\r\n",price];
    
    [body appendFormat:@"%@\r\n",MPboundary];
    [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",@"description"];
    [body appendFormat:@"%@\r\n",description];
    
    [body appendFormat:@"%@\r\n",MPboundary];
    [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",@"address"];
    [body appendFormat:@"%@\r\n",address];
    
    //----------字段添加结束
    
    
    //插入图片字段
    [body appendFormat:@"%@\r\n",MPboundary];
    //插入图片，设定图片字段名及图片名
    [body appendFormat:@"Content-Disposition: form-data; name=\"pic\"; filename=\"uploadPic.png\"\r\n"];
    //声明格式
    [body appendFormat:@"Content-Type: image/png\r\n\r\n"];
    
    
    
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData = [NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    //将image的data加入
    [myRequestData appendData:data];
    
    //构造结束符
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //插入结束符到上传的data
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    
    //建立请求
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:userShareServerAddress]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%d", [myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];
    
    //建立连接，设置代理
    
    NSError *error = nil;
    NSData *conn = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    
    //设置接收response的data
    if (conn)
    {
        NSString *result = [[NSString alloc] initWithData:conn encoding:NSUTF8StringEncoding];
        NSLog(@"%@",result);
    }
        
}
@end
