//
//  EBTasksTableViewController.m
//  Isegoria
//
//  Created by Alan Gao on 1/07/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBTasksTableViewController.h"
#import "EBTaskTableViewCell.h"
#import "EBHelper.h"

@interface EBTasksTableViewController ()

@end

@implementation EBTasksTableViewController

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
    if (self.tasksViewType == EBTasksViewTypeSmall) {
        self.tableView.scrollEnabled = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTasksData:) name:@"TasksReturnedFromServer" object:nil];
    } else if (self.tasksViewType == EBTasksViewTypeDetail) {
        self.tableView.scrollEnabled = YES;
        self.tableView.contentInset = UIEdgeInsetsMake(61, 0, 0, 0);
    }
}

- (void)refreshTasksData:(NSNotification *)notification
{
    self.tasks = notification.userInfo[@"foundObjects"];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (self.tasksViewType == EBTasksViewTypeSmall) {
        return 1;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (self.tasksViewType == EBTasksViewTypeSmall) {
        return [self.tasks count];
    }
    return [self.tasks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EBTaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaskCell" forIndexPath:indexPath];
    cell.info = self.tasks[indexPath.row];
    [cell setup];
    
    
    return cell;
}

#pragma mark section header config
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *titleString;
    
    if (self.tasksViewType == EBTasksViewTypeDetail) {
        switch (section) {
                
            case 0:
                titleString = @"Completed";
                break;
                
            case 1:
                titleString = @"Remaining";
                break;
                
            default:
                titleString = @"";
                break;
        }
    } else if (self.tasksViewType == EBTasksViewTypeSmall) {
        titleString = @"TASKS";
    }

    return [EBHelper sectionTitleViewWithEnclosingView:self.tableView andText:titleString];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{

    NSString *titleString;

    if (self.tasksViewType == EBTasksViewTypeDetail) {
        switch (section) {
                
            case 0:
                titleString = @"Completed";
                break;
                
            case 1:
                titleString = @"Remaining";
                break;
                
            default:
                titleString = @"";
                break;
        }
    } else if (self.tasksViewType == EBTasksViewTypeSmall) {
        titleString = @"TASKS";
    }
    
    return titleString;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return SECTION_TITLE_VIEW_HEIGHT;
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
