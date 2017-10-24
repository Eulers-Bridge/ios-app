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
//@property (weak, nonatomic) IBOutlet EBCircleProgressBar *progressBar3;
//@property (weak, nonatomic) IBOutlet EBCircleProgressBar *progressBar4;

@property (weak, nonatomic) IBOutlet EBLabelLight *completedBadgesLabel;
@property (weak, nonatomic) IBOutlet EBLabelHeavy *totalBadgesLabel;

@property (weak, nonatomic) IBOutlet EBLabelLight *completedTasksLabel;
@property (weak, nonatomic) IBOutlet EBLabelHeavy *totalTasksLabel;



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
    self.showProgressButton.hidden = YES;
    self.tasksContainerView.hidden = YES;
    
    if (!self.isSelfProfile) {
        self.navigationItem.rightBarButtonItem = nil;
        self.tasksLoadingLabel.hidden = YES;
        self.showProgressButton.hidden = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self loadUserData];
    [self loadGroupsData];
    
    // Get Badges and tasks
//    [self getBadges];
//    [self getTasks];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.progressBar1 animate];
    [self.progressBar2 animate];
//    [self.progressBar3 animate];
//    [self.progressBar4 animate];
}

- (void)showSettings
{
    [self performSegueWithIdentifier:@"ShowSettings" sender:self];
}

- (void)setupData:(NSDictionary *)data
{
    self.data = data;
}

-(void)setupSelfProfileData:(NSDictionary *)data {
    self.completedTasksLabel.text = [NSString stringWithFormat:@"%d", [data[@"experience"] intValue] / 1000];
    if (data[@"numOfCompBadges"] == [NSNull null]){
        
    } else {
        self.completedBadgesLabel.text = [NSString stringWithFormat:@"%d", [data[@"numOfCompBadges"] intValue]];
        self.totalBadgesLabel.text = [NSString stringWithFormat:@"/%d", [data[@"totalBadges"] intValue]];
        self.totalTasksLabel.text = [NSString stringWithFormat:@"need %d", 1000 - [data[@"experience"] intValue] % 1000];
        self.progressBar1.progress = (double)([data[@"experience"] intValue] % 1000) / 1000.0;
        self.progressBar2.progress = (double)[[data[@"numOfCompBadges"] stringValue] doubleValue] / (double)[[data[@"totalBadges"] stringValue] doubleValue] ;
        [self.progressBar1 animate];
        [self.progressBar2 animate];
    }
}

- (void)loadUserData
{
    EBNetworkService *service = [[EBNetworkService alloc] init];
    service.friendDelegate = self;
    if (self.isSelfProfile) {
        [service getMyFriends];
    } else {
        [service getFriendsWithUserEmail:self.data[@"email"]];
    }
}

-(void)getFriendsWithUserEmailFinishedWithSuccess:(BOOL)success withContacts:(NSArray *)contacts failureReason:(NSError *)error
{
    if (success) {
        self.friendsLabel.text = [NSString stringWithFormat:@"%ld", contacts.count];
        self.friends = contacts;
        if (self.isSelfProfile) {
            self.friendsButton.enabled = YES;
        }
    } else {
        
    }
}

- (void)loadGroupsData
{
    EBNetworkService *service = [[EBNetworkService alloc] init];
    service.userDelegate = self;
    if (self.isSelfProfile) {
        [service getGroupsWithUserEmail:[EBUserService retriveUserEmail]];
    } else {
        [service getGroupsWithUserEmail:self.data[@"email"]];
    }
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
    self.totalBadgesLabel.hidden = YES;
    
    if (self.isSelfProfile) {
        EBNetworkService *service = [[EBNetworkService alloc] init];
        service.contentDelegate = self;
        [service getCompleteBadgesWithUserId:[EBHelper getUserId]];
        [service getRemainingBadgesWithUserId:[EBHelper getUserId]];
    } else {
        NSMutableArray *cBadges = [NSMutableArray array];
        NSMutableArray *rBadges = [NSMutableArray array];
        for (int i = 0; i < [self.data[@"numOfCompBadges"] intValue]; i++) {
            [cBadges addObject:[NSNumber numberWithInt:i]];
        }
        int numOfRemainingBadges = [self.data[@"totalBadges"] intValue] - [self.data[@"numOfCompBadges"] intValue];
        for (int i = 0; i < numOfRemainingBadges; i++) {
            [rBadges addObject:[NSNumber numberWithInt:i]];
        }
        self.completedBadges = [cBadges copy];
        self.remainingBadges = [rBadges copy];
        [self updateBadges];
    }
}

- (void)getTasks
{
    if (self.isSelfProfile) {
        EBNetworkService *service = [[EBNetworkService alloc] init];
        service.contentDelegate = self;
        [service getTasks];
    } else {
        self.completedTasksLabel.text = [self.data[@"numOfCompTasks"] stringValue];
        self.totalTasksLabel.text = [@"/" stringByAppendingString:[self.data[@"totalTasks"] stringValue]];
    }
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
        self.totalBadgesLabel.hidden = NO;
        self.progressBar2.progress = (float)[self.completedBadges count] / ((float)[self.completedBadges count] + (float)[self.remainingBadges count]);
        [self.progressBar2 animate];
        self.completedBadgesLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)[self.completedBadges count]];
        self.totalBadgesLabel.text = [NSString stringWithFormat:@"/%lu", (unsigned long)[self.remainingBadges count]];
        self.viewBadgesButton.enabled = self.isSelfProfile;
    }
}

- (void)updateTasks
{
    if (self.tasks) {
        self.showProgressButton.enabled = self.isSelfProfile;
        self.tasksLoadingLabel.hidden = YES;
//        self.tasksContainerView.hidden = NO;
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
