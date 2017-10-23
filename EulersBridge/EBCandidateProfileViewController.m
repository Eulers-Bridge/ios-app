//
//  EBCandidateProfileViewController.m
//  Isegoria
//
//  Created by Alan Gao on 26/06/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBCandidateProfileViewController.h"
#import "EBFriendProfileViewController.h"
#import "EBBlurImageView.h"
#import "EBHelper.h"
#import "MyConstants.h"
#import "UIImageView+AFNetworking.h"

@interface EBCandidateProfileViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet EBBlurImageView *backgroundPhoto;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *profilePhoto;
@property (weak, nonatomic) IBOutlet EBLabelLight *nameLabel;
@property (weak, nonatomic) IBOutlet EBLabelHeavy *institutionLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *detailScrollView;
@property (weak, nonatomic) IBOutlet EBTextViewGentium *textView;

@end

@implementation EBCandidateProfileViewController

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
    [self.backgroundPhoto setImageWithURL:[NSURL URLWithString:self.imageUrl]];
    [self.profilePhoto setImageWithURL:[NSURL URLWithString:self.imageUrl]];
    self.nameLabel.text = self.name;
    self.navigationItem.title = self.name;
    
    
    CGSize size = [self.textView sizeThatFits:CGSizeMake([EBHelper getScreenSize].width, 200)];
    self.textView.frame = CGRectMake(0.0,
                                     self.backgroundPhoto.bounds.size.height + self.headerView.bounds.size.height,
                                     [EBHelper getScreenSize].width,
                                     size.height);
    
    self.detailScrollView.contentSize = CGSizeMake([EBHelper getScreenSize].width,
                                                   self.backgroundPhoto.bounds.size.height + self.textView.frame.size.height + self.headerView.bounds.size.height);
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Scroll View Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGRect frame = self.backgroundPhoto.frame;
    if (scrollView.contentOffset.y > 0) {
        frame.origin.y = (scrollView.contentOffset.y + 0) * 0.2;
    } else {
        frame.origin.y = (scrollView.contentOffset.y + 0);
        frame.size.height = -(scrollView.contentOffset.y + 0) + 233;
    }
    self.backgroundPhoto.frame = frame;
    
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"viewFullProfile"]) {
        EBFriendProfileViewController *dest = (EBFriendProfileViewController *)[segue destinationViewController];
        dest.name = self.name;
        dest.imageUrl = self.imageUrl;
    }
}


@end
