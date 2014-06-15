//
//  EBFindFriendViewController.m
//  EulersBridge
//
//  Created by Alan Gao on 1/05/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBFindFriendViewController.h"
#import "EBFindFriendTableViewCell.h"
#import "EBHelper.h"
@import AddressBook;

@interface EBFindFriendViewController () <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, EBFindFriendCellDelegate>

@property (strong, nonatomic) NSArray *contacts;
@property (weak, nonatomic) IBOutlet UITableView *contactsTableView;



@end

@implementation EBFindFriendViewController

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
    self.contacts = [NSArray array];
    [self getAddressBookContacts];
}

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
//    NSArray *allContacts = (__bridge NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBookRef);
//    for (id record in allContacts) {
//        ABRecordRef thisContact = (__bridge ABRecordRef)record;
//        NSString *name = (__bridge NSString *)ABRecordCopyCompositeName(thisContact);
//        [self.contacts addObject:name];
//    }
//    NSLog(@"%@", self.contacts);
    self.contacts = [[EBHelper contactsWithAddressBookRef:addressBookRef] copy];
    NSLog(@"%@", self.contacts);
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.contacts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EBFindFriendTableViewCell *cell = [self.contactsTableView dequeueReusableCellWithIdentifier:@"FindFriendCell"];
    
    cell.nameLabel.text = self.contacts[indexPath.row][PERSON_NAME_PROPERTY];
    cell.contact = self.contacts[indexPath.row];
    cell.delegate = self;
    return cell;
}


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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
