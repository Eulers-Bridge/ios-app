//
//  EBFeedViewController.m
//  EulersBridge
//
//  Created by Alan Gao on 24/04/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBFeedViewController.h"
#import "EBFeedCollectionViewCell.h"
#import "EBFeedDetailViewController.h"
#import "AFNetworking.h"
#import "MyConstants.h"

@interface EBFeedViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *newsCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *eventsCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *photosCollectionView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIScrollView *customScrollView;
@property (strong, nonatomic) NSArray *sampleTitles;
@property (strong, nonatomic) NSArray *sampleDates;
@property (strong, nonatomic) NSArray *newsList;


@end

@implementation EBFeedViewController

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
    [self.segmentedControl addTarget:self action:@selector(changeSegment) forControlEvents:UIControlEventValueChanged];
    self.newsCollectionView.alwaysBounceVertical = YES;
    self.customScrollView.contentSize = CGSizeMake(WIDTH_OF_SCREEN * 3, self.customScrollView.bounds.size.height - 150);
    self.customScrollView.pagingEnabled = YES;
    self.customScrollView.alwaysBounceVertical = NO;
    self.customScrollView.delegate = self;

    // Add refresh control
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(fetchDataNews:)
             forControlEvents:UIControlEventValueChanged];
    [self.newsCollectionView addSubview:refreshControl];
    [self.eventsCollectionView addSubview:refreshControl];
    [self.photosCollectionView addSubview:refreshControl];
    self.eventsCollectionView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.newsCollectionView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.photosCollectionView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    
    
//    [self fetchDataNews:nil];
//    [self setupSampleData];
    self.sampleDates = @[@"Yesterday, 9:00 AM",
                         @"Friday, 1:00 PM",
                         @"Wednesday, 2:00 PM",
                         @"2nd May 2014, 8:00 AM",
                         @"28th April 2014, 10:00AM"];

}



- (void)changeSegment
{
    [self.customScrollView setContentOffset:CGPointMake(self.segmentedControl.selectedSegmentIndex * WIDTH_OF_SCREEN, 0.0) animated:YES];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.customScrollView) {
        self.segmentedControl.selectedSegmentIndex = scrollView.contentOffset.x / WIDTH_OF_SCREEN;
    }
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    return [self.newsList count];
    return 15;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EBFeedCollectionViewCell *cell;
    int priority = indexPath.item % 3 == 0 ? 1 : 0;
    if (collectionView == self.eventsCollectionView) {
        priority = 1;
    } else if (collectionView == self.photosCollectionView) {
        priority = 0;
    }
    
    if (priority == 1) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FeedCellLarge" forIndexPath:indexPath];
    } else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FeedCell" forIndexPath:indexPath];
    }

    
    cell.data = @{@"priority"   : @(priority),
                  @"title"      : @"Example title",
                  @"date"       : self.sampleDates[indexPath.item%5],
                  @"imageName"  : [NSString stringWithFormat:@"%@%ld.jpg", @"news", (long)indexPath.item]};
//    NSLog(@"%ld", indexPath.item);
//    NSLog(@"%@", cell.data);
//    NSMutableDictionary *dict = [self.newsList[indexPath.item] mutableCopy];
//    [dict setObject:@(indexPath.item % 3 == 0 ? 1 : 0) forKey:@"priority"];
//    cell.data = [dict copy];
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    [cell setup];
    
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.eventsCollectionView) {
        return CGSizeMake(307.0, 150.0);
    } else if (collectionView == self.photosCollectionView) {
        return CGSizeMake(150.0, 150.0);
    } else {
        return indexPath.item % 3 == 0 ? CGSizeMake(307.0, 150.0) : CGSizeMake(150.0, 150.0);
    }
}

//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(5, 5, 5, 5);
//}


- (void)fetchDataNews:(UIRefreshControl *)refreshControl
{
//    if (self.currentUser) {
        // Get my polls
        NSString *urlString = [SERVER_URL stringByAppendingFormat:@"/news-list"];
        NSURL *url = [NSURL URLWithString:urlString];
        
        NSDictionary *info = @{@"token": SERVER_TOKEN};
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:info options:NSJSONWritingPrettyPrinted error:nil];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody: jsonData];
    
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        operation.responseSerializer = [AFJSONResponseSerializer serializer];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            self.newsList = responseObject;
            [refreshControl endRefreshing];
//            NSLog(@"%@", responseObject);
            //            NSLog(@"got data");
            self.navigationController.tabBarItem.badgeValue = nil;
            [self.newsCollectionView reloadData];
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (error) {
                [refreshControl endRefreshing];
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
            }
        }];
        [operation start];
    
    
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    NSDictionary *parameters = @{@"token": SERVER_TOKEN};
//    NSString *URLString = [SERVER_URL stringByAppendingFormat:@"/news-list"];
//    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:parameters error:nil];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"JSON: %@", responseObject);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
    

    
//    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showNewsDetail"]) {
        [[segue destinationViewController] setFeedDetailType:EBFeedDetailNews];
    } else if ([segue.identifier isEqualToString:@"showEventDetail"]) {
        [[segue destinationViewController] setFeedDetailType:EBFeedDetailEvent];
    }
}



- (void)setupSampleData
{

    
}

@end
