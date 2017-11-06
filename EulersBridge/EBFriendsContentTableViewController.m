//
//  EBFriendsContentTableViewController.m
//  Isegoria
//
//  Created by Alan Gao on 8/09/2015.
//  Copyright (c) 2015 Eulers Bridge. All rights reserved.
//

#import "EBFriendsContentTableViewController.h"
#import "EBNetworkService.h"
#import "EBHelper.h"
#import "EBUserService.h"
#import "EBFriendTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "EBUserService.h"
#import "EBContentViewController.h"

@interface EBFriendsContentTableViewController () <EBFindFriendCellDelegate, UISearchBarDelegate, UIAlertViewDelegate, EBUserServiceDelegate, EBFriendServiceDelegate>

@property (strong, nonatomic) NSArray *matchingFriends;
@property (strong, nonatomic) NSArray *friendRequests;
@property (strong, nonatomic) NSArray *friendRequestsPending;
//@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSMutableArray *networkServices;

@end

@implementation EBFriendsContentTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.searchBar.delegate = self;
//    self.searchBar.showsCancelButton = YES;
//    self.searchBar.hidden = YES;
    self.matchingFriends = self.friends;
    
    self.networkServices = [NSMutableArray array];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addFriend)];
    
//    [self loadNotifications];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self loadFriendRequests];
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    [self loadFriendRequests];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadFriendRequests];
}

- (void)loadFriendRequests
{
    EBNetworkService *service = [[EBNetworkService alloc] init];
    [self.networkServices addObject:service];
    service.friendDelegate = self;
    [service getFriendRequestReceived];
    [service getFriendRequestSent];
    [service getMyFriends];
}

-(void)getFriendRequestReceivedFinishedWithSuccess:(BOOL)success withRequests:(NSArray *)contacts failureReason:(NSError *)error
{
    [self.refreshControl endRefreshing];
    if (success) {
        NSMutableArray *newRequests = [NSMutableArray array];
        for (NSDictionary *contact in contacts) {
            if ([contact[@"accepted"] class] == [NSNull class]) {
                [newRequests addObject:contact];
            }
        }
        self.friendRequests = [newRequests copy];
        [self.tableView reloadData];
    }
}

-(void)getFriendRequestSentFinishedWithSuccess:(BOOL)success withRequests:(NSArray *)contacts failureReason:(NSError *)error
{
    [self.refreshControl endRefreshing];
    if (success) {
        NSMutableArray *newRequests = [NSMutableArray array];
        for (NSDictionary *contact in contacts) {
            if ([contact[@"accepted"] class] == [NSNull class]) {
                [newRequests addObject:contact];
            }
        }
        self.friendRequestsPending = [newRequests copy];
        [self.tableView reloadData];
    }
}

- (void)getFriendsWithUserEmailFinishedWithSuccess:(BOOL)success withContacts:(NSArray *)contacts failureReason:(NSError *)error
{
    [self.refreshControl endRefreshing];
    if (success) {
        self.friends = contacts;
        [self.tableView reloadData];
    }
}

- (void)loadNotifications
{
    EBNetworkService *service = [[EBNetworkService alloc] init];
    [self.networkServices addObject:service];
    service.userDelegate = self;
    [service getNotificationWithUserId:[EBHelper getUserId]];
}

-(void)getNotificationsWithUserIdFinishedWithSuccess:(BOOL)success withNotifications:(NSArray *)notifications failureReason:(NSError *)error
{
    if (success) {
        
    }
}

- (void)addFriendWithEmail:(NSString *)email
{
    EBNetworkService *service = [[EBNetworkService alloc] init];
    [self.networkServices addObject:service];
    service.friendDelegate = self;
    [service addFriendWithEmail:email];
}

