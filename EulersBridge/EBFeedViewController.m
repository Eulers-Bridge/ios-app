//
//  EBFeedViewController.m
//  EulersBridge
//
//  Created by Alan Gao on 24/04/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBFeedViewController.h"
#import "EBFeedCollectionViewCell.h"

@interface EBFeedViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *newsCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *eventsCollectionView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;


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
    self.eventsCollectionView.contentInset = UIEdgeInsetsMake(64.0, 0.0, 0.0, 0.0);
    [self.segmentedControl addTarget:self action:@selector(changeSegment) forControlEvents:UIControlEventValueChanged];
}

- (void)changeSegment
{
    int newsX, eventX, photoX = 0;
    int widthOfScreen = 320;
    
    newsX = (int)self.segmentedControl.selectedSegmentIndex * -widthOfScreen;
    eventX = newsX + widthOfScreen;
    photoX = eventX + widthOfScreen;
    
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.newsCollectionView.frame = CGRectMake(newsX,
                                                   self.newsCollectionView.frame.origin.y,
                                                   self.newsCollectionView.frame.size.width,
                                                   self.newsCollectionView.frame.size.height);
        
        
        self.eventsCollectionView.frame = CGRectMake(eventX,
                                                     self.eventsCollectionView.frame.origin.y,
                                                     self.eventsCollectionView.frame.size.width,
                                                     self.eventsCollectionView.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];

}

- (IBAction)test:(id)sender {
    self.segmentedControl.selectedSegmentIndex = 2;
}

- (IBAction)swipeRight:(UISwipeGestureRecognizer *)sender
{
    
    if (self.segmentedControl.selectedSegmentIndex > 0) {
        self.segmentedControl.selectedSegmentIndex = self.segmentedControl.selectedSegmentIndex - 1;
        [self changeSegment];
    }
}

- (IBAction)swipeLeft:(UISwipeGestureRecognizer *)sender
{
    
    if (self.segmentedControl.selectedSegmentIndex < 2) {
        self.segmentedControl.selectedSegmentIndex = self.segmentedControl.selectedSegmentIndex + 1;
        [self changeSegment];
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 15;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EBFeedCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FeedCell" forIndexPath:indexPath];
    
    cell.titleLabel.text = @"title";
    cell.imageView.image = [UIImage imageNamed:@"placeholder"];
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(150.0, 150.0);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
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
