//
//  EBElectionViewController.m
//  Isegoria
//
//  Created by Alan Gao on 22/05/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBElectionViewController.h"
#import "MyConstants.h"

@interface EBElectionViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *electionSegmentedControl;
@property (weak, nonatomic) IBOutlet UIScrollView *electionScrollView;

@property (weak, nonatomic) IBOutlet UILabel *electionTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *electionDateLabel;

@property (weak, nonatomic) IBOutlet UIView *candidateView;


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
    
    // Font setup
    self.electionTitleLabel.font = [UIFont fontWithName:@"MuseoSansRounded-300" size:self.electionTitleLabel.font.pointSize];
    self.electionDateLabel.font = [UIFont fontWithName:@"MuseoSansRounded-500" size:self.electionDateLabel.font.pointSize];
    
    self.electionScrollView.contentSize = CGSizeMake(3 * WIDTH_OF_SCREEN, self.electionScrollView.bounds.size.height);
    self.electionScrollView.pagingEnabled = YES;
    self.electionScrollView.alwaysBounceVertical = NO;
    self.electionScrollView.delegate = self;
    
    [self.segmentedControl addTarget:self action:@selector(changeSegment) forControlEvents:UIControlEventValueChanged];
    [self.electionSegmentedControl addTarget:self action:@selector(electionChangeSegment) forControlEvents:UIControlEventValueChanged];
}

- (void)changeSegment
{
    if (self.segmentedControl.selectedSegmentIndex == 1) {
        self.candidateView.hidden = NO;
    } else {
        self.candidateView.hidden = YES;
    }

}

- (void)electionChangeSegment
{
    [self.electionScrollView setContentOffset:CGPointMake(self.electionSegmentedControl.selectedSegmentIndex * WIDTH_OF_SCREEN, 0.0) animated:YES];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.electionSegmentedControl.selectedSegmentIndex = self.electionScrollView.contentOffset.x / WIDTH_OF_SCREEN;
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

@end
