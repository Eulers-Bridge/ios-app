//
//  EBTicketProfileViewController.h
//  Isegoria
//
//  Created by Alan Gao on 3/07/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EBTicketProfileViewController : UIViewController

@property (strong, nonatomic) NSDictionary *ticketData;
@property (strong, nonatomic) NSArray *candidates;
@property (strong, nonatomic) NSArray *tickets;
@property (strong, nonatomic) NSArray *positions;

@end
