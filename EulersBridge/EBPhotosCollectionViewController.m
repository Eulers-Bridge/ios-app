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
#import "EBHelper.h"
#import "EBNetworkService.h"
#import "MyConstants.h"
#import "UIImageView+AFNetworking.h"

@interface EBPhotosCollectionViewController () <EBContentServiceDelegate>

@property (nonatomic, strong) NSArray *photoDataList;

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
    self.photoDataList = [NSArray array];
    [self fetchData];
    // Do any additional setup after loading the view.
//    [self.collectionView setCollectionViewLayout:[[StickyHeaderFlowLayout alloc] init] animated:NO];
}

- (void)fetchData
{
    EBNetworkService *service = [[EBNetworkService alloc] init];
    service.contentDelegate = self;
    [service getPhotosWithAlbumId:self.data[@"albumId"]];
}

-(void)getPhotosFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error
{
    if (success) {
        self.photoDataList = info[@"photos"];
        [self.collectionView reloadData];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.photoDataList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCollectionCell" forIndexPath:indexPath];
    
    CGFloat width = ([EBHelper getScreenSize].width - 5 * SPACING_PHOTO_GRID) / 4;
    
//    NSString *imageName = [NSString stringWithFormat:@"%@%ld.jpg",self.data[@"prefix"], (long)indexPath.item + 1];
    NSString *imageThumbnailUrl = self.photoDataList[indexPath.item][@"url"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [imageView setImageWithURL:[NSURL URLWithString:imageThumbnailUrl] placeholderImage:[UIImage imageNamed:@"ImagePlaceholder"]];
//    dispatch_queue_t imageReader = dispatch_queue_create("Image Reader", NULL);
//    dispatch_async(imageReader, ^{
//        UIImage *image = [UIImage imageNamed:imageName]; // may take time to load
//        dispatch_async(dispatch_get_main_queue(), ^{
//            imageView.image = image;
//        });
//    });
    

    imageView.backgroundColor = [UIColor whiteColor];
    [cell.contentView addSubview:imageView];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    EBPhotosHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"PhotoHeader" forIndexPath:indexPath];
    header.titleLabel.text = self.data[@"title"];
    header.subtitleLabel.text = self.data[@"date"];
    NSString *imageThumbnailUrl = self.data[@"imageUrl"];
    [header.imageView setImageWithURL:[NSURL URLWithString:imageThumbnailUrl]];
    return header;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = ([EBHelper getScreenSize].width - 5 * SPACING_PHOTO_GRID) / 4;
    return CGSizeMake(width, width);
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showFullImage"]) {
        
        EBPhotoDetailViewController *photovc = (EBPhotoDetailViewController *)segue.destinationViewController;
        photovc.index = [self.collectionView indexPathForCell:sender].item;
        photovc.titleName = self.data[@"title"];
        photovc.numberOfPhotos = [self.photoDataList count];
        photovc.data = self.data;
        photovc.photoDataList = self.photoDataList;
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
