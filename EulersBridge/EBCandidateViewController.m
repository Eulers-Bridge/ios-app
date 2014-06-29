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

@interface EBCandidateViewController () <UIScrollViewDelegate, UISearchBarDelegate, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *customScrollView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UICollectionView *positionsCollectionView;
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
    self.customScrollView.contentSize = CGSizeMake(WIDTH_OF_SCREEN * 3, self.customScrollView.bounds.size.height);
    [self.segmentedControl addTarget:self action:@selector(changeSegment) forControlEvents:UIControlEventValueChanged];
    
    self.positionsDataSource = [[EBElectionPositionsDataSource alloc] init];
    self.positionsCollectionView.delegate = self;
    self.positionsCollectionView.dataSource = self.positionsDataSource;

}

- (void)changeSegment
{
    [self.customScrollView setContentOffset:CGPointMake(self.segmentedControl.selectedSegmentIndex * WIDTH_OF_SCREEN, 0.0) animated:YES];
}

#pragma mark UIScrollView delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    if (scrollView == self.customScrollView) {
        self.segmentedControl.selectedSegmentIndex = scrollView.contentOffset.x / WIDTH_OF_SCREEN;
    }
}


/*
#pragma mark position collection view delegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect frame = self.candidatesTableView.frame;
    frame.origin.x = WIDTH_OF_SCREEN;
    self.candidatesTableView.frame = frame;
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect frame = self.candidatesTableView.frame;
        frame.origin.x = 0;
        self.candidatesTableView.frame = frame;
        CGRect positionFrame = self.positionsCollectionView.frame;
        positionFrame.origin.x = -WIDTH_OF_SCREEN;
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
