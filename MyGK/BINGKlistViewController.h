//
//  BINGKlistViewController.h
//  MyGK
//
//  Created by bin on 14-2-25.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BINGKlistModel.h"

@interface BINGKlistViewController : UITableViewController<UISearchDisplayDelegate>
@property (nonatomic, strong) BINGKlistModel *GKlist;
@property int selectedRow;
@property UISearchBar  *  searchBar;
//@property UISearchDisplayController *  searchDc;
//@property (nonatomic) UITableView * tableView;
@property NSMutableArray *filteredList;
@property (weak, nonatomic) IBOutlet UISearchBar *SearchBar;
@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchDisplayController;
@property (nonatomic) UITableView *searchTableview;

@end
