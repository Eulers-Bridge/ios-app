//
//  EBContentViewController.m
//  Isegoria
//
//  Created by Alan Gao on 27/07/2015.
//  Copyright (c) 2015 Eulers Bridge. All rights reserved.
//

#import "EBContentViewController.h"
#import "EBArticleViewController.h"
#import "EBEventDetailTableViewController.h"
#import "EBProfileDescriptionViewController.h"
#import "EBNetworkService.h"
#import "UIImageView+AFNetworking.h"
#import "EBHelper.h"
#import "EBContentDetail.h"

@interface EBContentViewController () <UIScrollViewDelegate, EBSignupServiceDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet EBBlurImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *centerImageView;
@property (weak, nonatomic) IBOutlet EBLabelLight *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *institutionLabel;

@property (strong, nonatomic) UIViewController *contentViewController;

@end

@implementation EBContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.centerImageView.hidden = YES;
    self.nameLabel.hidden = YES;
    self.institutionLabel.hidden = YES;
    
    self.contentScrollView.delegate = self;
    self.contentScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 1);
    self.loadingIndicator.hidden = YES;
    // Load content view
    [self loadContentView];
    
    
}


- (void)loadContentView
{
    // Pass information to content views
    
    if (self.contentViewType == EBContentViewTypeNews) {
        
        self.titleLabel.text = self.data[@"title"];
        [self getImageFromServer];
        self.navigationItem.title = @"News";

        EBArticleViewController *articleVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ArticleViewController"];
        [self setupDetailViewController:articleVC];
        [self getAuthorDetailWithEmail:self.data[@"creatorEmail"]];
        

    } else if (self.contentViewType == EBContentViewTypeEvent) {
        
        self.titleLabel.text = self.data[@"title"];
        [self getImageFromServer];
        self.navigationItem.title = @"Event";
        EBEventDetailTableViewController *eventVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EventViewController"];
        self.contentViewController = eventVC;
        [self addChildViewController:eventVC];
        [eventVC didMoveToParentViewController:self];
        [self.contentScrollView addSubview:eventVC.view];
        [eventVC setupData:self.data];
        eventVC.view.frame = CGRectMake(0, self.imageView.frame.size.height, eventVC.view.frame.size.width, eventVC.view.frame.size.height - self.imageView.frame.size.height);
        
        self.contentScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.imageView.frame.size.height + eventVC.view.frame.size.height);
        
    } else if (self.contentViewType == EBContentViewTypeCandidateDescription) {
        self.titleLabel.hidden = YES;
        self.centerImageView.hidden = NO;
        self.nameLabel.hidden = NO;
        self.institutionLabel.hidden = NO;
        
        self.navigationItem.title = @"Profile";
        
        self.imageView.image = self.image;
        self.centerImageView.image = self.image;
        self.nameLabel.text = [EBHelper fullNameWithUserObject:self.data];
        
        EBProfileDescriptionViewController *profileDesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileDescriptionView"];
        [self setupDetailViewController:profileDesVC];
        
    }
    // Receive content size information
    // Set scroll view content size
}

- (void)setupDetailViewController:(UIViewController <EBContentDetail> *)detailVC
{
    
    self.contentViewController = detailVC;
    [self addChildViewController:detailVC];
    [detailVC didMoveToParentViewController:self];
    [self.contentScrollView addSubview:detailVC.view];
    [detailVC setupData:self.data];
    detailVC.view.frame = CGRectMake(0, self.imageView.frame.size.height, detailVC.view.frame.size.width, detailVC.view.frame.size.height);
    
    self.contentScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.imageView.frame.size.height + detailVC.view.frame.size.height);
}

- (void)getImageFromServer
{
    NSURL *url = [NSURL URLWithString:self.data[@"imageUrl"]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    [self.imageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"%@", error);
    }];

}

- (void)getAuthorDetailWithEmail:(NSString *)email
{
    EBNetworkService *service = [[EBNetworkService alloc] init];
    service.signupDelegate = self;
    [service getUserWithUserEmail:email];
}

- (void)getUserWithUserEmailFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error
{
    if (success) {
        if (self.contentViewType == EBContentViewTypeNews) {
            EBArticleViewController *articleVC = (EBArticleViewController *)self.contentViewController;
            [articleVC setupAuthorData:info];
        }
    } else {
        
    }
}


#pragma mark Scroll View Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.contentScrollView) {
        CGRect frame = self.imageView.frame;
        if (scrollView.contentOffset.y > -64) {
            frame.origin.y = (scrollView.contentOffset.y + 64) * 0.2;
        } else {
            frame.origin.y = (scrollView.contentOffset.y + 64);
            frame.size.height = -(scrollView.contentOffset.y + 64) + 229;
            CGFloat newBlurRadius = (DEFAULT_BLUR_RADIUS + (scrollView.contentOffset.y + 64) * DEFAULT_BLUR_RADIUS / 206);
            if (newBlurRadius < 0.1) {
                newBlurRadius = 0.1;
            }
//            NSLog(@"%f",newBlurRadius);
            [self.imageView setImage:[self.image copy] withBlurRadius:newBlurRadius];
//            NSLog(@"%f",scrollView.contentOffset.y);
        }
        self.imageView.frame = frame;
    }
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
