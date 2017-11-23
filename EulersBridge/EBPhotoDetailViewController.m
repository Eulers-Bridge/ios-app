//
//  EBPhotoDetailViewController.m
//  Isegoria
//
//  Created by Alan Gao on 31/07/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBPhotoDetailViewController.h"
#import "EBHelper.h"
#import "MyConstants.h"
#import "UIImageView+AFNetworking.h"
#import "EBNetworkService.h"
#import "EBUserService.h"

@interface EBPhotoDetailViewController () <UIScrollViewDelegate, EBContentServiceDelegate, EBUserActionServiceDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *photoScrollView;
@property (weak, nonatomic) IBOutlet EBLabelLight *likesLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;



@property NSString *prefix;
@property CGPoint lastContentOffset;
@property BOOL liked;

@end

@implementation EBPhotoDetailViewController

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
    self.liked = NO;
    self.prefix = self.data[@"prefix"];
    CGFloat width = [EBHelper getScreenSize].width;
    CGFloat height = [EBHelper getScreenSize].height;

    self.photoScrollView.bounds = CGRectMake(0, 0, width + SPACING_PHOTO_DETAIL, height);
    self.photoScrollView.frame = CGRectMake(0, 0, width + SPACING_PHOTO_DETAIL, height);
    self.photoScrollView.contentSize = CGSizeMake(width * 3 + 3 * SPACING_PHOTO_DETAIL, height);
    [self.photoScrollView setContentOffset:CGPointMake(width + SPACING_PHOTO_DETAIL, 0)];
    self.photoScrollView.delegate = self;
    
    self.leftPhotoScrollView.frame = CGRectMake(0, 0, width, height);
    self.centrePhotoScrollView.frame = CGRectMake(width + SPACING_PHOTO_DETAIL, 0, width, height);
    self.rightPhotoScrollView.frame = CGRectMake(width * 2 + SPACING_PHOTO_DETAIL * 2, 0, width, height);
    
    self.leftPhotoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    self.photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    self.rightPhotoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    
    self.leftPhotoImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.photoImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.rightPhotoImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.leftPhotoScrollView addSubview:self.leftPhotoImageView];
    [self.centrePhotoScrollView addSubview:self.photoImageView];
    [self.rightPhotoScrollView addSubview:self.rightPhotoImageView];
    
    self.leftPhotoScrollView.contentSize = CGSizeMake(width, height);
    self.centrePhotoScrollView.contentSize = CGSizeMake(width, height);
    self.rightPhotoScrollView.contentSize = CGSizeMake(width, height);
    
    self.leftPhotoScrollView.delegate = self;
    self.centrePhotoScrollView.delegate = self;
    self.rightPhotoScrollView.delegate = self;
    
    [self setupPhotos];
    [self updateData];
    self.lastContentOffset = self.photoScrollView.contentOffset;
    
    
}

