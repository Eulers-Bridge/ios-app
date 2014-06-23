//
//  EBProfileViewController.m
//  EulersBridge
//
//  Created by Alan Gao on 27/04/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBProfileViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "UIImage+ImageEffects.h"

@interface EBProfileViewController () <ABPeoplePickerNavigationControllerDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *uniNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numOfFriendsLabel;
@property (weak, nonatomic) IBOutlet UILabel *numOfXPLabel;

@property (weak, nonatomic) IBOutlet UILabel *friendsLabel;
@property (weak, nonatomic) IBOutlet UILabel *XPLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *badgesLabel;
@property (weak, nonatomic) IBOutlet UILabel *tasksLabel;
@property (weak, nonatomic) IBOutlet UILabel *sampleTaskLabel;
@property (weak, nonatomic) IBOutlet UILabel *sampleXPLabel;

@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (weak, nonatomic) IBOutlet UIButton *showBadges;
@property (weak, nonatomic) IBOutlet UIButton *showTasks;




@end

@implementation EBProfileViewController

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
    // Font setup
    self.nameLabel.font = [UIFont fontWithName:@"MuseoSansRounded-100" size:self.nameLabel.font.pointSize];
    self.uniNameLabel.font = [UIFont fontWithName:@"MuseoSansRounded-700" size:self.uniNameLabel.font.pointSize];
    self.numOfFriendsLabel.font = [UIFont fontWithName:@"MuseoSansRounded-100" size:self.numOfFriendsLabel.font.pointSize];
    self.numOfXPLabel.font = [UIFont fontWithName:@"MuseoSansRounded-100" size:self.numOfXPLabel.font.pointSize];
    self.friendsLabel.font = [UIFont fontWithName:@"MuseoSansRounded-500" size:self.friendsLabel.font.pointSize];
    self.XPLevelLabel.font = [UIFont fontWithName:@"MuseoSansRounded-500" size:self.XPLevelLabel.font.pointSize];
    self.badgesLabel.font = [UIFont fontWithName:@"MuseoSansRounded-700" size:self.badgesLabel.font.pointSize];
    self.tasksLabel.font = [UIFont fontWithName:@"MuseoSansRounded-700" size:self.tasksLabel.font.pointSize];
    self.sampleTaskLabel.font = [UIFont fontWithName:@"MuseoSansRounded-500" size:self.sampleTaskLabel.font.pointSize];
    self.sampleXPLabel.font = [UIFont fontWithName:@"MuseoSansRounded-500" size:self.sampleXPLabel.font.pointSize];
    
    self.showBadges.titleLabel.font = [UIFont fontWithName:@"MuseoSansRounded-700" size:self.showBadges.titleLabel.font.pointSize];
    self.showTasks.titleLabel.font = [UIFont fontWithName:@"MuseoSansRounded-700" size:self.showBadges.titleLabel.font.pointSize];
    
    self.actionButton.titleLabel.font = [UIFont fontWithName:@"MuseoSansRounded-700" size:self.actionButton.titleLabel.font.pointSize];
    self.actionButton.titleLabel.textColor = [UIColor whiteColor];
    self.actionButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    // Image setup
    self.profileImageView.image = [UIImage imageNamed:@"selfHead.jpg"];
    self.imageView.image = [UIImage imageNamed:@"selfHeadBig.jpg"];
    UIColor *tintColor = [UIColor colorWithRed:51.0/255.0 green:56.0/255.0 blue:69.0/255.0 alpha:0.5];
    self.imageView.image = [self.imageView.image applyBlurWithRadius:20 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];


}







- (IBAction)inviteFriends:(UIButton *)sender
{
    ABPeoplePickerNavigationController *picker =
    [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
}


- (void)peoplePickerNavigationControllerDidCancel:
(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    
//    [self dismissViewControllerAnimated:YES completion:nil];

    
    return NO;
}

- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    return YES;
}





#pragma mark Scroll View Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y <= 0) {
        [scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        return;
    }
    CGRect frame = self.imageView.frame;
    frame.origin.y = scrollView.contentOffset.y * 0.2;
    self.imageView.frame = frame;
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
