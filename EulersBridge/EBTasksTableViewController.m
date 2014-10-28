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
    } else if (self.tasksViewType == EBTasksViewTypeDetail) {
        self.tableView.scrollEnabled = YES;
        self.tableView.contentInset = UIEdgeInsetsMake(61, 0, 0, 0);
    }
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (self.tasksViewType == EBTasksViewTypeSmall) {
        return 5;
    }
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EBTaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaskCell" forIndexPath:indexPath];
    cell.titleLabel.text = @"Invite 5 Friends";
    cell.xpValueLabel.text = @"120 XP";
    cell.taskImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"task%lds", (long)indexPath.row]];
    
    
    return cell;
}

#pragma mark section header config
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.tasksViewType == EBTasksViewTypeDetail) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [EBHelper getScreenSize].width, 32)];
        headerView.backgroundColor = ISEGORIA_ULTRA_LIGHT_GREY;
        
        EBOnePixelLine *upperLine = [[EBOnePixelLine alloc] initWithFrame:CGRectMake(0, 0, [EBHelper getScreenSize].width, 1)];
        EBOnePixelLine *lowerLine = [[EBOnePixelLine alloc] initWithFrame:CGRectMake(0, headerView.bounds.size.height, [EBHelper getScreenSize].width, 1)];
        upperLine.backgroundColor = ONE_PIXEL_GREY;
        lowerLine.backgroundColor = ONE_PIXEL_GREY;
        [headerView addSubview:upperLine];
        [headerView addSubview:lowerLine];
        
        EBLabelHeavy *title = [[EBLabelHeavy alloc] initWithFrame:CGRectMake(8, 0, [EBHelper getScreenSize].width, 32)];
        title.font = [title.font fontWithSize:15];
        title.textColor = ISEGORIA_LIGHT_GREY;
        NSString *titleString = @"";
        switch (section) {
            case 0:
                titleString = @"Daily";
                break;
                
            case 1:
                titleString = @"Remaining";
                break;
            
            case 2:
                titleString = @"Completed";
                break;
                
            default:
                titleString = @"";
                break;
        }
        title.text = titleString;
        [headerView addSubview:title];
        
        return headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.tasksViewType == EBTasksViewTypeDetail) {
        return 32;
    }
    return 0;
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
