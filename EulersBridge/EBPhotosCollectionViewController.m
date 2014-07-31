//
//  EBPhotosCollectionViewController.m
//  Isegoria
//
//  Created by Alan Gao on 31/07/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBPhotosCollectionViewController.h"
#import "EBPhotosHeaderView.h"
#import "EBPhotoDetailViewController.h"

@interface EBPhotosCollectionViewController ()

@end

@implementation EBPhotosCollectionViewController

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

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.data[@"numberOfPhotos"] intValue];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCollectionCell" forIndexPath:indexPath];
    
    NSString *imageName = [NSString stringWithFormat:@"%@%ld.jpg",self.data[@"prefix"], (long)indexPath.item + 1];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 78, 78)];
    imageView.image = [UIImage imageNamed:imageName];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.backgroundColor = [UIColor whiteColor];
    [cell.contentView addSubview:imageView];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    EBPhotosHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"PhotoHeader" forIndexPath:indexPath];
    header.titleLabel.text = self.data[@"title"];
    header.subtitleLabel.text = self.data[@"date"];
    header.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"idx%ld.jpg", (long)self.index + 1]];
    return header;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showFullImage"]) {
        NSString *imageName = [NSString stringWithFormat:@"%@%ld.jpg",self.data[@"prefix"], (long)[self.collectionView indexPathForCell:sender].item + 1];
        
        EBPhotoDetailViewController *photovc = (EBPhotoDetailViewController *)segue.destinationViewController;
        photovc.imageName = imageName;
        photovc.titleName = self.data[@"title"];
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end