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
#import "EBNetworkService.h"
#import "EBHelper.h"
#import "UIImageView+AFNetworking.h"
#import "EBContentViewController.h"

@interface EBCandidateTableViewController () <UISearchBarDelegate, UIScrollViewDelegate, EBContentServiceDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *candidateSearchBar;
@property NSUInteger selectedCellIndex;

@property BOOL positionDataReady;
@property BOOL ticketDataReady;
@property BOOL candidateDataReady;

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
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.scrollEnabled = !(self.candidateViewType == EBCandidateViewTypeTicketProfile);
    
    self.candidateSearchBar.delegate = self;
    self.candidateSearchBar.showsCancelButton = YES;
    self.tableView.contentOffset = CGPointMake(0, -64);
    
    
//    self.candidates = @[@{@"id": @"0",
//                          @"positionId": @"0",
//                          @"positionTitle": @"President",
//                          @"ticketId": @"0",
//                          @"name": @"Lillian Adams",
//                          @"description": @"This is a short description of the candidate."},
//                        @{@"id": @"1",
//                          @"positionId": @"0",
//                          @"positionTitle": @"President",
//                          @"ticketId": @"1",
//                          @"name": @"Juan Rivera",
//                          @"description": @"This is a short description of the candidate."},
//                        @{@"id": @"2",
//                          @"positionId": @"1",
//                          @"positionTitle": @"Secretary",
//                          @"ticketId": @"0",
//                          @"name": @"Richard Gonzales",
//                          @"description": @"This is a short description of the candidate."},
//                        @{@"id": @"3",
//                          @"positionId": @"2",
//                          @"positionTitle": @"Women’s Officer",
//                          @"ticketId": @"1",
//                          @"name": @"Eva Menendez",
//                          @"description": @"This is a short description of the candidate."},
//                        @{@"id": @"4",
//                          @"positionId": @"1",
//                          @"positionTitle": @"Secretary",
//                          @"ticketId": @"0",
//                          @"name": @"Anthony Moore",
//                          @"description": @"This is a short description of the candidate."},
//                        @{@"id": @"5",
//                          @"positionId": @"3",
//                          @"positionTitle": @"LGBT Officer",
//                          @"ticketId": @"1",
//                          @"name": @"Lisa Bennett",
//                          @"description": @"This is a short description of the candidate."},
//                        @{@"id": @"6",
//                          @"positionId": @"3",
//                          @"positionTitle": @"LGBT Officer",
//                          @"ticketId": @"2",
//                          @"name": @"Emily Lee",
//                          @"description": @"This is a short description of the candidate."},
//                        @{@"id": @"7",
//                          @"positionId": @"4",
//                          @"positionTitle": @"Clubs and Societies",
//                          @"ticketId": @"2",
//                          @"name": @"Robert Watson",
//                          @"description": @"This is a short description of the candidate."},
//                        @{@"id": @"8",
//                          @"positionId": @"4",
//                          @"positionTitle": @"Clubs and Societies",
//                          @"ticketId": @"2",
//                          @"name": @"Jeffrey Young",
//                          @"description": @"This is a short description of the candidate."},
//                        @{@"id": @"9",
//                          @"positionId": @"5",
//                          @"positionTitle": @"Environmental Officer",
//                          @"ticketId": @"3",
//                          @"name": @"Christine Robinson",
//                          @"description": @"This is a short description of the candidate."},
//                        @{@"id": @"10",
//                          @"positionId": @"5",
//                          @"positionTitle": @"Environmental Officer",
//                          @"ticketId": @"4",
//                          @"name": @"Sandra Taylor",
//                          @"description": @"This is a short description of the candidate."},
//                        @{@"id": @"11",
//                          @"positionId": @"6",
//                          @"positionTitle": @"Welfare Officer",
//                          @"ticketId": @"5",
//                          @"name": @"Elizabeth Henderson",
//                          @"description": @"This is a short description of the candidate."},
//                        @{@"id": @"12",
//                          @"positionId": @"6",
//                          @"positionTitle": @"Welfare Officer",
//                          @"ticketId": @"3",
//                          @"name": @"Sara Stewart",
//                          @"description": @"This is a short description of the candidate."},
//                        @{@"id": @"13",
//                          @"positionId": @"7",
//                          @"positionTitle": @"Creative Arts Officer",
//                          @"ticketId": @"4",
//                          @"name": @"Lin Xiao",
//                          @"description": @"This is a short description of the candidate."},
//                        @{@"id": @"14",
//                          @"positionId": @"7",
//                          @"positionTitle": @"Creative Arts Officer",
//                          @"ticketId": @"5",
//                          @"name": @"David Johnson",
//                          @"description": @"This is a short description of the candidate."},
//                        @{@"id": @"15",
//                          @"positionId": @"8",
//                          @"positionTitle": @"Faculty Liaison",
//                          @"ticketId": @"6",
//                          @"name": @"Martha Sanchez",
//                          @"description": @"This is a short description of the candidate."}];
//    

