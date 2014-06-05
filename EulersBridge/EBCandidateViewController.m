//
//  EBCandidateViewController.m
//  Isegoria
//
//  Created by Alan Gao on 27/05/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBCandidateViewController.h"
#import "EBFeedCollectionViewCell.h"
#import "MyConstants.h"

@interface EBCandidateViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIScrollView *customScrollView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UICollectionView *positionsCollectionView;

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
    if (collectionView == self.positionsCollectionView) {
        return 10;
    }
    return 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EBFeedCollectionViewCell *cell;
    NSDictionary *dict;
    if (collectionView == self.positionsCollectionView) {
        dict = @{@"imageName": [NSString stringWithFormat:@"photo%ld.jpg", indexPath.item],
                 @"title": @"Position",
                 @"date": @"",
                 @"priority": @(0)};
    }
    
    int priority = [dict[@"priority"] intValue];
    
    
    
    if (priority == 1) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FeedCellLarge" forIndexPath:indexPath];
    } else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FeedCell" forIndexPath:indexPath];
    }
    
    
    cell.data = dict;
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
    if (collectionView == self.positionsCollectionView) {
        return CGSizeMake(150.0, 150.0);
    }
    return CGSizeMake(150.0, 150.0);
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
