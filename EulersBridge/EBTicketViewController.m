//
//  EBTicketViewController.m
//  Isegoria
//
//  Created by Alan Gao on 16/08/2015.
//  Copyright (c) 2015 Eulers Bridge. All rights reserved.
//

#import "EBTicketViewController.h"
#import "EBCandidateTableViewController.h"

@interface EBTicketViewController ()

@property (weak, nonatomic) IBOutlet EBLabelHeavy *supportersNumberLabel;
@property (weak, nonatomic) IBOutlet EBLabelHeavy *memberNumberLabel;
@property (strong, nonatomic) NSDictionary *data;


@end

@implementation EBTicketViewController

- (void)setupData:(NSDictionary *)data
{
    self.data = data;
    self.supportersNumberLabel.text = [data[@"numberOfSupporters"] stringValue];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"TicketViewEmbed"]) {
        EBCandidateTableViewController *tvc = (EBCandidateTableViewController *)[segue destinationViewController];
        tvc.candidateFilter = EBCandidateFilterByTicket;
        tvc.candidateViewType = EBCandidateViewTypeTicketProfile;
        tvc.filterId = [self.data[@"ticketId"] intValue];
        tvc.filterTitle = self.data[@"name"];
        tvc.candidates = self.candidates;
        tvc.tickets = self.tickets;
        tvc.positions = self.positions;
    }
}

@end
