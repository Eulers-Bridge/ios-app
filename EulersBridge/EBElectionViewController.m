//
//  EBElectionViewController.m
//  Isegoria
//
//  Created by Alan Gao on 22/05/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBElectionViewController.h"
#import "MyConstants.h"
#import "EBHelper.h"
#import "EBElectionPositionsDataSource.h"
#import "EBFeedCollectionViewCell.h"
#import "EBElectionPositionDetailViewController.h"
#import "EBNetworkService.h"
#import "EBUserService.h"
#import "EBVoteViewController.h"

@interface EBElectionViewController () <UIScrollViewDelegate, EBContentServiceDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property (weak, nonatomic) IBOutlet UILabel *electionTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *electionDateLabel;


@property (weak, nonatomic) IBOutlet UIView *candidateView;

@property (weak, nonatomic) IBOutlet UIView *coverView;

@property (strong, nonatomic) NSDictionary *electionInfo;



@end

@implementation EBElectionViewController

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
    self.candidateView.hidden = YES;
    [self.segmentedControl addTarget:self action:@selector(changeSegment) forControlEvents:UIControlEventValueChanged];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self getElectionInfo];
    BOOL hasPPSEQuestions = [EBUserService hasPPSEQuestions];
    self.coverView.hidden = hasPPSEQuestions;
    [self.segmentedControl setEnabled:hasPPSEQuestions];
}

- (void)changeSegment
{
    if (self.segmentedControl.selectedSegmentIndex == 1) {
        self.candidateView.hidden = NO;
    } else {
        self.candidateView.hidden = YES;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CandidateCancelSearch" object:nil];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getElectionInfo
{
    EBNetworkService *service = [[EBNetworkService alloc] init];
    service.contentDelegate = self;
    [service getElectionsInfoWithInstitutionId:TESTING_INSTITUTION_ID];
}

-(void)getElectionsInfoFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error
{
    if (success) {
        NSArray *array = info[@"foundObjects"];
        if (array.count > 0) {
            EBNetworkService *service = [[EBNetworkService alloc] init];
            service.contentDelegate = self;
            NSString *electionId = info[@"foundObjects"][0][@"electionId"];
            [service getElectionInfoWithElectionId:electionId];
        }
    } else {
        
    }
}

- (void)getElectionInfoFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error
{
    if (success) {
        self.electionInfo = info;
        self.electionTitleLabel.text = info[@"title"];
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } else {
        NSLog(@"%@", error);
    }
}



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowPledge"]) {
        EBVoteViewController *voteViewController = (EBVoteViewController *)[segue destinationViewController];
        voteViewController.electionInfo = self.electionInfo;
    }
}


@end
