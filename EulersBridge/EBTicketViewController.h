//
//  EBTicketViewController.h
//  Isegoria
//
//  Created by Alan Gao on 16/08/2015.
//  Copyright (c) 2015 Eulers Bridge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EBContentDetail.h"

@interface EBTicketViewController : UIViewController <EBContentDetail>

@property (strong, nonatomic) NSArray *candidates;
@property (strong, nonatomic) NSArray *tickets;
@property (strong, nonatomic) NSArray *positions;

- (void)setupData:(NSDictionary *)data;

@end
