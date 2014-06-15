//
//  EBElectionCandidateTableDataSource.m
//  Isegoria
//
//  Created by Alan Gao on 11/06/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBElectionCandidateTableDataSource.h"
#import "EBCandidateTableViewCell.h"

@implementation EBElectionCandidateTableDataSource

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.candidates = @[@{@"name": @"Lillian Adams",
                              @"description": @"This is a short description of the candidate."},
                            @{@"name": @"Juan Rivera",
                              @"description": @"This is a short description of the candidate."},
                            @{@"name": @"Richard Gonzales",
                              @"description": @"This is a short description of the candidate."},
                            @{@"name": @"Eva Menendez",
                              @"description": @"This is a short description of the candidate."},
                            @{@"name": @"Anthony Moore",
                              @"description": @"This is a short description of the candidate."},
                            @{@"name": @"Lisa Bennett",
                              @"description": @"This is a short description of the candidate."},
                            @{@"name": @"Emily Lee",
                              @"description": @"This is a short description of the candidate."},
                            @{@"name": @"Robert Watson",
                              @"description": @"This is a short description of the candidate."},
                            @{@"name": @"Jeffrey Young",
                              @"description": @"This is a short description of the candidate."}];
    }
    self.matchingCandidates = self.candidates;
    return self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.matchingCandidates count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EBCandidateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CandidateCell" forIndexPath:indexPath];
    cell.nameLabel.text = self.matchingCandidates[indexPath.row][@"name"];
    cell.descriptionTextView.text = self.matchingCandidates[indexPath.row][@"description"];
    cell.candidateImageView.image = [UIImage imageNamed:@"head1.jpg"];
    return cell;
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

@end
