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

@interface EBElectionViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *electionSegmentedControl;
@property (weak, nonatomic) IBOutlet UIScrollView *electionScrollView;

@property (weak, nonatomic) IBOutlet UILabel *electionTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *electionDateLabel;

@property (weak, nonatomic) IBOutlet EBTextViewGentium *overviewTextView;
@property (weak, nonatomic) IBOutlet EBTextViewGentium *processTextView;


@property (weak, nonatomic) IBOutlet UIView *candidateView;

@property (weak, nonatomic) IBOutlet UICollectionView *positionsCollectionView;
@property (strong, nonatomic) EBElectionPositionsDataSource *positionsDataSource;


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
    
    self.electionScrollView.contentSize = CGSizeMake(3 * [EBHelper getScreenSize].width, self.electionScrollView.bounds.size.height);
    self.electionScrollView.pagingEnabled = YES;
    self.electionScrollView.alwaysBounceVertical = NO;
    self.electionScrollView.delegate = self;
    
    CGFloat width = [EBHelper getScreenSize].width;
    CGFloat height = self.electionScrollView.bounds.size.height;
    
    self.overviewTextView.frame = CGRectMake(0, 0, width, height);
    self.processTextView.frame = CGRectMake(width, 0, width, height);
    self.positionsCollectionView.frame = CGRectMake(width * 2, 0, width, height);
    self.overviewTextView.contentInset = UIEdgeInsetsMake(44.0, 0, 0, 0);
    self.processTextView.contentInset = UIEdgeInsetsMake(44.0, 0, 0, 0);
    self.positionsCollectionView.contentInset = UIEdgeInsetsMake(44.0, 0, 0, 0);
    
    [self.segmentedControl addTarget:self action:@selector(changeSegment) forControlEvents:UIControlEventValueChanged];
    [self.electionSegmentedControl addTarget:self action:@selector(electionChangeSegment) forControlEvents:UIControlEventValueChanged];
    
    self.positionsDataSource = [[EBElectionPositionsDataSource alloc] init];
    self.positionsCollectionView.dataSource = self.positionsDataSource;
    self.positionsCollectionView.delegate = self.positionsDataSource;
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

- (void)electionChangeSegment
{
    [self.electionScrollView setContentOffset:CGPointMake(self.electionSegmentedControl.selectedSegmentIndex * [EBHelper getScreenSize].width, 0.0) animated:YES];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.electionSegmentedControl.selectedSegmentIndex = self.electionScrollView.contentOffset.x / [EBHelper getScreenSize].width;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowPositionDetail"]) {
        EBFeedCollectionViewCell *cell = (EBFeedCollectionViewCell *)sender;
        EBElectionPositionDetailViewController *detail = (EBElectionPositionDetailViewController *)[segue destinationViewController];
        detail.data = self.positionsDataSource.positions[cell.index];
    }
}


@end