//    self.matchingCandidates = self.candidates;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissKeyboard) name:@"CandidateCancelSearch" object:nil];
    
    if (self.candidateFilter == EBCandidateFilterAll) {
        
        self.candidateDataReady = NO;
        self.ticketDataReady = NO;
        self.positionDataReady = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCandidateData:) name:@"CandidatesReturnedFromServer" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTicketData:) name:@"TicketsReturnedFromServer" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPositionData:) name:@"PositionsReturnedFromServer" object:nil];

    }
    
    
    // Gesture Recognizer
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    if (self.candidateFilter == EBCandidateFilterByTicket || self.candidateFilter == EBCandidateFilterByPosition) {
        self.candidateDataReady = YES;
        self.ticketDataReady = YES;
        self.positionDataReady = YES;
        [self.tableView setContentOffset:CGPointMake(0, 44)];
    }
    
    [self setup];

}

- (void)refreshCandidateData:(NSNotification *)notification
{
    self.candidates = (NSArray *)notification.userInfo[@"foundObjects"];
    self.candidateDataReady = YES;
    [self setup];
}

- (void)refreshTicketData:(NSNotification *)notification
{
    self.tickets = (NSArray *)notification.userInfo[@"foundObjects"];
    self.ticketDataReady = YES;
    [self setup];
}

- (void)refreshPositionData:(NSNotification *)notification
{
    self.positions = (NSArray *)notification.userInfo[@"foundObjects"];
    self.positionDataReady = YES;
    [self setup];
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
        if (self.positionDataReady && self.ticketDataReady && self.candidateDataReady) {
            self.candidates = [self processCandidateDataWithCandidates:self.candidates Positions:self.positions Tickets:self.tickets];
            self.matchingCandidates = self.candidates;
            [self.tableView reloadData];
        } else {
            return;
        }
        
        return;
    }
    
    self.candidates = [self processCandidateDataWithCandidates:self.candidates Positions:self.positions Tickets:self.tickets];
    self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 49.0, 0.0);
    self.navigationItem.title = self.filterTitle;

    NSMutableArray *matchingCandidates = [NSMutableArray array];

    for (NSDictionary *candidate in self.candidates) {
        NSString *_id = @"";
        if (self.candidateFilter == EBCandidateFilterByPosition) {
            _id = candidate[@"candidateData"][@"positionId"];
        } else if (self.candidateFilter == EBCandidateFilterByTicket) {
            _id = candidate[@"candidateData"][@"ticketId"];
        }
        if (_id != [NSNull null]) {
            if ([_id intValue] == self.filterId) {
                [matchingCandidates addObject:candidate];
            }
        }
    }
    self.candidates = [matchingCandidates copy];
    self.matchingCandidates = self.candidates;
    [self.tableView reloadData];
}

