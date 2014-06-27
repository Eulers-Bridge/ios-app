//
//  EBCandidateCellDelegate.h
//  Isegoria
//
//  Created by Alan Gao on 26/06/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EBCandidateCellDelegate <NSObject>

- (void)candidateShowDetailWithIndex:(NSUInteger) index;

@end