- (void)addFriendWithEmailFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error
{
    if (success) {
        NSString *message = [NSString stringWithFormat:@"Your friend request for %@ is successfully sent.", info[@"contactDetails"]];
        [[[UIAlertView alloc] initWithTitle:@"Request Sent" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
        [self loadFriendRequests];
    } else {
        NSString *message = @"There is an error processing your request, please check the email address and try again.";
        [[[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Friend Requests";
    } else if (section == 1) {
        return @"Pending";
    } else {
        return @"Friends";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.friendRequests.count;
    } else if (section == 1) {
        return self.friendRequestsPending.count;
    } else {
        return self.friends.count;
    }
}

- (void)addFriend
{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add Friend" message:@"Please enter your friend's email address." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
//    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
//    [alert show];
    
    [self showViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"AddContact"] sender:self];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        UITextField *emailTextField = [alertView textFieldAtIndex:0];
        NSString *email = emailTextField.text;
        [self addFriendWithEmail:email];
    }
}

#pragma mark TableView delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EBFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendCell" forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        
        cell.requestActionView.hidden = NO;
        NSString *name = [EBHelper fullNameWithUserObject:self.friendRequests[indexPath.row][@"requesterProfile"]];
        NSString *email = self.friendRequests[indexPath.row][@"requesterProfile"][@"email"];
        cell.contact = self.friendRequests[indexPath.row][@"requesterProfile"];
        cell.nameLabel.text = name;
        cell.subtitleLabel.text = email;
//        cell.subtitleLabel.text = @"Institution";
        cell.requestId = self.friendRequests[indexPath.row][@"id"];
        
    } else if (indexPath.section == 1) {
        
        cell.requestActionView.hidden = YES;
        cell.viewDetailButton.hidden = YES;
        NSDictionary *friendObject = self.friendRequestsPending[indexPath.row][@"requestReceiverProfile"];
        NSString *fullName = [EBHelper fullNameWithUserObject:friendObject];
        cell.nameLabel.text = fullName;
        cell.subtitleLabel.text = @"Institution";
        cell.subtitleLabel.text = self.friendRequestsPending[indexPath.row][@"requestReceiverProfile"][@"email"];
        cell.requestId = self.friendRequestsPending[indexPath.row][@"nodeId"];
        
    } else if (indexPath.section == 2) {
        
        cell.requestActionView.hidden = YES;
        cell.viewDetailButton.hidden = NO;
        cell.contact = self.friends[indexPath.row];
        NSString *fullName = [EBHelper fullNameWithUserObject:self.friends[indexPath.row]];
        cell.nameLabel.text = fullName;
        cell.subtitleLabel.text = @"Institution";
        cell.subtitleLabel.text = self.friends[indexPath.row][@"requestReceiverProfile"][@"email"];
        
        if ([self.friends[indexPath.row][@"profilePhoto"] isKindOfClass:[NSDictionary class]]) {
            NSString *urlString = self.friends[indexPath.row][@"profilePhoto"][@"url"];
            [cell.profileImageView setImageWithURL:[NSURL URLWithString:urlString]];
            cell.contact = self.friends[indexPath.row];
        }
    }
    

    cell.delegate = self;
    return cell;
}


#pragma mark UISearchBar delegate

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self updateData:searchText];
    [self.tableView reloadData];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self updateData:searchBar.text];
    [self.tableView reloadData];
    [searchBar resignFirstResponder];
}

-(void)updateData:(NSString *)searchText
{
    if ([searchText isEqualToString:@""]) {
        self.matchingFriends = self.friends;
    } else {
        NSMutableArray *matchingFriends = [NSMutableArray array];
        for (NSDictionary *friend in self.friends) {
            NSString *fullName = [EBHelper fullNameWithUserObject:friend];
            if (fullName) {
                NSString *name = [fullName lowercaseString];
                if ([name rangeOfString:[searchText lowercaseString]].location != NSNotFound) {
                    [matchingFriends addObject:friend];
                }
            }
        }
        self.matchingFriends = [matchingFriends copy];
    }
}



#pragma  mark EBFindFriendCellDelegate

-(void)inviteFriendWithContact:(NSDictionary *)contact
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
    
    actionSheet.title = @"Please select contact method.";
    
    // Add contact methods to actionSheet.
    int i = 0;
    for (i = 0; i < [contact[PERSON_EMAILS_PROPERTY] count]; i += 1) {
        [actionSheet addButtonWithTitle:contact[PERSON_EMAILS_PROPERTY][i]];
    }
    for (i = 0; i < [contact[PERSON_PHONES_PROPERTY] count]; i += 1) {
        [actionSheet addButtonWithTitle:contact[PERSON_PHONES_PROPERTY][i]];
    }
    [actionSheet addButtonWithTitle:@"Input Email"];
    [actionSheet addButtonWithTitle:@"Input Phone number"];
    
    actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:@"Cancel"];
    
    [actionSheet  showInView:self.view];
}

- (void)acceptFriendWithRequestId:(NSString *)requestId
{
    EBNetworkService *service = [[EBNetworkService alloc] init];
    [self.networkServices addObject:service];
    service.friendDelegate = self;
    [service acceptFriendRequestWithRequestId:requestId];
}

- (void)rejectFriendWithRequestId:(NSString *)requestId
{
    EBNetworkService *service = [[EBNetworkService alloc] init];
    [self.networkServices addObject:service];
    service.friendDelegate = self;
    [service rejectFriendRequestWithRequestId:requestId];
}

- (void)actionButtonTapped:(NSDictionary *)contact
{
    // Show contact profile.
    EBContentViewController *contentVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ContentViewController"];
    contentVC.contentViewType = EBContentViewTypeProfile;
    contentVC.data = contact;
    [self showViewController:contentVC sender:self];
}

-(void)acceptFriendRequestFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error
{
    [self loadFriendRequests];
    if (success) {
        
    } else {
        
    }
}

- (void)rejectFriendRequestFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error
{
    [self loadFriendRequests];
    if (success) {
        
    } else {
        
    }

}

-(void)dealloc
{
    for (EBNetworkService *service in self.networkServices) {
        service.friendDelegate = nil;
        service.userDelegate = nil;
    }
}

@end
