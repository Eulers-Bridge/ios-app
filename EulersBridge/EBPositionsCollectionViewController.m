//
//  EBPositionsCollectionViewController.m
//  Isegoria
//
//  Created by Alan Gao on 14/04/2015.
//  Copyright (c) 2015 Eulers Bridge. All rights reserved.
//

#import "EBPositionsCollectionViewController.h"
#import "EBCandidateTableViewController.h"
#import "EBFeedCollectionViewCell.h"
#import "EBHelper.h"

@interface EBPositionsCollectionViewController ()


@property BOOL positionDataReady;
@property BOOL ticketDataReady;
@property BOOL candidateDataReady;

@end

@implementation EBPositionsCollectionViewController


- (void)viewDidLoad {
    [super viewDidLoad];
        // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Reigster for notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPositionData:) name:@"PositionsReturnedFromServer" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTicketData:) name:@"TicketsReturnedFromServer" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCandidateData:) name:@"CandidatesReturnedFromServer" object:nil];
    
    self.positionDataReady = NO;
    self.ticketDataReady = NO;
    self.candidateDataReady = NO;
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshPositionData:(NSNotification *)notification
{
    self.positions = (NSArray *)notification.userInfo[@"foundObjects"];
    self.positionDataReady = YES;
    [self.collectionView reloadData];
}

- (void)refreshTicketData:(NSNotification *)notification
{
    self.tickets = (NSArray *)notification.userInfo[@"foundObjects"];
    self.ticketDataReady = YES;
}

- (void)refreshCandidateData:(NSNotification *)notification
{
    self.candidates = (NSArray *)notification.userInfo[@"foundObjects"];
    self.candidateDataReady = YES;
}



#pragma mark - Navigation


-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"ShowCandidateFromPosition"] && self.positionDataReady && self.candidateDataReady && self.ticketDataReady) {
        return YES;
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Data not ready" message:@"Please wait while we are getting data from the server." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
        return NO;
    }
}



// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowCandidateFromPosition"]) {
        EBCandidateTableViewController *tvc = (EBCandidateTableViewController *)[segue destinationViewController];
        tvc.candidateFilter = EBCandidateFilterByPosition;
        tvc.candidateViewType = EBCandidateViewTypePositionProfile;
        EBFeedCollectionViewCell *cell = (EBFeedCollectionViewCell *)sender;
        tvc.filterId = [cell.data[@"id"] intValue];
        tvc.filterTitle = cell.titleLabel.text;
        tvc.candidates = self.candidates;
        tvc.tickets = self.tickets;
        tvc.positions = self.positions;
    }

}


#pragma mark <UICollectionViewDataSource>

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.positions count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EBFeedCollectionViewCell *cell;
    NSDictionary *dict;
    dict = @{@"imageName": [NSString stringWithFormat:@"photo%ld.jpg", (long)indexPath.item],
             @"title": self.positions[indexPath.item][@"name"],
             @"id": self.positions[indexPath.item][@"positionId"],
             @"date": @"",
             @"priority": @(0),
             @"hasImage": @"true"};
    
    
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FeedCell" forIndexPath:indexPath];
    
    cell.index = indexPath.item;
    cell.data = dict;
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    [cell setup];
    
    
    return cell;
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellWidth = ([EBHelper getScreenSize].width - 3 * SPACING_FEED) / 2;
    return CGSizeMake(cellWidth, cellWidth);
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
