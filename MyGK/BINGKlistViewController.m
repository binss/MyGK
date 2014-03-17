//
//  BINGKlistViewController.m
//  MyGK
//
//  Created by bin on 14-2-25.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import "BINGKlistViewController.h"
#import "BINListCell.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "BINUserModel.h"

@interface BINGKlistViewController () <MJRefreshBaseViewDelegate>
@property MJRefreshHeaderView *header;
@property MJRefreshFooterView *footer;
@property MJRefreshFooterView *searchFooter;
@end

static NSString *CellTableIdentifier = @"CellTableIdentifier";

@implementation BINGKlistViewController
@synthesize selectedRow;
@synthesize GKlist;
@synthesize filteredList;
@synthesize searchDisplayController;
@synthesize SearchBar;
@synthesize searchTableview;
@synthesize header;
@synthesize footer;
@synthesize searchFooter;



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

//    GKlist = [[BINGKlistModel alloc] init];
    
    filteredList = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(doneWithView:) name:@"reload" object:nil];
    [self addHeader];
    [self addFooter];
    
    UITableView *tableView = (id)[self.view viewWithTag:1];
    tableView.rowHeight = 75;
    UINib *nib = [UINib nibWithNibName:@"BINListCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:CellTableIdentifier];
    
//    [self getDataFromServer];

    
}

- (void)addHeader
{
    header = [[MJRefreshHeaderView alloc] init];
    header.delegate = self;
    header.scrollView = self.tableView;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView)
    {
        // 进入刷新状态就会回调这个Block
        [[BINGKlistModel GKlist] getDataFromServer];
        
        // 模拟延迟加载数据，因此2秒后才调用）这里的refreshView其实就是header
//        [self performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:2.0];
    };
//    header.endStateChangeBlock = ^(MJRefreshBaseView *refreshView)
//    {
//        // 刷新完毕就会回调这个Block
//        NSLog(@"%@----刷新完毕", refreshView.class);
//    };
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
        [[BINGKlistModel GKlist] getMoreDataFromServer];
    };

}

- (void)doneWithView:(NSNotification *) notification
{
    // 刷新表格
    NSString *type = [notification object];
    if([type isEqualToString:@"refresh"])
    {
        [self.tableView reloadData];
        [header endRefreshing];        // 调用endRefreshing结束刷新状态
    }
    else if([type isEqualToString:@"loadmore"])
    {
        [self.tableView reloadData];
        [footer endRefreshing];
    }
    else if([type isEqualToString:@"search"])
    {
        [searchFooter removeFromSuperview];                 //移除遗留的searchFooter

        if([BINGKlistModel GKlist].totalSearchRows >= 8)    //如果结果数大于等于8，则添加”searchFooter"
        {
//            searchFooter = [[MJRefreshFooterView alloc] init];
//            searchFooter.delegate = searchDisplayController;
            searchFooter.scrollView = searchTableview;
        }
        [searchTableview reloadData];
    }
    else if([type isEqualToString:@"searchmore"])
    {
        if([BINGKlistModel GKlist].totalSearchRows == [BINGKlistModel GKlist].loadedSearchRows)
        {
            [searchFooter removeFromSuperview];
            NSLog(@"remove");
        }

        [searchTableview reloadData];
        [searchFooter endRefreshing];

    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    // Return the number of sections.
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(tableView.tag == 1)
        return [[BINGKlistModel GKlist].list count];
    else
        return [[BINGKlistModel GKlist].searchList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];

    BINListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    NSDictionary *record;
    if(tableView.tag == 1)
    {
        record = [BINGKlistModel GKlist].list[row];
    }
    else
    {
        record = [BINGKlistModel GKlist].searchList[row];
    }
    cell.cellID = [record objectForKey:@"id"];
    cell.nameLabel.text = [record objectForKey:@"name"];
    cell.priceLabel.text = [record objectForKey:@"price"];
    cell.discountLabel.text = [record objectForKey:@"discount"];
    [cell setImage:[record objectForKey:@"picurl"]];
    
    //如果已经登录
    if([[BINUserModel sharedUserData] loginState])
    {
        if(tableView.tag == 1)
            record = [BINGKlistModel GKlist].list[row];
        else
            record = [BINGKlistModel GKlist].searchList[row];

        for(NSNumber *num in [[BINUserModel sharedUserData] favList])
        {
            if([record objectForKey:@"id"] == num)
            {
                [cell.heartButton setSelected:YES];
            }
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag == 1)
        [BINGKlistModel GKlist].isSearch = NO;
    else
        [BINGKlistModel GKlist].isSearch = YES;

    [BINGKlistModel GKlist].selectedRow = indexPath.row;
    [self performSegueWithIdentifier:@"detailView" sender:self];
}

#pragma mark - UISearchDisplayController delegate methods

- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView
{
    searchTableview = tableView;
    searchFooter = [[MJRefreshFooterView alloc] init];
    searchFooter.delegate = searchDisplayController;
//    searchFooter.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView)
//    {
//        NSLog(@"CCC");
//    };
    searchFooter.scrollView = tableView;

    tableView.rowHeight = 75;
    UINib *nib = [UINib nibWithNibName:@"BINListCell" bundle:nil];

    [tableView registerNib:nib forCellReuseIdentifier:CellTableIdentifier];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    searchFooter.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView)
    {
        [[BINGKlistModel GKlist] getMoreSearchResultFromServer:searchString];
    };
    [[BINGKlistModel GKlist] getSearchResultFromServer:searchString];
    

    
    //下拉的时候加载多8行

    
//    [filteredList removeAllObjects];

//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:@"search",@"search",searchString,@"searchString",nil];
//    [manager GET:@"http://127.0.0.1:8000/GKlist/" parameters:parameters
//         success:^(AFHTTPRequestOperation *operation, id responseObject)
//     {
//         [filteredList addObjectsFromArray:[responseObject objectForKey:@"result"]];
//
//         
//         [searchTableview reloadData];
//         
//     }
//         failure:^(AFHTTPRequestOperation *operation, NSError *error)
//     {
//         NSLog(@"Error: %@", error);
//     }];
    
//    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *dict, NSDictionary *bindings)
//    {
//        NSString *name = [dict objectForKey:@"name"];
//        NSRange range = [name rangeOfString:searchString options:NSCaseInsensitiveSearch];
//        return range.location != NSNotFound;
//    }];
//    NSMutableArray *list = [BINGKlistModel GKlist].list;
//
////    NSMutableArray *list = [[NSMutableArray alloc] initWithObjects:@"aaa",@"www",@"ccc", nil];
//        NSArray *match = [list filteredArrayUsingPredicate:predicate];
//        [filteredList addObjectsFromArray:match];

    return YES;
}






//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if([[segue identifier] isEqualToString:@"detailView"])
//    {
////        [[BINGKlistModel GKlist] getDetailFromServer];
////        NSDictionary *record = [BINGKlistModel GKlist].list[selectedRow];
////        BINGKdetailViewController *viewController = [segue destinationViewController];
////        viewController.name= [list[selectedRow] objectForKey:@"name"];
////        viewController.url= [list[selectedRow] objectForKey:@"picurl"];
////        viewController.description = [list[selectedRow] objectForKey:@"description"];
////        viewController.tablename = [list[selectedRow] objectForKey:@"tablename"];
//
//    }
//}





@end
