//
//  EBElectionPositionDataSource.m
//  Isegoria
//
//  Created by Alan Gao on 6/06/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBElectionPositionsDataSource.h"
#import "EBFeedCollectionViewCell.h"
#import "EBElectionPositionDetailViewController.h"

@implementation EBElectionPositionsDataSource

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.positions = @[@{@"id": @"0",
                             @"title": @"President",
                             @"description": @"The president sets policy and governs the party direction. While the president is the leader of a party, they still need the support of their peers to enact change."},
                           @{@"id": @"1",
                             @"title": @"Secretary",
                             @"description": @"The secretary’s role is to ensure the smooth functioning of the organisation’s activities and undertakings through their term."},
                           @{@"id": @"2",
                             @"title": @"Women’s Officer",
                             @"description": @"The Women’s officer tends to the needs of the female-gendered."},
                           @{@"id": @"3",
                             @"title": @"Queer Officer",
                             @"description": @"The Queer officer looks out for the LGBT community at The University of Melbourne."},
                           @{@"id": @"4",
                             @"title": @"Clubs and Societies",
                             @"description": @"Responsible for managing the large number of clubs and societies at The University of Melbourne."},
                           @{@"id": @"5",
                             @"title": @"Environmental Officer",
                             @"description": @"Is responsible for all environmental concerns of the student body, including bore water usage, solar initiatives and proper management of university environmental assets."},
                           @{@"id": @"6",
                             @"title": @"Welfare Officer",
                             @"description": @"The Welfare Officer manages as the aspects of pastoral care from UMSU’s end, often acting as a medium and speaking on behalf of disadvantaged students."},
                           @{@"id": @"7",
                             @"title": @"Creative Arts Officer",
                             @"description": @"The creative Arts Officer is response for all major art installations and projects on campus."},
                           @{@"id": @"8",
                             @"title": @"Faculty Liaison",
                             @"description": @"Each faculty sends a liaison to UMSU to stand for their interests and act as a messenger for the student body. There are a number of roles, generally one for each faculty."},
                           ];
    }
    return self;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.positions count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EBFeedCollectionViewCell *cell;
    NSDictionary *dict;
    dict = @{@"imageName": [NSString stringWithFormat:@"photo%ld.jpg", (long)indexPath.item],
             @"title": self.positions[indexPath.item][@"title"],
             @"id": self.positions[indexPath.item][@"id"],
             @"date": @"",
             @"priority": @(0)};
    

    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FeedCell" forIndexPath:indexPath];
    
    cell.index = indexPath.row;
    cell.data = dict;
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    [cell setup];
    
    
    return cell;
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(150.0, 150.0);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowPositionDetail"]) {
        EBFeedCollectionViewCell *cell = (EBFeedCollectionViewCell *)sender;
        EBElectionPositionDetailViewController *detail = (EBElectionPositionDetailViewController *)[segue destinationViewController];
        detail.titleLabel.text = self.positions[cell.index][@"title"];
        detail.descriptionTextView.text = self.positions[cell.index][@"description"];
    }
}


@end
