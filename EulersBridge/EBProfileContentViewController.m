//
//  EBProfileContentViewController.m
//  Isegoria
//
//  Created by Alan Gao on 3/09/2015.
//  Copyright (c) 2015 Eulers Bridge. All rights reserved.
//

#import "EBProfileContentViewController.h"
#import "EBNetworkService.h"
#import "EBUserService.h"
#import "EBHelper.h"
#import "EBBadgesCollectionViewController.h"
#import "EBProfileSettingsViewController.h"
#import "EBTasksTableViewController.h"
#import "EBTasksDetailViewController.h"
#import "EBFriendsContentTableViewController.h"

@interface EBProfileContentViewController () <EBFriendServiceDelegate, EBUserServiceDelegate, EBContentServiceDelegate>

@property (weak, nonatomic) IBOutlet EBLabelHeavy *friendsLabel;
@property (weak, nonatomic) IBOutlet EBLabelHeavy *groupsLabel;
@property (weak, nonatomic) IBOutlet EBButtonRoundedHeavy *friendsButton;


@property (weak, nonatomic) IBOutlet EBCircleProgressBar *progressBar1;
@property (weak, nonatomic) IBOutlet EBCircleProgressBar *progressBar2;
@property (weak, nonatomic) IBOutlet EBCircleProgressBar *progressBar3;
@property (weak, nonatomic) IBOutlet EBCircleProgressBar *progressBar4;

@property (weak, nonatomic) IBOutlet EBLabelLight *completedBadgesLabel;
@property (weak, nonatomic) IBOutlet EBLabelHeavy *remainingBadgesLabel;


@property (strong, nonatomic) NSArray *completedBadges;
@property (strong, nonatomic) NSArray *remainingBadges;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *badgesLoadingIndicator;
@property (weak, nonatomic) IBOutlet UIButton *viewBadgesButton;

@property (strong, nonatomic) NSArray *tasks;
@property (weak, nonatomic) IBOutlet UIButton *showProgressButton;
@property (weak, nonatomic) IBOutlet EBLabelMedium *tasksLoadingLabel;
@property (weak, nonatomic) IBOutlet UIView *tasksContainerView;

@property (strong, nonatomic) NSArray *friends;

@property (strong, nonatomic) NSDictionary *data;
@property (strong, nonatomic) UIBarButtonItem *rightBarButton;

@end

@implementation EBProfileContentViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.rightBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Settings"] style:UIBarButtonItemStylePlain target:self action:@selector(showSettings)];
    self.parentViewController.navigationItem.rightBarButtonItem = self.rightBarButton;
    
    self.friendsButton.enabled = NO;
    self.viewBadgesButton.enabled = NO;
    self.badgesLoadingIndicator.hidden = YES;
    self.progressBar2.progress = 0.0;
    
    self.showProgressButton.enabled = NO;
    self.tasksContainerView.hidden = YES;
    
    [self loadUserData];
    [self loadGroupsData];
    
    // Get Badges and tasks
    [self getBadges];
    [self getTasks];

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.progressBar1 animate];
    [self.progressBar2 animate];
    [self.progressBar3 animate];
    [self.progressBar4 animate];
}

- (void)showSettings
{
    [self performSegueWithIdentifier:@"ShowSettings" sender:self];
}

- (void)setupData:(NSDictionary *)data
{
    self.data = data;
}

- (void)loadUserData
{
    EBNetworkService *service = [[EBNetworkService alloc] init];
    service.friendDelegate = self;
    [service getFriendsWithUserEmail:[EBUserService retriveUserEmail]];
}

-(void)getFriendsWithUserEmailFinishedWithSuccess:(BOOL)success withContacts:(NSArray *)contacts failureReason:(NSError *)error
{
    if (success) {
        self.friendsLabel.text = [NSString stringWithFormat:@"%ld", contacts.count];
        self.friends = contacts;
        self.friendsButton.enabled = YES;
    } else {
        
    }
}

- (void)loadGroupsData
{
    EBNetworkService *service = [[EBNetworkService alloc] init];
    service.userDelegate = self;
    [service getGroupsWithUserEmail:[EBUserService retriveUserEmail]];
}

