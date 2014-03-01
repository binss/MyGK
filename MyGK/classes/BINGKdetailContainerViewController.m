//
//  BINGKdetailContainerViewController.m
//  MyGK
//
//  Created by bin on 14-2-26.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import "BINGKdetailContainerViewController.h"
#import "UIImageView+AFNetworking.h"
#import "BINGKlistModel.h"

@interface BINGKdetailContainerViewController ()

@end

@implementation BINGKdetailContainerViewController
@synthesize name;
@synthesize url;
@synthesize tablename;
@synthesize description;

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
    [[BINGKlistModel GKlist] addObserver:self forKeyPath:@"selectedDescription" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    [[BINGKlistModel GKlist] generalData];
    [[BINGKlistModel GKlist] getDetailFromServer];
}



- (void)viewWillAppear:(BOOL)animated
{
    self.nameLabel.text = [[BINGKlistModel GKlist] selectedName];
    NSURL *turl = [NSURL URLWithString:[[BINGKlistModel GKlist] selectedPicURL]];
    [self.picImageView setImageWithURL:turl placeholderImage:[UIImage imageNamed:@"profile-image-placeholder"]];
//    self.descriptionTextField.text = [[BINGKlistModel GKlist] selectedDescription];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[BINGKlistModel GKlist] removeObserver:self forKeyPath:@"selectedDescription"];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    self.descriptionTextField.text = [change objectForKey:@"new"];
//
//    if([keyPath isEqualToString:@"description"])
//    {
//        self.descriptionTextField.text = [[BINGKlistModel GKlist] selectedDescription];
//    }
}


@end
