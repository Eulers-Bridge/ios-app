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
#import "EBBlurImageView.h"
#import "EBBadgesCollectionViewController.h"
#import "EBTasksTableViewController.h"
#import "EBProfileSettingsViewController.h"

@interface EBProfileViewController () <ABPeoplePickerNavigationControllerDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet EBBlurImageView *imageView;
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

@property (weak, nonatomic) IBOutlet UIView *darkBackgroundView;




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
    self.badgesLabel.font = [UIFont fontWithName:@"MuseoSansRounded-700" size:self.badgesLabel.font.pointSize];
    self.tasksLabel.font = [UIFont fontWithName:@"MuseoSansRounded-700" size:self.tasksLabel.font.pointSize];
    self.sampleTaskLabel.font = [UIFont fontWithName:@"MuseoSansRounded-500" size:self.sampleTaskLabel.font.pointSize];
    self.sampleXPLabel.font = [UIFont fontWithName:@"MuseoSansRounded-500" size:self.sampleXPLabel.font.pointSize];
    
    
    // Image setup
    self.profileImageView.image = [UIImage imageNamed:@"julia-gillard-data.jpg"];
    self.imageView.image = [UIImage imageNamed:@"julia-gillard-data.jpg"];
    self.scrollView.contentSize = CGSizeMake(WIDTH_OF_SCREEN, 665.0);
    
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
    
    
    
    CGRect frame = self.imageView.frame;
    if (scrollView.contentOffset.y > 0) {
        frame.origin.y = (scrollView.contentOffset.y + 0) * 0.2;
    } else {
        frame.origin.y = (scrollView.contentOffset.y + 0);
        frame.size.height = -(scrollView.contentOffset.y + 0) + 288;
    }
    self.imageView.frame = frame;

}






- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"BadgesEmbed"]) {
        EBBadgesCollectionViewController *badgesViewController = (EBBadgesCollectionViewController *)[segue destinationViewController];
        badgesViewController.badgesViewType = EBBadgesViewTypeSmall;
    }
    if ([segue.identifier isEqualToString:@"BadgesDetail"]) {
        EBBadgesCollectionViewController *badgesViewController = (EBBadgesCollectionViewController *)[segue destinationViewController];
        badgesViewController.badgesViewType = EBBadgesViewTypeDetail;
    }
    if ([segue.identifier isEqualToString:@"ProfileSettings"]) {
        EBProfileSettingsViewController *settingsViewController = (EBProfileSettingsViewController *)[segue destinationViewController];
        
    }
    if ([segue.identifier isEqualToString:@"TasksEmbed"]) {
        EBTasksTableViewController *tasksViewController = (EBTasksTableViewController *)[segue destinationViewController];
        tasksViewController.tasksViewType = EBTasksViewTypeSmall;
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