-(void)getGroupsWithUserEmailFinishedWithSuccess:(BOOL)success withGroups:(NSArray *)groups failureReason:(NSError *)error
{
    if (success) {
        self.groupsLabel.text = [NSString stringWithFormat:@"%ld", groups.count];
    } else {
        
    }
}

#pragma mark Badges and Tasks

- (void)getBadges
{
    self.badgesLoadingIndicator.hidden = NO;
    [self.badgesLoadingIndicator startAnimating];
    self.completedBadgesLabel.hidden = YES;
    self.remainingBadgesLabel.hidden = YES;
    
    EBNetworkService *service = [[EBNetworkService alloc] init];
    service.contentDelegate = self;
    [service getCompleteBadgesWithUserId:[EBHelper getUserId]];
    [service getRemainingBadgesWithUserId:[EBHelper getUserId]];
}

- (void)getTasks
{
    EBNetworkService *service = [[EBNetworkService alloc] init];
    service.contentDelegate = self;
    [service getTasks];
}

-(void)getCompleteBadgesFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error
{
    if (success) {
        self.completedBadges = info[@"foundObjects"];
        [self updateBadges];
    } else {
        
    }
}

- (void)getRemainingBadgesFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error
{
    if (success) {
        self.remainingBadges = info[@"foundObjects"];
        [self updateBadges];
    }
}

- (void)getTasksFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error
{
    if (success) {
        self.tasks = info[@"foundObjects"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TasksReturnedFromServer" object:nil userInfo:info];
        [self updateTasks];
    }
}

- (void)updateBadges
{
    if (self.completedBadges && self.remainingBadges) {
        [self.badgesLoadingIndicator stopAnimating];
        self.badgesLoadingIndicator.hidden = YES;
        self.completedBadgesLabel.hidden = NO;
        self.remainingBadgesLabel.hidden = NO;
        self.progressBar2.progress = (float)[self.completedBadges count] / ((float)[self.completedBadges count] + (float)[self.remainingBadges count]);
        [self.progressBar2 animate];
        self.completedBadgesLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)[self.completedBadges count]];
        self.remainingBadgesLabel.text = [NSString stringWithFormat:@"/%lu", (unsigned long)[self.remainingBadges count]];;
        self.viewBadgesButton.enabled = YES;
    }
}

- (void)updateTasks
{
    if (self.tasks) {
        self.showProgressButton.enabled = YES;
        self.tasksLoadingLabel.hidden = YES;
        self.tasksContainerView.hidden = NO;
        
    }
}



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"BadgesEmbed"]) {
        EBBadgesCollectionViewController *badgesViewController = (EBBadgesCollectionViewController *)[segue destinationViewController];
        badgesViewController.badgesViewType = EBBadgesViewTypeSmall;
    }
    if ([segue.identifier isEqualToString:@"BadgesDetail"]) {
        EBBadgesCollectionViewController *badgesViewController = (EBBadgesCollectionViewController *)[segue destinationViewController];
        badgesViewController.badgesViewType = EBBadgesViewTypeDetail;
        badgesViewController.completedBadges = self.completedBadges;
        badgesViewController.remainingBadges = self.remainingBadges;
    }
    if ([segue.identifier isEqualToString:@"ShowSettings"]) {
        EBProfileSettingsViewController *settingsViewController = (EBProfileSettingsViewController *)[segue destinationViewController];

    }
    if ([segue.identifier isEqualToString:@"TasksEmbed"]) {
        EBTasksTableViewController *tasksViewController = (EBTasksTableViewController *)[segue destinationViewController];
        tasksViewController.tasksViewType = EBTasksViewTypeSmall;
    }
    if ([segue.identifier isEqualToString:@"TasksDetail"]) {
        EBTasksDetailViewController *tasksViewController = (EBTasksDetailViewController *)[segue destinationViewController];
        tasksViewController.tasks = self.tasks;
    }
    if ([segue.identifier isEqualToString:@"FriendsList"]) {
        EBFriendsContentTableViewController *friendsViewController = (EBFriendsContentTableViewController *)[segue destinationViewController];
        friendsViewController.friends = self.friends;
    }

}



@end
