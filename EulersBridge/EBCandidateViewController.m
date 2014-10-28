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
#import "MyConstants.h"
#import "EBHelper.h"

@interface EBCandidateViewController () <UIScrollViewDelegate, UISearchBarDelegate, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *customScrollView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UICollectionView *positionsCollectionView;
@property (weak, nonatomic) IBOutlet UIView *ticketsCollectionView;
@property (weak, nonatomic) IBOutlet UIView *candidateTableView;

@property (strong, nonatomic) EBElectionPositionsDataSource *positionsDataSource;


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
    self.positionsCollectionView.contentInset = UIEdgeInsetsMake(108, 0, 49, 0);

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
        tvc.candidateFilter = EBCandidateFilterAll;
    }
    if ([segue.identifier isEqualToString:@"ShowCandidateFromPosition"]) {
        EBCandidateTableViewController *tvc = (EBCandidateTableViewController *)[segue destinationViewController];
        tvc.candidateFilter = EBCandidateFilterByPosition;
        EBFeedCollectionViewCell *cell = (EBFeedCollectionViewCell *)sender;
        tvc.filterId = [cell.data[@"id"] intValue];
        tvc.filterTitle = cell.titleLabel.text;
    }
}


@end