- (NSArray *)processCandidateDataWithCandidates:(NSArray *)candidates Positions:(NSArray *)positions Tickets:(NSArray *)tickets
{
    NSMutableArray *newCandidates = [NSMutableArray arrayWithCapacity:candidates.count];
    for (NSDictionary *candidate in candidates) {
        NSDictionary *positionData = @{};
        NSDictionary *ticketData = @{};
        NSDictionary *candidateData = [candidate copy];
        // Find position and ticket data
        for (NSDictionary *position in positions) {
            if (position[@"positionId"] != [NSNull null] && candidate[@"positionId"] != [NSNull null]) {
                if ([position[@"positionId"] integerValue] == [candidate[@"positionId"] integerValue]) {
                    positionData = [position copy];
                }
            }
        }
        for (NSDictionary *ticket in tickets) {
            if (ticket[@"ticketId"] != [NSNull null] && candidate[@"ticketId"] != [NSNull null]) {
                if ([ticket[@"ticketId"] integerValue] == [candidate[@"ticketId"] integerValue]) {
                    ticketData = [ticket copy];
                }
            }
        }
        NSDictionary *newCandidate = @{@"candidateData": candidateData,
                                       @"positionData": positionData,
                                       @"ticketData": ticketData};
        [newCandidates addObject:newCandidate];
    }
    return [newCandidates copy];
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
    EBCandidateTableViewCell *cell;
    NSDictionary *data = self.matchingCandidates[indexPath.row];
    if (self.candidateFilter == EBCandidateFilterByTicket || self.candidateFilter == EBCandidateFilterAll) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CandidateCellSmall" forIndexPath:indexPath];
        cell.subtitleLabel.text = data[@"positionData"][@"name"];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CandidateCell" forIndexPath:indexPath];
        if (data[@"candidateData"][@"policyStatement"] != [NSNull null]) {
            cell.descriptionTextView.text = data[@"candidateData"][@"policyStatement"];
        }
    }
    
    cell.nameLabel.text = [EBHelper fullNameWithUserObject:data[@"candidateData"]];
    if (data[@"ticketData"][@"code"] != [NSNull null]) {
        cell.codeLabel.text = data[@"ticketData"][@"code"];
    }
    if (data[@"colour"] != [NSNull null] && data[@"ticketData"][@"colour"] != [NSNull null]) {
        cell.codeLabel.backgroundColor = UIColorFromRGB([EBHelper hexFromString:[data[@"ticketData"][@"colour"] substringFromIndex:1]]);
    } else {
        cell.codeLabel.backgroundColor = [UIColor grayColor];
    }
    
    

//    NSString *imageName = [NSString stringWithFormat:@"candidate%@.jpg", self.matchingCandidates[indexPath.row][@"id"]];
    if (self.matchingCandidates[indexPath.row][@"candidateData"][@"photos"] != [NSNull null]) {
        NSString *urlString = self.matchingCandidates[indexPath.row][@"candidateData"][@"photos"][0][@"url"];
        [cell.candidateImageView setImageWithURL:[NSURL URLWithString:urlString]];
    }
    cell.index = indexPath.row;
//    cell.delegate = self;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.candidateFilter == EBCandidateFilterByTicket || self.candidateFilter == EBCandidateFilterAll) {
        return 44;
    }
    return 150;
}

#pragma mark cell selection by cell selection
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EBCandidateTableViewCell *cell = (EBCandidateTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    [cell revealButtonPressed];
    
    self.selectedCellIndex = [self.tableView indexPathForCell:cell].row;
    EBContentViewController *content = [self.storyboard instantiateViewControllerWithIdentifier:@"ContentViewController"];
    content.contentViewType = EBContentViewTypeCandidateDescription;
    content.data = self.matchingCandidates[self.selectedCellIndex][@"candidateData"];
    content.image = cell.candidateImageView.image;
    [self.navigationController pushViewController:content animated:YES];
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
            NSString *name = [[EBHelper fullNameWithUserObject:candidate[@"candidateData"]] lowercaseString];
            if ([name rangeOfString:[searchText lowercaseString]].location == NSNotFound) {
                
            } else {
                [matchingCandidates addObject:candidate];
            }
        }
        self.matchingCandidates = [matchingCandidates copy];
    }
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showCandidateDetail"]) {
        EBCandidateProfileViewController *detail = (EBCandidateProfileViewController *)[segue destinationViewController];
        detail.name = [EBHelper fullNameWithUserObject:self.matchingCandidates[self.selectedCellIndex][@"candidateData"]];
        // fix the photo names.
        detail.imageUrl = self.matchingCandidates[self.selectedCellIndex][@"candidateData"][@"photos"][0][@"url"];
    }
}

@end
