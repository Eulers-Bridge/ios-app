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

@interface EBPhotoDetailViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *photoScrollView;
@property int numberOfPhotos;
@property NSString *prefix;
@property CGPoint lastContentOffset;

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
    
    self.numberOfPhotos = [self.data[@"numberOfPhotos"] intValue];
    self.prefix = self.data[@"prefix"];
    
    self.titleLabel.text = self.titleName;
    self.photoScrollView.contentSize = CGSizeMake([EBHelper getScreenSize].width * 3, [EBHelper getScreenSize].height);
    [self.photoScrollView setContentOffset:CGPointMake([EBHelper getScreenSize].width, 0)];
    self.photoScrollView.delegate = self;
    
    CGFloat width = [EBHelper getScreenSize].width;
    CGFloat height = [EBHelper getScreenSize].height;
    
    self.leftPhotoImageView.frame = CGRectMake(0, 0, width, height);
    self.photoImageView.frame = CGRectMake(width, 0, width, height);
    self.rightPhotoImageView.frame = CGRectMake(width * 2, 0, width, height);
    
    [self setupPhotos];
    self.lastContentOffset = self.photoScrollView.contentOffset;
    
    
}

- (void)setupPhotos
{
    // Corner case
    if (self.numberOfPhotos < 3) {
        self.photoScrollView.contentSize = CGSizeMake([EBHelper getScreenSize].width * self.numberOfPhotos, [EBHelper getScreenSize].height);
    }
    
    // first photo selected
    if (self.index == 0) {
        [self.photoScrollView setContentOffset:CGPointMake(0, 0)];
        self.leftPhotoImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%ld.jpg", self.prefix, (long)self.index + 1]];
        if (self.numberOfPhotos > 1) {
            self.photoImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%ld.jpg", self.prefix, (long)self.index + 2]];
        }
        if (self.numberOfPhotos > 2) {
            self.rightPhotoImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%ld.jpg", self.prefix, (long)self.index + 3]];
        }
    // last photo selected
    } else if (self.index + 1 == self.numberOfPhotos) {
        if (self.numberOfPhotos > 2) {
            self.rightPhotoImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%ld.jpg", self.prefix, (long)self.index + 1]];
            self.photoImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%ld.jpg", self.prefix, (long)self.index]];
            self.leftPhotoImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%ld.jpg", self.prefix, (long)self.index - 1]];
            [self.photoScrollView setContentOffset:CGPointMake([EBHelper getScreenSize].width * 2, 0)];
        } else {
            self.photoImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%ld.jpg", self.prefix, (long)self.index + 1]];
            self.leftPhotoImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%ld.jpg", self.prefix, (long)self.index]];
            [self.photoScrollView setContentOffset:CGPointMake([EBHelper getScreenSize].width, 0)];
        }
    // normal case
    } else {
        self.leftPhotoImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%ld.jpg", self.prefix, (long)self.index]];
        self.photoImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%ld.jpg", self.prefix, (long)self.index + 1]];
        self.rightPhotoImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%ld.jpg", self.prefix, (long)self.index + 2]];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.lastContentOffset.x == scrollView.contentOffset.x) {
        return;
    } else if (scrollView.contentOffset.x + [EBHelper getScreenSize].width == self.lastContentOffset.x) {
        // swipe left
        self.index -= 1;
        if (self.index == 0 || self.index + 2 == self.numberOfPhotos) {
            self.lastContentOffset = scrollView.contentOffset;
            return;
        } else {
            [self.photoScrollView setContentOffset:CGPointMake([EBHelper getScreenSize].width, 0)];
            self.rightPhotoImageView.image = self.photoImageView.image;
            self.photoImageView.image = self.leftPhotoImageView.image;
            self.leftPhotoImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%ld.jpg", self.prefix, (long)self.index]];
        }
    } else if (scrollView.contentOffset.x - [EBHelper getScreenSize].width == self.lastContentOffset.x) {
        // swipe right
        self.index += 1;
        if (self.index + 1 == self.numberOfPhotos || self.index - 1 == 0) {
            self.lastContentOffset = scrollView.contentOffset;
            return;
        } else {
            [self.photoScrollView setContentOffset:CGPointMake([EBHelper getScreenSize].width, 0)];
            self.leftPhotoImageView.image = self.photoImageView.image;
            self.photoImageView.image = self.rightPhotoImageView.image;
            self.rightPhotoImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%ld.jpg", self.prefix, (long)self.index + 2]];
        }
    }
    
   
}


-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    // change to return the current photo
    return nil;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Set zoom scale to 1
    
}

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    
}
//-(BOOL)hidesBottomBarWhenPushed
//{
//    return YES;
//}

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
