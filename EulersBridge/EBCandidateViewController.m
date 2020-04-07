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

@interface EBCandidateViewController () <UIScrollViewDelegate, UISearchBarDelegate, UICollectionViewDelegate, EBContentServiceDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *customScrollView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property (weak, nonatomic) IBOutlet UIView *positionsContainerView;
@property (weak, nonatomic) IBOutlet UIView *ticketsContainerView;
@property (weak, nonatomic) IBOutlet UIView *candidatesContainerView;

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
    
    CGFloat width = [EBHelper getScreenSize].width;
    CGFloat height = [EBHelper getScreenSize].height;
    self.positionsContainerView.frame = CGRectMake(0, 0, width, height);
    self.ticketsContainerView.frame = CGRectMake(width, 0, width, height);
    self.candidatesContainerView.frame = CGRectMake(width * 2, 0, width, height);
    
    [self.segmentedControl addTarget:self action:@selector(changeSegment) forControlEvents:UIControlEventValueChanged];
    
    // Disable controls until data returned from server.
    self.segmentedControl.enabled = NO;
    
    [self fetchElectionData];
    
    
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

- (void)fetchElectionData
{
    EBNetworkService *service = [[EBNetworkService alloc] init];
    service.contentDelegate = self;
    [service getElectionsInfoWithInstitutionId:TESTING_INSTITUTION_ID];
}

- (void)getElectionsInfoFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error
{
    if (success) {
        NSArray *array = info[@"foundObjects"];
        if (array.count > 0) {
            NSString *electionId = info[@"foundObjects"][0][@"electionId"];
            [self fetchCandidateDataWithElectionId:electionId];
            [self fetchTicketDataWithElectionId:electionId];
            [self fetchPositionDataWithElectionId:electionId];
        }
    } else {
        
    }

}

- (void)fetchCandidateDataWithElectionId:(NSString *)electionId
{
    EBNetworkService *service = [[EBNetworkService alloc] init];
    service.contentDelegate = self;
    [service getCandidatesInfoWithElectionId:electionId];
}

- (void)fetchTicketDataWithElectionId:(NSString *)electionId
{
    EBNetworkService *service = [[EBNetworkService alloc] init];
    service.contentDelegate = self;
    [service getTicketsInfoWithElectionId:electionId];
}

- (void)fetchPositionDataWithElectionId:(NSString *)electionId
{
    EBNetworkService *service = [[EBNetworkService alloc] init];
    service.contentDelegate = self;
    [service getPositionsInfoWithElectionId:electionId];
}

-(void)getCandidatesInfoFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error
{
    if (success) {
        // Enable controls after data returned from server.
        self.segmentedControl.enabled = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CandidatesReturnedFromServer" object:nil userInfo:info];
    } else {
        NSLog(@"%@", error);
    }
}

-(void)getTicketsInfoFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error
{
    if (success) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TicketsReturnedFromServer" object:nil userInfo:info];
    } else {
        NSLog(@"%@", error);
    }
}

-(void)getPositionsInfoFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error
{
    if (success) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PositionsReturnedFromServer" object:nil userInfo:info];
    } else {
        NSLog(@"%@", error);
    }
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
    if ([segue.identifier isEqualToString:@"CandidateTableEmbed"]) {
        EBCandidateTableViewController *tvc = (EBCandidateTableViewController *)[segue destinationViewController];
        tvc.candidateFilter = EBCandidateFilterAll;
        tvc.candidateViewType = EBCandidateViewTypeAll;
    }
}


@end
