//
//  EBFriendProfileViewController.m
//  Isegoria
//
//  Created by Alan Gao on 26/06/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBFriendProfileViewController.h"
#import "EBBadgesCollectionViewController.h"
#import "MyConstants.h"
#import "UIImageView+AFNetworking.h"

@interface EBFriendProfileViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet EBBlurImageView *backgroundPhoto;
@property (weak, nonatomic) IBOutlet UIImageView *profilePhoto;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *institutionLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *detailScrollView;


@end

@implementation EBFriendProfileViewController

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
    [self.backgroundPhoto setImageWithURL:[NSURL URLWithString:self.imageUrl]];
    [self.profilePhoto setImageWithURL:[NSURL URLWithString:self.imageUrl]];
    self.nameLabel.text = self.name;
    self.navigationItem.title = self.name;
    
    self.detailScrollView.contentSize = CGSizeMake(WIDTH_OF_SCREEN, 600);
    
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
    
//    if (scrollView == self.detailScrollView) {
//        CGRect frame = self.backgroundPhoto.frame;
//        if (scrollView.contentOffset.y > -64) {
//            frame.origin.y = (scrollView.contentOffset.y + 64) * 0.2;
//        } else {
//            frame.origin.y = (scrollView.contentOffset.y + 64);
//            frame.size.height = -(scrollView.contentOffset.y + 64) + 229;
//        }
//        self.backgroundPhoto.frame = frame;
//    }
    
    CGRect frame = self.backgroundPhoto.frame;
    if (scrollView.contentOffset.y > 0) {
        frame.origin.y = (scrollView.contentOffset.y + 0) * 0.2;
    } else {
        frame.origin.y = (scrollView.contentOffset.y + 0);
        frame.size.height = -(scrollView.contentOffset.y + 0) + 288;
    }
    self.backgroundPhoto.frame = frame;
    
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
     if ([segue.identifier isEqualToString:@"BadgesEmbed"]) {
     EBBadgesCollectionViewController *badgesViewController = (EBBadgesCollectionViewController *)[segue destinationViewController];
     badgesViewController.badgesViewType = EBBadgesViewTypeLarge;
     }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
