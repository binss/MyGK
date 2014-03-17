//
//  BINNendoroidViewController.m
//  MyGK
//
//  Created by bin on 14-3-12.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import "BINNendoroidViewController.h"
#import "BINNendoroidCell.h"
#import "MJRefresh.h"
#import <sqlite3.h>


static NSString *cellIdentifier = @"nendoroidCell";

@interface BINNendoroidViewController () <MJRefreshBaseViewDelegate>
@property MJRefreshFooterView *footer;
@property sqlite3 *database;
@end

@implementation BINNendoroidViewController
@synthesize nendoroidList;
@synthesize footer;
@synthesize database;

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
    nendoroidList = [NSMutableArray array];
    
    
    UICollectionView *collectionView = (id)[self.view viewWithTag:3];
    
    NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"MyGKDataBase" ofType:@"db"];

    //由于SQLite3是采用可移植的C，因此需要将NSString字符串类型转换成C字符串
    const char *charPath = [dbPath UTF8String];
//    sqlite3 *database;

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

//    tableView.rowHeight = 75;

//    NSString *querySQL = @"select * from Nendoroid WHERE id <=8 and id >=4";
    
    [self addFooter];
    
    UINib *nib = [UINib nibWithNibName:@"BINNendoroid" bundle:nil];
    [collectionView registerNib:nib forCellWithReuseIdentifier:cellIdentifier];
//    [self.collectionView registerClass:[BINNendoroidCell class] forCellWithReuseIdentifier:@"CellIdentifier"];

}



- (void)addFooter
{
    footer = [[MJRefreshFooterView alloc] init];
    footer.delegate = self;
    footer.scrollView = self.collectionView;
    //下拉的时候加载多8行
    [footer beginRefreshing];

}

- (void)doneWithView:(MJRefreshBaseView *)refreshView
{
    // 刷新表格
    [self.collectionView reloadData];
    
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
}

- (void)addRecord
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
        NSLog(@"%i",[nendoroidList count]);
        sqlite3_finalize(statement);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    [self addRecord];
    [self performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:0];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSMutableArray *data = [self.dataArray objectAtIndex:indexPath.section];
//    BINNendoroidCell *cell = (BINNendoroidCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
//    cell.titleLabel.text = [data objectAtIndex:indexPath.row];
    
    BINNendoroidCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    NSDictionary * dict = [nendoroidList objectAtIndex:indexPath.row];
    cell.name.text = [dict objectForKey:@"productName"];
    cell.no.text = [dict objectForKey:@"itemNum"];

    NSString *path = [NSString stringWithFormat:@"Nendoroid.bundle/icon/%@.png",[dict objectForKey:@"itemNum"]];
    NSString *image_url = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:path];
    [cell.imageView setImage:[UIImage imageWithContentsOfFile:image_url]];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    NSMutableArray *sectionArray = [self.dataArray objectAtIndex:section];
    return [nendoroidList count];
}

@end
