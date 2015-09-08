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

@interface EBFriendsContentTableViewController () <EBFindFriendCellDelegate, UISearchBarDelegate, UIAlertViewDelegate, EBUserServiceDelegate>

@property (strong, nonatomic) NSArray *matchingFriends;
@property (strong, nonatomic) NSArray *contactRequests;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation EBFriendsContentTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.searchBar.delegate = self;
    self.searchBar.showsCancelButton = YES;
    self.matchingFriends = self.friends;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addFriend)];
    
    [self loadNotifications];
}

- (void)loadNotifications
{
    EBNetworkService *service = [[EBNetworkService alloc] init];
    service.userDelegate = self;
    [service getNotificationWithUserId:[EBHelper getUserId]];
}

-(void)getNotificationsWithUserIdFinishedWithSuccess:(BOOL)success withNotifications:(NSArray *)notifications failureReason:(NSError *)error
{
    if (success) {
        NSMutableArray *requests = [NSMutableArray array];
        for (NSDictionary *notification in notifications) {
            if ([notification[@"type"] isEqualToString:@"contactRequest"]) {
                [requests addObject:notification];
            }
        }
        self.contactRequests = [requests copy];
        [self.tableView reloadData];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Friend Requests";
    } else {
        return @"Friends";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.contactRequests.count;
    } else {
        return self.friends.count;
    }
}

- (void)addFriend
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add Friend" message:@"Please enter your friend's email address." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        UITextField *emailTextField = [alertView textFieldAtIndex:0];
        NSString *email = emailTextField.text;
        NSString *message = [NSString stringWithFormat:@"Your friend request for %@ is successfully sent.", email];
        [[[UIAlertView alloc] initWithTitle:@"Request Sent" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
        
    }
}

#pragma mark TableView delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EBFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendCell" forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        
        cell.nameLabel.text = self.contactRequests[indexPath.row][@"notificationBody"][@"contactDetails"];
        cell.subtitleLabel.text = @"Univeristy";
        
    } else if (indexPath.section == 1) {
        NSString *fullName = [EBHelper fullNameWithUserObject:self.friends[indexPath.row]];
        cell.nameLabel.text = fullName;
        cell.subtitleLabel.text = @"Univeristy";
        
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

@end
