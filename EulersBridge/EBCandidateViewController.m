//
//  EBCandidateViewController.m
//  Isegoria
//
//  Created by Alan Gao on 27/05/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBCandidateViewController.h"
#import "EBFeedCollectionViewCell.h"
#import "EBElectionPositionsDataSource.h"
#import "EBElectionCandidateTableDataSource.h"
#import "EBCandidateProfileViewController.h"
#import "EBCandidateTableViewController.h"
#import "EBTicketsCollectionViewController.h"
#import "MyConstants.h"
#import "EBHelper.h"

@interface EBCandidateViewController () <UIScrollViewDelegate, UISearchBarDelegate, UICollectionViewDelegate, EBElectionPositionsDataSourceDelegate, EBContentServiceDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *customScrollView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UICollectionView *positionsCollectionView;
@property (weak, nonatomic) IBOutlet UIView *ticketsCollectionView;
@property (weak, nonatomic) IBOutlet UIView *candidateTableView;

@property (strong, nonatomic) NSArray *candidates;

@property (strong, nonatomic) EBElectionPositionsDataSource *positionsDataSource;

@property (weak, nonatomic) EBCandidateTableViewController *allCandidateTableViewController;
@property (weak, nonatomic) EBTicketsCollectionViewController *ticketsCollectionViewController;


@end

@implementation EBCandidateViewController

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
    // Design: Disable controls until candidates are returned from the server. Pass candidates data
    //         to Embeded views and positions collection view.
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.customScrollView.contentSize = CGSizeMake([EBHelper getScreenSize].width * 3, self.customScrollView.bounds.size.height);
    [self.segmentedControl addTarget:self action:@selector(changeSegment) forControlEvents:UIControlEventValueChanged];
    
    CGFloat width = [EBHelper getScreenSize].width;
    CGFloat height = [EBHelper getScreenSize].height;
    
    self.positionsCollectionView.frame = CGRectMake(0, 0, width, height);
    self.ticketsCollectionView.frame = CGRectMake(width, 0, width, height);
    self.candidateTableView.frame = CGRectMake(width * 2, 0, width, height);
    
    self.positionsDataSource = [[EBElectionPositionsDataSource alloc] init];
    self.positionsCollectionView.delegate = self.positionsDataSource;
    self.positionsCollectionView.dataSource = self.positionsDataSource;
    self.positionsDataSource.delegate = self;
    [self.positionsDataSource fetchData];
    self.positionsCollectionView.contentInset = UIEdgeInsetsMake(108, 0, 49, 0);
    
    // Disable controls until data returned from server.
    self.segmentedControl.enabled = NO;
    self.positionsCollectionView.userInteractionEnabled = NO;
    
    [self fetchCandidateData];
    [self fetchTicketData];
}

- (void)changeSegment
{
    [self.customScrollView setContentOffset:CGPointMake(self.segmentedControl.selectedSegmentIndex * [EBHelper getScreenSize].width, 0.0) animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CandidateCancelSearch" object:nil];
}

#pragma mark UIScrollView delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    if (scrollView == self.customScrollView) {
        self.segmentedControl.selectedSegmentIndex = scrollView.contentOffset.x / [EBHelper getScreenSize].width;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CandidateCancelSearch" object:nil];
    }
}

-(void)electionPositionsFetchDataCompleteWithSuccess:(BOOL)success
{
    if (success) {
        [self.positionsCollectionView reloadData];
    }
}

- (void)fetchCandidateData
{
    EBNetworkService *service = [[EBNetworkService alloc] init];
    service.contentDelegate = self;
    [service getCandidatesInfoWithElectionId:TESTING_ELETION_ID];
}

- (void)fetchTicketData
{
    EBNetworkService *service = [[EBNetworkService alloc] init];
    service.contentDelegate = self;
    [service getTicketsInfoWithElectionId:TESTING_ELETION_ID];
}

-(void)getCandidatesInfoFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error
{
    if (success) {
        // Enable controls after data returned from server.
        self.segmentedControl.enabled = YES;
        self.positionsCollectionView.userInteractionEnabled = YES;
        self.allCandidateTableViewController.candidates = (NSArray *)info;
        self.candidates = (NSArray *)info;
        [self.allCandidateTableViewController setup];
    } else {
        NSLog(@"%@", error);
    }
}

-(void)getTicketsInfoFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error
{
    if (success) {
        // Enable controls after data returned from server.
        self.segmentedControl.enabled = YES;
        self.positionsCollectionView.userInteractionEnabled = YES;
        self.allCandidateTableViewController.candidates = (NSArray *)info;
        self.candidates = (NSArray *)info;
        [self.allCandidateTableViewController setup];
    } else {
        NSLog(@"%@", error);
    }
}

/*
#pragma mark position collection view delegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect frame = self.candidatesTableView.frame;
    frame.origin.x = [EBHelper getScreenSize].width;
    self.candidatesTableView.frame = frame;
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect frame = self.candidatesTableView.frame;
        frame.origin.x = 0;
        self.candidatesTableView.frame = frame;
        CGRect positionFrame = self.positionsCollectionView.frame;
        positionFrame.origin.x = -[EBHelper getScreenSize].width;
        self.positionsCollectionView.frame = positionFrame;
    } completion:^(BOOL finished) {
        // Show back button
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    }];
}
*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"CandidateTableEmbed"]) {
        EBCandidateTableViewController *tvc = (EBCandidateTableViewController *)[segue destinationViewController];
        self.allCandidateTableViewController = tvc;
        tvc.candidateFilter = EBCandidateFilterAll;
    }
    if ([segue.identifier isEqualToString:@"TicketsCollectionEmbed"]) {
        EBTicketsCollectionViewController *tvc = (EBTicketsCollectionViewController *)[segue destinationViewController];
        self.ticketsCollectionViewController = tvc;
    }
    if ([segue.identifier isEqualToString:@"ShowCandidateFromPosition"]) {
        EBCandidateTableViewController *tvc = (EBCandidateTableViewController *)[segue destinationViewController];
        tvc.candidateFilter = EBCandidateFilterByPosition;
        EBFeedCollectionViewCell *cell = (EBFeedCollectionViewCell *)sender;
        tvc.filterId = [cell.data[@"id"] intValue];
        tvc.filterTitle = cell.titleLabel.text;
        tvc.candidates = self.candidates;
    }
}


@end
