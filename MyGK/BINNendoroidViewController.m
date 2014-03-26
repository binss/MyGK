//
//  BINNendoroidViewController.m
//  MyGK
//
//  Created by bin on 14-3-12.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import <sqlite3.h>
#import "BINNendoroidViewController.h"
#import "BINNendoroidCell.h"
#import "MJRefresh.h"
#import "BINNendoroidModel.h"

static NSString *cellIdentifier = @"nendoroidCell";

@interface BINNendoroidViewController () <MJRefreshBaseViewDelegate>
@property MJRefreshFooterView *footer;
@end

@implementation BINNendoroidViewController
@synthesize footer;

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
    
    UICollectionView *collectionView = (id)[self.view viewWithTag:3];
    

    [self addFooter];
    
    UINib *nib = [UINib nibWithNibName:@"BINNendoroid" bundle:nil];
    [collectionView registerNib:nib forCellWithReuseIdentifier:cellIdentifier];
//    [self.collectionView registerClass:[BINNendoroidCell class] forCellWithReuseIdentifier:@"CellIdentifier"];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(loadNendoroidDetail:) name:@"loadNendoroidDetail" object:nil];


}

- (void)loadNendoroidDetail:(NSNotification *) notification
{
    // 刷新表格
    NSString *type = [notification object];
    if([type isEqualToString:@"success"])
    {
        [self performSegueWithIdentifier:@"nendoroidDetail" sender:self];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"检索不到改编号" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil,nil];
        
        [alert show];
    }
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
//    [self addRecord];
    [[BINNendoroidModel sharedNendoroid] addNendoroidRecord];
    [self performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:0];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSMutableArray *data = [self.dataArray objectAtIndex:indexPath.section];
//    BINNendoroidCell *cell = (BINNendoroidCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
//    cell.titleLabel.text = [data objectAtIndex:indexPath.row];
    
    BINNendoroidCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    NSDictionary * dict = [[BINNendoroidModel sharedNendoroid].nendoroidList objectAtIndex:indexPath.row];
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
    return [[BINNendoroidModel sharedNendoroid].nendoroidList count];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dict = [[BINNendoroidModel sharedNendoroid].nendoroidList objectAtIndex:indexPath.row];
    [[BINNendoroidModel sharedNendoroid] getNendoroidDetail:[dict objectForKey:@"itemNum"]];
    
    [self performSegueWithIdentifier:@"nendoroidDetail" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //隐藏toolbar
    [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
    //    self.navigationItem.backBarButtonItem= [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:nil];
}


- (IBAction)searchButtonPressed:(UIBarButtonItem *)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入您想查看的粘土编号:" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认",nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];

    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UITextField *textField = [alertView textFieldAtIndex:0];
    if(textField.text.length < 3 || textField.text.length > 4)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"输入编号不合法，请检查～" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil,nil];
        
        [alert show];
    }
    else
    {
        [[BINNendoroidModel sharedNendoroid] checkItemNum:textField.text];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