- (void)setupPhotos
{
    UIImage *placeholder = [UIImage imageNamed:@"ImagePlaceholder"];
    // Corner case
    if (self.numberOfPhotos < 3) {
        self.photoScrollView.contentSize = CGSizeMake([EBHelper getScreenSize].width * self.numberOfPhotos + SPACING_PHOTO_DETAIL, [EBHelper getScreenSize].height);
    }
    
    // first photo selected
    if (self.index == 0) {
        [self.photoScrollView setContentOffset:CGPointMake(0, 0)];
        NSString *imageUrl = self.photoDataList[self.index][@"url"];
        [self.leftPhotoImageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:placeholder];
//        self.leftPhotoImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%ld.jpg", self.prefix, (long)self.index + 1]];
        if (self.numberOfPhotos > 1) {
            NSString *imageUrl1 = self.photoDataList[self.index + 1][@"url"];
            [self.photoImageView setImageWithURL:[NSURL URLWithString:imageUrl1] placeholderImage:placeholder];
//            self.photoImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%ld.jpg", self.prefix, (long)self.index + 2]];
        }
        if (self.numberOfPhotos > 2) {
            NSString *imageUrl2 = self.photoDataList[self.index + 2][@"url"];
            [self.rightPhotoImageView setImageWithURL:[NSURL URLWithString:imageUrl2] placeholderImage:placeholder];
//            self.rightPhotoImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%ld.jpg", self.prefix, (long)self.index + 3]];
        }
    // last photo selected
    } else if (self.index + 1 == self.numberOfPhotos) {
        if (self.numberOfPhotos > 2) {
            NSString *imageUrl = self.photoDataList[self.index][@"url"];
            [self.rightPhotoImageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:placeholder];
            NSString *imageUrl1 = self.photoDataList[self.index - 1][@"url"];
            [self.photoImageView setImageWithURL:[NSURL URLWithString:imageUrl1] placeholderImage:placeholder];
            NSString *imageUrl2 = self.photoDataList[self.index - 2][@"url"];
            [self.leftPhotoImageView setImageWithURL:[NSURL URLWithString:imageUrl2] placeholderImage:placeholder];
//            self.rightPhotoImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%ld.jpg", self.prefix, (long)self.index + 1]];
//            self.photoImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%ld.jpg", self.prefix, (long)self.index]];
//            self.leftPhotoImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%ld.jpg", self.prefix, (long)self.index - 1]];
            [self.photoScrollView setContentOffset:CGPointMake([EBHelper getScreenSize].width * 2 + 2 * SPACING_PHOTO_DETAIL, 0)];
        } else {
            NSString *imageUrl = self.photoDataList[self.index][@"url"];
            [self.photoImageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:placeholder];
            NSString *imageUrl1 = self.photoDataList[self.index - 1][@"url"];
            [self.leftPhotoImageView setImageWithURL:[NSURL URLWithString:imageUrl1] placeholderImage:placeholder];
//            self.photoImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%ld.jpg", self.prefix, (long)self.index + 1]];
//            self.leftPhotoImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%ld.jpg", self.prefix, (long)self.index]];
            [self.photoScrollView setContentOffset:CGPointMake([EBHelper getScreenSize].width + SPACING_PHOTO_DETAIL, 0)];
        }
    // normal case
    } else {
        NSString *imageUrl = self.photoDataList[self.index - 1][@"url"];
        [self.leftPhotoImageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:placeholder];
        NSString *imageUrl1 = self.photoDataList[self.index][@"url"];
        [self.photoImageView setImageWithURL:[NSURL URLWithString:imageUrl1] placeholderImage:placeholder];
        NSString *imageUrl2 = self.photoDataList[self.index + 1][@"url"];
        [self.rightPhotoImageView setImageWithURL:[NSURL URLWithString:imageUrl2] placeholderImage:placeholder];
        
//        self.leftPhotoImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%ld.jpg", self.prefix, (long)self.index]];
//        self.photoImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%ld.jpg", self.prefix, (long)self.index + 1]];
//        self.rightPhotoImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%ld.jpg", self.prefix, (long)self.index + 2]];
    }
    [self fitImageView];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    UIImage *placeholder = [UIImage imageNamed:@"ImagePlaceholder"];
    if (scrollView == self.photoScrollView) {
        if (self.lastContentOffset.x != scrollView.contentOffset.x) {
        // Set content zoom scale to 1
            [self.leftPhotoScrollView setZoomScale:1.0 animated:NO];
            [self.centrePhotoScrollView setZoomScale:1.0 animated:NO];
            [self.rightPhotoScrollView setZoomScale:1.0 animated:NO];
        }
        
        if (self.lastContentOffset.x == scrollView.contentOffset.x) {
            return;
        } else if (scrollView.contentOffset.x + [EBHelper getScreenSize].width + SPACING_PHOTO_DETAIL == self.lastContentOffset.x) {
            // swipe left
            self.index -= 1;
            [self updateData];
            if (self.index == 0 || self.index + 2 == self.numberOfPhotos) {
                self.lastContentOffset = scrollView.contentOffset;
                return;
            } else {
                [self.photoScrollView setContentOffset:CGPointMake([EBHelper getScreenSize].width + SPACING_PHOTO_DETAIL, 0)];
                self.rightPhotoImageView.image = self.photoImageView.image;
                self.photoImageView.image = self.leftPhotoImageView.image;
                NSString *imageUrl = self.photoDataList[self.index - 1][@"url"];
                [self.leftPhotoImageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:placeholder];
//                self.leftPhotoImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%ld.jpg", self.prefix, (long)self.index]];
            }
        } else if (scrollView.contentOffset.x - ([EBHelper getScreenSize].width + SPACING_PHOTO_DETAIL) == self.lastContentOffset.x) {
            // swipe right
            self.index += 1;
            [self updateData];
            if (self.index + 1 == self.numberOfPhotos || self.index - 1 == 0) {
                self.lastContentOffset = scrollView.contentOffset;
                return;
            } else {
                [self.photoScrollView setContentOffset:CGPointMake([EBHelper getScreenSize].width + SPACING_PHOTO_DETAIL, 0)];
                self.leftPhotoImageView.image = self.photoImageView.image;
                self.photoImageView.image = self.rightPhotoImageView.image;
                NSString *imageUrl = self.photoDataList[self.index + 1][@"url"];
                [self.rightPhotoImageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:placeholder];
//                self.rightPhotoImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%ld.jpg", self.prefix, (long)self.index + 2]];
            }
        }
    }
    [self fitImageView];
   
}

