//
//  EBFriendsTableViewController.m
//  Isegoria
//
//  Created by Alan Gao on 12/06/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBFriendsTableViewController.h"
#import "EBFriendTableViewCell.h"
#import "EBHelper.h"
@import AddressBook;

@interface EBFriendsTableViewController () <EBFindFriendCellDelegate, UISearchBarDelegate>

@property (strong, nonatomic) NSArray *contacts;
@property (strong, nonatomic) NSArray *firstLetters;
@property (strong, nonatomic) NSMutableArray *parsedContacts;
@property (strong, nonatomic) NSArray *matchingContacts;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation EBFriendsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.contacts = [NSArray array];
    [self getAddressBookContacts];
    self.tableView.sectionIndexMinimumDisplayRowCount = 3;
    
    self.searchBar.delegate = self;
    self.searchBar.showsCancelButton = YES;
    self.matchingContacts = self.parsedContacts;
}

#pragma mark address book methods
- (void)getAddressBookContacts
{
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied ||
        ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusRestricted){
        //1
        NSLog(@"Denied");
        [self showAddressBookAuthError];
    } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized){
        //2
        NSLog(@"Authorized");
        [self readAllContacts];
    } else{ //ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined
        //3
        NSLog(@"Not determined");
        [self getAddressBookAuth];
    }
}

- (void)getAddressBookAuth
{
    ABAddressBookRequestAccessWithCompletion(ABAddressBookCreateWithOptions(NULL, nil), ^(bool granted, CFErrorRef error) {
        if (!granted){
            //4
            NSLog(@"Just denied");
            [self showAddressBookAuthError];
            return;
        }
        //5
        NSLog(@"Just authorized");
        [self readAllContacts];
    });
}



- (void)showAddressBookAuthError
{
    //    [[[UIAlertView alloc] initWithTitle:@"Cannot read contacts information" message:@"Please go to settings -> Privacy -> Contacts to change the setting." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
}

- (void)readAllContacts
{
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, nil);
    self.contacts = [[EBHelper contactsWithAddressBookRef:addressBookRef] copy];
    [self parseContacts:self.contacts];
//    NSLog(@"%@", self.contacts);
}

- (void)parseContacts:(NSArray *)contacts
{
    NSMutableSet *mutableSet = [NSMutableSet set];
    for (NSDictionary *person in contacts) {
        if (person[PERSON_NAME_PROPERTY]) {
            [mutableSet addObject:[person[PERSON_NAME_PROPERTY] substringToIndex:1]];
        }
    }
    int i = 0;
    NSArray *firstLetters = [[mutableSet allObjects] sortedArrayUsingSelector:@selector(localizedCompare:)];
    self.firstLetters = firstLetters;
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:[firstLetters count]];
    for (i = 0; i < [firstLetters count]; i += 1) {
        [mutableArray addObject:[NSMutableArray array]];
    }
    for (NSDictionary *person in contacts) {
        if (person[PERSON_NAME_PROPERTY]) {
            for (i = 0; i < [firstLetters count]; i += 1) {
                if ([[person[PERSON_NAME_PROPERTY] substringToIndex:1] isEqualToString:firstLetters[i]]) {
                    [mutableArray[i] addObject:person];
                }
            }
            
        }
    }
    self.parsedContacts = mutableArray;
    
//    self.parsedContacts = [@[@[self.contacts[0]], @[self.contacts[1]], @[self.contacts[2]]] mutableCopy];
}



#pragma mark UISearchBar delegate

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self updateData:searchText];
    [self parseContacts:self.matchingContacts];
    [self.tableView reloadData];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self updateData:searchBar.text];
    [self parseContacts:self.matchingContacts];
    [self.tableView reloadData];
    [searchBar resignFirstResponder];
}

-(void)updateData:(NSString *)searchText
{
    if ([searchText isEqualToString:@""]) {
        self.matchingContacts = self.contacts;
    } else {
        NSMutableArray *matchingContacts = [NSMutableArray array];
        for (NSDictionary *contact in self.contacts) {
            if (contact[PERSON_NAME_PROPERTY]) {
                NSString *name = [contact[PERSON_NAME_PROPERTY] lowercaseString];
                if ([name rangeOfString:[searchText lowercaseString]].location != NSNotFound) {
                    [matchingContacts addObject:contact];
                }
            }
        }
        self.matchingContacts = [matchingContacts copy];
    }
}




#pragma mark - Table view data source and delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.parsedContacts count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.parsedContacts[section] count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
//    return @[@"A", @"B", @"C"][section];
    return self.firstLetters[section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
//    return @[@"A", @"B", @"C"];
    return self.firstLetters;
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [self.firstLetters indexOfObject:title];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EBFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendCell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.nameLabel.text = self.parsedContacts[indexPath.section][indexPath.row][PERSON_NAME_PROPERTY];
    cell.subtitleLabel.text = @"Univeristy";
    cell.profileImageView.image = [UIImage imageNamed:@"head1.jpg"];
    cell.contact = self.parsedContacts[indexPath.section][indexPath.row];
    cell.delegate = self;
    return cell;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
