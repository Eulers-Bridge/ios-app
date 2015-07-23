//
//  EBBadgesCollectionViewController.m
//  Isegoria
//
//  Created by Alan Gao on 26/06/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBBadgesCollectionViewController.h"
#import "EBBadgeCollectionViewCell.h"
#import "EBNetworkService.h"

@interface EBBadgesCollectionViewController () <EBContentServiceDelegate>

@end

@implementation EBBadgesCollectionViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return [self.completedBadges count];
    } else if (section == 1) {
        return [self.remainingBadges count];
    }
    return 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.badgesViewType == EBBadgesViewTypeDetail) {
        EBBadgeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"badgeCellDetail" forIndexPath:indexPath];
        if (indexPath.section == 0) {
            cell.info = self.completedBadges[indexPath.item];
        } else if (indexPath.section == 1) {
            cell.info = self.remainingBadges[indexPath.item];
        }
        [cell setup];
        return cell;
    }
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"badgeCellMedium" forIndexPath:indexPath];
    NSString *imageName = [NSString stringWithFormat:@"badge%ld%@",(long)indexPath.item,
                           self.badgesViewType == EBBadgesViewTypeSmall ? @"m" : @"l"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    imageView.contentMode = UIViewContentModeCenter;
    imageView.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:imageView];
    return cell;
}


- (void)getBadgeIcons
{
    EBNetworkService *service = [[EBNetworkService alloc] init];
    service.contentDelegate = self;
    for (NSDictionary *badge in self.completedBadges) {
        [service getPhotosWithAlbumId:badge[@"badgeId"]];
    }
    for (NSDictionary *badge in self.remainingBadges) {
        [service getPhotosWithAlbumId:badge[@"badgeId"]];
    }
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
