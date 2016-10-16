//
//  EBAddContactTableViewController.m
//  Isegoria
//
//  Created by Alan Gao on 16/10/2016.
//  Copyright © 2016 Eulers Bridge. All rights reserved.
//

#import "EBAddContactTableViewController.h"
#import "EBNetworkService.h"
#import "EBFriendTableViewCell.h"
#import "EBHelper.h"
#import "UIImageView+AFNetworking.h"

@interface EBAddContactTableViewController () <UISearchBarDelegate, EBFriendServiceDelegate, EBFindFriendCellDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *contactSearchBar;
@property (strong, nonatomic) NSArray *matchingContacts;
@property (strong, nonatomic) EBNetworkService *service;

@end

@implementation EBAddContactTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.matchingContacts = [NSArray array];
    self.service = [[EBNetworkService alloc] init];
    self.service.friendDelegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.matchingContacts.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EBFriendTableViewCell *cell = (EBFriendTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"FriendCell" forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary *contact = self.matchingContacts[indexPath.row];
    cell.nameLabel.text = [EBHelper fullNameWithUserObject:contact];
    NSString *urlString = contact[@"profilePhoto"];
    if ([urlString class] != [NSNull class]) {
        [cell.profileImageView setImageWithURL:[NSURL URLWithString:urlString]];
    }
    [cell.actionButton setTitle:@"Add" forState:UIControlStateNormal];
    cell.actionButton.layer.borderColor = [ISEGORIA_LIGHT_GREY CGColor];
    cell.delegate = self;
    cell.contact = contact;
    return cell;
}

#pragma mark Network responses
- (void)findFriendWithNameFinishedWithSuccess:(BOOL)success withContacts:(NSArray *)contacts failureReason:(NSError *)error
{
    if (success) {
        self.matchingContacts = contacts;
        [self.tableView reloadData];
    } else {
        
    }
}

-(void)addFriendWithEmailFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error
{
    if (success) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Success" message:@"Request sent." preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:true];
        }]];
        [self presentViewController:alert animated:true completion:nil];
    } else {
        
    }
}

- (void)actionButtonTapped:(NSDictionary *)contact
{
    [self.service addFriendWithEmail:contact[@"email"]];
}

#pragma mark UISearchBar delegate

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.matchingContacts = [NSArray array];
    [self.tableView reloadData];
    // Network request for searching friend.
    if (searchText.length > 2) {
        [self.service findFriendWithName:searchText];
    }
//    [self updateData:searchText];
//    [self parseContacts:self.matchingContacts];
//    [self.tableView reloadData];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
//    [self updateData:searchBar.text];
//    [self parseContacts:self.matchingContacts];
//    [self.tableView reloadData];
//    [searchBar resignFirstResponder];
}

-(void)updateData:(NSString *)searchText
{
//    if ([searchText isEqualToString:@""]) {
//        self.matchingContacts = self.contacts;
//    } else {
//        NSMutableArray *matchingContacts = [NSMutableArray array];
//        for (NSDictionary *contact in self.contacts) {
//            if (contact[PERSON_NAME_PROPERTY]) {
//                NSString *name = [contact[PERSON_NAME_PROPERTY] lowercaseString];
//                if ([name rangeOfString:[searchText lowercaseString]].location != NSNotFound) {
//                    [matchingContacts addObject:contact];
//                }
//            }
//        }
//        self.matchingContacts = [matchingContacts copy];
//    }
}


- (NSMutableArray *)parseContacts:(NSArray *)contacts
{
//    NSMutableSet *mutableSet = [NSMutableSet set];
//    for (NSDictionary *person in contacts) {
//        if (person[PERSON_NAME_PROPERTY]) {
//            [mutableSet addObject:[person[PERSON_NAME_PROPERTY] substringToIndex:1]];
//        }
//    }
//    int i = 0;
//    NSArray *firstLetters = [[mutableSet allObjects] sortedArrayUsingSelector:@selector(localizedCompare:)];
//    self.firstLetters = firstLetters;
//    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:[firstLetters count]];
//    for (i = 0; i < [firstLetters count]; i += 1) {
//        [mutableArray addObject:[NSMutableArray array]];
//    }
//    for (NSDictionary *person in contacts) {
//        if (person[PERSON_NAME_PROPERTY]) {
//            for (i = 0; i < [firstLetters count]; i += 1) {
//                if ([[person[PERSON_NAME_PROPERTY] substringToIndex:1] isEqualToString:firstLetters[i]]) {
//                    [mutableArray[i] addObject:person];
//                }
//            }
//            
//        }
//    }
//    return mutableArray;
    return nil;
    
    //    self.parsedContacts = [@[@[self.contacts[0]], @[self.contacts[1]], @[self.contacts[2]]] mutableCopy];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
