//
//  EBCandidateTableViewController.m
//  Isegoria
//
//  Created by Alan Gao on 27/06/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBCandidateTableViewController.h"
#import "EBCandidateTableViewCell.h"
#import "EBCandidateCellDelegate.h"
#import "EBCandidateProfileViewController.h"

@interface EBCandidateTableViewController () <UISearchBarDelegate, EBCandidateCellDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *candidateSearchBar;
@property NSUInteger selectedCellIndex;

@end

@implementation EBCandidateTableViewController

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
    
    self.candidateSearchBar.delegate = self;
    self.candidateSearchBar.showsCancelButton = YES;
    self.tableView.contentOffset = CGPointMake(0, -108);
    
    self.candidates = @[@{@"id": @"0",
                          @"positionId": @"0",
                          @"ticketId": @"0",
                          @"name": @"Lillian Adams",
                          @"description": @"This is a short description of the candidate."},
                        @{@"id": @"1",
                          @"positionId": @"0",
                          @"ticketId": @"1",
                          @"name": @"Juan Rivera",
                          @"description": @"This is a short description of the candidate."},
                        @{@"id": @"2",
                          @"positionId": @"1",
                          @"ticketId": @"0",
                          @"name": @"Richard Gonzales",
                          @"description": @"This is a short description of the candidate."},
                        @{@"id": @"3",
                          @"positionId": @"1",
                          @"ticketId": @"1",
                          @"name": @"Eva Menendez",
                          @"description": @"This is a short description of the candidate."},
                        @{@"id": @"4",
                          @"positionId": @"2",
                          @"ticketId": @"0",
                          @"name": @"Anthony Moore",
                          @"description": @"This is a short description of the candidate."},
                        @{@"id": @"5",
                          @"positionId": @"3",
                          @"ticketId": @"1",
                          @"name": @"Lisa Bennett",
                          @"description": @"This is a short description of the candidate."},
                        @{@"id": @"6",
                          @"positionId": @"3",
                          @"ticketId": @"2",
                          @"name": @"Emily Lee",
                          @"description": @"This is a short description of the candidate."},
                        @{@"id": @"7",
                          @"positionId": @"4",
                          @"ticketId": @"2",
                          @"name": @"Robert Watson",
                          @"description": @"This is a short description of the candidate."},
                        @{@"id": @"8",
                          @"positionId": @"4",
                          @"ticketId": @"2",
                          @"name": @"Jeffrey Young",
                          @"description": @"This is a short description of the candidate."}];
    

    [self setup];
    self.matchingCandidates = self.candidates;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissKeyboard) name:@"CandidateCancelSearch" object:nil];
    
    // Gesture Recognizer
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self dismissKeyboard];
}
-(void)dismissKeyboard {
    [self.candidateSearchBar resignFirstResponder];
}

- (void)setup
{
    if (self.candidateFilter == EBCandidateFilterAll) {
        self.tableView.contentInset = UIEdgeInsetsMake(108.0, 0.0, 49.0, 0.0);
        return;
    }
    self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 49.0, 0.0);
    self.navigationItem.title = self.filterTitle;

    NSMutableArray *matchingCandidates = [NSMutableArray array];

    for (NSDictionary *candidate in self.candidates) {
        NSString *id = @"";
        if (self.candidateFilter == EBCandidateFilterByPosition) {
            id = candidate[@"positionId"];
        } else if (self.candidateFilter == EBCandidateFilterByTicket) {
            id = candidate[@"ticketId"];
        }
        if ([id intValue] == self.filterId) {
            [matchingCandidates addObject:candidate];
        }
    }
    self.candidates = [matchingCandidates copy];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.matchingCandidates count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EBCandidateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CandidateCell" forIndexPath:indexPath];
    cell.nameLabel.text = self.matchingCandidates[indexPath.row][@"name"];
    cell.descriptionTextView.text = self.matchingCandidates[indexPath.row][@"description"];
    NSString *imageName = [NSString stringWithFormat:@"candidate%@.jpg", self.matchingCandidates[indexPath.row][@"id"]];
    cell.candidateImageView.image = [UIImage imageNamed:imageName];
    cell.index = indexPath.row;
    cell.delegate = self;
    return cell;
}

#pragma mark cell selection by reveal button
-(void)candidateShowDetailWithIndex:(NSUInteger)index
{
    self.selectedCellIndex = index;
    [self performSegueWithIdentifier:@"showCandidateDetail" sender:nil];
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
        self.matchingCandidates = self.candidates;
    } else {
        NSMutableArray *matchingCandidates = [NSMutableArray array];
        for (NSDictionary *candidate in self.candidates) {
            NSString *name = [candidate[@"name"] lowercaseString];
            if ([name rangeOfString:[searchText lowercaseString]].location == NSNotFound) {
                
            } else {
                [matchingCandidates addObject:candidate];
            }
        }
        self.matchingCandidates = [matchingCandidates copy];
    }
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

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showCandidateDetail"]) {
        EBCandidateProfileViewController *detail = (EBCandidateProfileViewController *)[segue destinationViewController];
        detail.name = self.matchingCandidates[self.selectedCellIndex][@"name"];
        detail.imageName = [NSString stringWithFormat:@"candidate%@.jpg", self.matchingCandidates[self.selectedCellIndex][@"id"]];
    }
}

@end
