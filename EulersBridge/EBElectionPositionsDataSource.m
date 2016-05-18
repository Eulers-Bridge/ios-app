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
#import "EBHelper.h"

@implementation EBElectionPositionsDataSource

- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.positions = @[@{@"id": @"0",
//                             @"title": @"President",
//                             @"description": @"The president sets policy and governs the party direction. While the president is the leader of a party, they still need the support of their peers to enact change."},
//                           @{@"id": @"1",
//                             @"title": @"Secretary",
//                             @"description": @"The secretary’s role is to ensure the smooth functioning of the organisation’s activities and undertakings through their term."},
//                           @{@"id": @"2",
//                             @"title": @"Women’s Officer",
//                             @"description": @"The Women’s officer tends to the needs of the female-gendered."},
//                           @{@"id": @"3",
//                             @"title": @"LGBT Officer",
//                             @"description": @"The LGBT officer looks out for the LGBT community at The University of Melbourne."},
//                           @{@"id": @"4",
//                             @"title": @"Clubs and Societies",
//                             @"description": @"Responsible for managing the large number of clubs and societies at The University of Melbourne."},
//                           @{@"id": @"5",
//                             @"title": @"Environmental Officer",
//                             @"description": @"Is responsible for all environmental concerns of the student body, including bore water usage, solar initiatives and proper management of university environmental assets."},
//                           @{@"id": @"6",
//                             @"title": @"Welfare Officer",
//                             @"description": @"The Welfare Officer manages as the aspects of pastoral care from UMSU’s end, often acting as a medium and speaking on behalf of disadvantaged students."},
//                           @{@"id": @"7",
//                             @"title": @"Creative Arts Officer",
//                             @"description": @"The creative Arts Officer is response for all major art installations and projects on campus."},
//                           @{@"id": @"8",
//                             @"title": @"Faculty Liaison",
//                             @"description": @"Each faculty sends a liaison to UMSU to stand for their interests and act as a messenger for the student body. There are a number of roles, generally one for each faculty."},
//                           ];
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
             @"title": self.positions[indexPath.item][@"name"],
             @"id": self.positions[indexPath.item][@"positionId"],
             @"date": @"",
             @"priority": @(0),
             @"hasImage": @"true"};
    

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
    CGFloat cellWidth = ([EBHelper getScreenSize].width - 3 * SPACING_FEED) / 2;
    return CGSizeMake(cellWidth, cellWidth);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowPositionDetail"]) {
        EBFeedCollectionViewCell *cell = (EBFeedCollectionViewCell *)sender;
        EBElectionPositionDetailViewController *detail = (EBElectionPositionDetailViewController *)[segue destinationViewController];
        detail.data = self.positions[cell.index];
    }
}

- (void)fetchData
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
            [service getPositionsInfoWithElectionId:electionId];
        }
        
    } else {
        
    }
}

-(void)getPositionsInfoFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error
{
    if (success) {
        self.positions = (NSArray *)info;
        [self.delegate electionPositionsFetchDataCompleteWithSuccess:success];
    } else {
        NSLog(@"%@", error);
    }
}

@end
