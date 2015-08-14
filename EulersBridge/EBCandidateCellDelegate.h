//
//  EBCandidateCellDelegate.h
//  Isegoria
//
//  Created by Alan Gao on 26/06/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EBCandidateTableViewCell.h"

@class EBCandidateTableViewCell;

@protocol EBCandidateCellDelegate <NSObject>

- (void)candidateShowDetailWithCell:(EBCandidateTableViewCell *) cell;

@end
