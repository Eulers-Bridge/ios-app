//
//  EBGenderSelectorTableViewController.m
//  Isegoria
//
//  Created by Alan Gao on 24/6/19.
//  Copyright © 2019 Eulers Bridge. All rights reserved.
//

#import "EBGenderSelectorTableViewController.h"
#import "EBNetworkService.h"

@interface EBGenderSelectorTableViewController () <EBUserServiceDelegate>

@end

@implementation EBGenderSelectorTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    EBNetworkService *service = [[EBNetworkService alloc] init];
    service.userDelegate = self;
    if (indexPath.row == 0) {
        [service updateUserGender:@"Male"];
    } else if (indexPath.row == 1) {
        [service updateUserGender:@"Female"];
    } else if (indexPath.row == 2) {
        [service updateUserGender:@"Other"];
    }
}

-(void)updateUserGenderWithSuccess:(BOOL)success failureReason:(NSError *)error
{
    if (success) {
        [[[UIAlertView alloc] initWithTitle:@"Success" message:@"Gender set successfully." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please try again." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
    }
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
