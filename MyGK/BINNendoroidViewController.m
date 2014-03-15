//
//  BINNendoroidViewController.m
//  MyGK
//
//  Created by bin on 14-3-12.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import "BINNendoroidViewController.h"
#import "BINNendoroidCell.h"

static NSString *cellIdentifier = @"nendoroidCell";

@interface BINNendoroidViewController ()

@end

@implementation BINNendoroidViewController

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

//    tableView.rowHeight = 75;
    
    UINib *nib = [UINib nibWithNibName:@"BINNendoroid" bundle:nil];
    [collectionView registerNib:nib forCellWithReuseIdentifier:cellIdentifier];
//    [self.collectionView registerClass:[BINNendoroidCell class] forCellWithReuseIdentifier:@"CellIdentifier"];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"call");

    
//    NSMutableArray *data = [self.dataArray objectAtIndex:indexPath.section];
//    BINNendoroidCell *cell = (BINNendoroidCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
//    cell.titleLabel.text = [data objectAtIndex:indexPath.row];
    
    BINNendoroidCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];

    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    NSMutableArray *sectionArray = [self.dataArray objectAtIndex:section];
    return 50;
}

@end
