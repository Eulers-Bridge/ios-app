//
//  EBElectionCandidateTableDataSource.h
//  Isegoria
//
//  Created by Alan Gao on 11/06/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EBElectionCandidateTableDataSource : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *candidates;
@property (strong, nonatomic) NSArray *matchingCandidates;

-(void)updateData:(NSString *)searchText;

@end
