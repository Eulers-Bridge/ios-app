//
//  EBCandidateTableViewController.h
//  Isegoria
//
//  Created by Alan Gao on 27/06/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyConstants.h"

@interface EBCandidateTableViewController : UITableViewController

@property (strong, nonatomic) NSArray *candidates;
@property (strong, nonatomic) NSArray *tickets;
@property (strong, nonatomic) NSArray *positions;
@property (strong, nonatomic) NSArray *matchingCandidates;
@property EBCandidateFilter candidateFilter;
@property EBCandidateViewType candidateViewType;
@property int filterId;
@property (strong, nonatomic) NSString *filterTitle;

- (void)setup;

@end
