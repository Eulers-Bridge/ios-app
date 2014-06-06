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
#import "MyConstants.h"

@interface EBCandidateViewController () <UIScrollViewDelegate>
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
    self.positionsCollectionView.delegate = self.positionsDataSource;
    self.positionsCollectionView.dataSource = self.positionsDataSource;
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    if ([segue.identifier isEqualToString:@"ShowPositionDetail"]) {
//        EBFeedCollectionViewCell *cell = (EBFeedCollectionViewCell *)sender;
//        EBElectionPositionDetailViewController *detail = (EBElectionPositionDetailViewController *)[segue destinationViewController];
//        detail.titleLabel.text = self.positionsDataSource.positions[cell.index][@"title"];
//        detail.descriptionTextView.text = self.positionsDataSource.positions[cell.index][@"description"];
//    }
}


@end
