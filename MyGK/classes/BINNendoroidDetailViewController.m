//
//  BINNendoroidDetailViewController.m
//  MyGK
//
//  Created by bin on 14-3-19.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import "BINNendoroidDetailViewController.h"
#import "BINNendoroidModel.h"

@interface BINNendoroidDetailViewController ()
@property int currentPage;

@end

@implementation BINNendoroidDetailViewController
@synthesize currentPage;
@synthesize imageScrollView;
@synthesize pageControl;
@synthesize pageControlScrolling;
@synthesize currentImageX;

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
    currentImageX = 0;
    
    imageScrollView= [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 260)];
    imageScrollView.pagingEnabled = YES;
    imageScrollView.showsHorizontalScrollIndicator = NO;
    imageScrollView.showsVerticalScrollIndicator = NO;
    imageScrollView.delegate = self;
    
    pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    [pageControl addTarget:self action:@selector(pageControlClicked:) forControlEvents:UIControlEventValueChanged];
    pageControl.currentPage = 0;
    currentPage = 0;
    pageControlScrolling = NO;
    
    [self loadImage];
  
    self.itemNumLabel.text = [[BINNendoroidModel sharedNendoroid] selected_itemNum];
    self.nameLabel.text = [[BINNendoroidModel sharedNendoroid] selected_productName];
    self.workNameLabel.text = [[BINNendoroidModel sharedNendoroid] selected_workName];
    self.priceLabel.text = [[BINNendoroidModel sharedNendoroid] selected_price];
    self.timeLabel.text = [[BINNendoroidModel sharedNendoroid] selected_time];
    self.descriptionLabel.text = [[BINNendoroidModel sharedNendoroid] selected_description];


    
    [self.view addSubview:imageScrollView];

    [self.view addSubview:pageControl];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//    self.pageControl.numberOfPages=numOfPages;      //页数（点数）
//    self.pageControl.currentPage = currentPage;                 //设置高亮在第几个点

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(pageControlScrolling)
        return;
    int page = floor(imageScrollView.contentOffset.x) / 320;
    NSLog(@"%i",page);
    pageControl.currentPage = page;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    pageControlScrolling = NO;
}

- (void)pageControlClicked:(UIPageControl *)sender
{
    pageControlScrolling = YES;

    CGSize viewsize = imageScrollView.frame.size;
    CGRect rect = CGRectMake(sender.currentPage * viewsize.width, 0, viewsize.width, viewsize.height);
    [imageScrollView scrollRectToVisible:rect animated:YES];
    
}

- (void)loadImage
{
    int totalImageNum = [[BINNendoroidModel sharedNendoroid] imageNum];
    NSString * num = [[BINNendoroidModel sharedNendoroid] selected_itemNum];
//    int totalImageNum = 4;
//    NSString * num = @"403";
    [imageScrollView setContentSize:CGSizeMake(totalImageNum * 320, 260)];
    for(int i = 1;i <= totalImageNum;i++)
    {
        NSString *path = [NSString stringWithFormat:@"Nendoroid.bundle/%@/%@-%i",num,num,i];
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:path ofType:@"png"];
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(currentImageX, -20, 320, 320)];
        [imageview setContentMode:UIViewContentModeScaleAspectFill];
        [imageview setImage:[[UIImage alloc] initWithContentsOfFile:imagePath]];
        [imageScrollView addSubview:imageview];
        imageview.clipsToBounds = YES;
        currentImageX += 320;
    }
    pageControl.numberOfPages = currentImageX / 320;
    NSLog(@"%i",pageControl.numberOfPages);
}





@end
