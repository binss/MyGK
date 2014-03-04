//
//  BINMyGKViewController.m
//  MyGK
//
//  Created by bin on 14-2-23.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import "BINMyGKViewController.h"
#import "BINUserModel.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
@interface BINMyGKViewController ()

@end

@implementation BINMyGKViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self checkLoginState];
    self.tabBarController.hidesBottomBarWhenPushed = YES;

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)checkLoginState
{
    if ([[BINUserModel sharedUserData] loginState])
    {
//        NSLog(@"login successful");
        
        self.IconButton.enabled = YES;
        [self.IconButton setImage:[[BINUserModel sharedUserData] icon] forState:UIControlStateNormal];
        self.loginButton.hidden = YES;
        self.signupButton.hidden = YES;
        self.signoutButton.hidden = NO;
        self.levelLabel.hidden = NO;
        self.levelLabel.text = [[NSString alloc] initWithFormat:@"Lv %d",[[BINUserModel sharedUserData] level]];
        self.nameLabel.text = [[BINUserModel sharedUserData] name];
    }
}
- (IBAction)signoutButtonPressed:(UIButton *)sender
{
    [[BINUserModel sharedUserData] setLoginState:NO];
    
    self.IconButton.enabled = NO;
    self.loginButton.hidden = NO;
    self.signupButton.hidden = NO;
    self.signoutButton.hidden = YES;
    self.levelLabel.hidden = YES;
    self.nameLabel.text = @"未登录";
}



- (IBAction)uploadPIC:(id)sender
{
//    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1:8000/pic/UserUploadPic/kankore-bath-shimakaze.png/"];
//    [self.picccccc setImageWithURL:url placeholderImage:[UIImage imageNamed:@"profile-image-placeholder"]];
    
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //隐藏toolbar
    [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
//    self.navigationItem.backBarButtonItem= [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:nil];
}

- (void)upLoadPic
{
    //分界线的标识符
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    //根据url初始化request

    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //要上传的图片
    UIImage *image=[UIImage imageNamed:@"IMG_4823.JPG"];

    
    NSData *data = UIImageJPEGRepresentation(image,0.75);
    //http body的字符串
    NSMutableString *body = [[NSMutableString alloc] init];
    //参数的集合的所有key的集合

    
    //-----------按分界线，字段名，字段值来添加POST中的字段
    //添加分界线，换行
    [body appendFormat:@"%@\r\n",MPboundary];
            //添加字段名称，换2行
    [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",@"dodo"];
            //添加字段的值
    [body appendFormat:@"%@\r\n",@"haha"];
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
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://127.0.0.1:8000/hello/"]
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
    
    //设置接受response的data
    if (conn)
    {
        NSString *result = [[NSString alloc] initWithData:conn encoding:NSUTF8StringEncoding];
        NSLog(@"%@",result);
    }
    
 
}

@end