- (void)updateData
{
    [self getLikes];
    self.likesLabel.text = [NSString stringWithFormat:@"%ld", [self.photoDataList[self.index][@"numOfLikes"] integerValue]];
    self.titleLabel.text = self.photoDataList[self.index][@"title"];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self.photoDataList[self.index][@"date"] integerValue] / 1000];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd MMMM yyyy, h:mm a"];
    NSString *dateAndTime = [dateFormatter stringFromDate:date];
    
    self.dateLabel.text = dateAndTime;
}

- (void)fitImageView
{
    // Reset the bounds
    CGRect bounds = CGRectMake(0, 0, [EBHelper getScreenSize].width, [EBHelper getScreenSize].height);
    self.leftPhotoImageView.bounds = bounds;
    self.photoImageView.bounds = bounds;
    self.rightPhotoImageView.bounds = bounds;
    
    CGSize leftSize = [self sizeForImageViewAfterResizing:self.leftPhotoImageView];
    CGSize centreSize = [self sizeForImageViewAfterResizing:self.photoImageView];
    CGSize rightSize = [self sizeForImageViewAfterResizing:self.rightPhotoImageView];
    
    CGRect leftBounds = self.leftPhotoImageView.bounds;
    CGRect centreBounds = self.photoImageView.bounds;
    CGRect rightBounds = self.rightPhotoImageView.bounds;
    
    leftBounds.size = leftSize;
    centreBounds.size = centreSize;
    rightBounds.size = rightSize;
    
    self.leftPhotoImageView.bounds = leftBounds;
    self.photoImageView.bounds = centreBounds;
    self.rightPhotoImageView.bounds = rightBounds;
    
}

- (CGSize)sizeForImageViewAfterResizing:(UIImageView *)imageView
{
    CGFloat widthRatio = imageView.bounds.size.width / imageView.image.size.width;
    CGFloat heightRatio = imageView.bounds.size.height / imageView.image.size.height;
    CGFloat scale = MIN(widthRatio, heightRatio);
    CGFloat imageWidth = scale * imageView.image.size.width;
    CGFloat imageHeight = scale * imageView.image.size.height;
    return CGSizeMake(imageWidth, imageHeight);
}


-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    // change to return the current photo
    if (scrollView != self.photoScrollView) {
        return scrollView.subviews[0];
    }
    return nil;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Set zoom scale to 1
    
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    UIView *subView = [scrollView.subviews objectAtIndex:0];
    
    CGFloat offsetX = MAX((scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5, 0.0);
    CGFloat offsetY = MAX((scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5, 0.0);
    
    subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
}

// Likes

- (void)getLikes
{
    self.likeButton.enabled = NO;
    EBNetworkService *service = [[EBNetworkService alloc] init];
    service.contentDelegate = self;
    [service getPhotoLikesWithPhotoId:self.photoDataList[self.index][@"nodeId"]];
}

-(void)getPhotoLikesFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error
{
    if (success) {
        self.likesLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)((NSArray *)info).count];
        BOOL found = NO;
        for (NSDictionary *like in info) {
            if ([like[@"email"] isEqualToString:[EBUserService retriveUserEmail]]) {
                self.liked = YES;
                found = YES;
                break;
            }
        }
        if (found == NO) {
            self.liked = NO;
        }
    } else {
        
    }
    self.likeButton.enabled = YES;
}

- (IBAction)like:(id)sender
{
    self.likeButton.enabled = NO;
    EBNetworkService *service = [[EBNetworkService alloc] init];
    service.userActionDelegate = self;
    [service likeContentWithLike:!self.liked contentType:EBContentViewTypePhoto contentId:self.photoDataList[self.index][@"nodeId"]];
}

-(void)likeContentFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error
{
    if (success) {
        [self getLikes];
    } else {
        
    }
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:ISEGORIA_DARK_GREY];
    [self.tabBarController.tabBar setHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBarTintColor:ISEGORIA_COLOR_BLUE];
    [self.tabBarController.tabBar setHidden:NO];
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
