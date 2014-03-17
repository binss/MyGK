//
//  BINUserDynamicViewController.m
//  MyGK
//
//  Created by bin on 14-3-5.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import "BINUserDynamicViewController.h"
#import "BINDynamicCell.h"
#import "BINDynamicModel.h"
#import "MJRefresh.h"
#import "BINZoomScrollView.h"
#import "ServerAddressSetting.h"

static NSString *CellTableIdentifier = @"CellTableIdentifier";


@interface BINUserDynamicViewController () <MJRefreshBaseViewDelegate>
@property MJRefreshHeaderView *header;
@property MJRefreshFooterView *footer;
@end

@implementation BINUserDynamicViewController
@synthesize header;
@synthesize footer;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITableView *tableView = (id)[self.view viewWithTag:2];
    tableView.rowHeight = 230;
    UINib *nib = [UINib nibWithNibName:@"BINDynamicCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:CellTableIdentifier];
    
    [self addHeader];
    [self addFooter];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(reload:) name:@"reloadUserDynamic" object:nil];
    
    
    [[BINDynamicModel userDynamic] getDynamicFromServer];

    
}

- (void)reload:(NSNotification *) notification
{
    // 刷新表格
    NSString *type = [notification object];
    if([type isEqualToString:@"refresh"])
    {
        [self.tableView reloadData];
        [header endRefreshing];        // 调用endRefreshing结束刷新状态
    }
    else
    {
        [self.tableView reloadData];
        [footer endRefreshing];
    }

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:@"reloadUserDynamic"];
    [header removeFromSuperview];
    [footer removeFromSuperview];
}

- (void)addHeader
{
    header = [[MJRefreshHeaderView alloc] init];
    header.delegate = self;
    header.scrollView = self.tableView;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView)
    {
        // 进入刷新状态就会回调这个Block
        [[BINDynamicModel userDynamic] getDynamicFromServer];
    };

    [header beginRefreshing];
}

- (void)addFooter
{
    footer = [[MJRefreshFooterView alloc] init];
    footer.delegate = self;
    footer.scrollView = self.tableView;
    //下拉的时候加载多8行
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView)
    {
        [[BINDynamicModel userDynamic] getMoreDynamicFromServer];
    };
    
}



#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[BINDynamicModel userDynamic].list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    
    BINDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickPicture:)];
    [cell.picture addGestureRecognizer:singleTap];
    UIView *singleTapView = [singleTap view];
    singleTapView.tag = row;
    
    NSDictionary *record = [BINDynamicModel userDynamic].list[row];

    [cell.name setTitle:[record objectForKey:@"name"] forState:UIControlStateNormal];
    cell.content.text = [record objectForKey:@"content"];
    cell.time.text = [record objectForKey:@"time"];
    [cell setIconView:[record objectForKey:@"username"]];
    [cell setPictureView:[record objectForKey:@"picFileName"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%d",indexPath.row);
}


-(void)onClickPicture:(id)sender
{
    UITapGestureRecognizer *singleTap = (UITapGestureRecognizer *)sender;

    
    [self.navigationController setNavigationBarHidden:YES];

    BINZoomImageView *imageView = [[BINZoomImageView alloc] init];
    imageView.delegate = self;

    NSDictionary *record = [BINDynamicModel userDynamic].list[[singleTap view].tag];
    NSString *urlstr = [pictureServerAddress_large stringByAppendingString:[record objectForKey:@"picFileName"]];

    [imageView setImage:urlstr];
    [self.view.superview addSubview:imageView];
    
    
}



-(void)removeViewCallback       //BINZoomImageView移除后执行的动作
{
    //恢复导航条
    [self.navigationController setNavigationBarHidden:NO];
}



@end
