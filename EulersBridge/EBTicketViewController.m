//
//  EBTicketViewController.m
//  Isegoria
//
//  Created by Alan Gao on 16/08/2015.
//  Copyright (c) 2015 Eulers Bridge. All rights reserved.
//

#import "EBTicketViewController.h"
#import "EBCandidateTableViewController.h"
#import "EBNetworkService.h"

@interface EBTicketViewController () <EBUserActionServiceDelegate>

@property (weak, nonatomic) IBOutlet EBLabelHeavy *supportersNumberLabel;
@property (weak, nonatomic) IBOutlet EBLabelHeavy *memberNumberLabel;
@property (strong, nonatomic) NSDictionary *data;
@property (weak, nonatomic) EBCandidateTableViewController *candidateTableView;


@end

@implementation EBTicketViewController

- (void)setupData:(NSDictionary *)data
{
    self.data = data;
    self.supportersNumberLabel.text = [data[@"numberOfSupporters"] stringValue];
    if (self.candidateTableView != nil) {
        self.candidateTableView.candidateFilter = EBCandidateFilterByTicket;
        self.candidateTableView.candidateViewType = EBCandidateViewTypeTicketProfile;
        self.candidateTableView.filterId = [self.data[@"ticketId"] intValue];
        self.candidateTableView.filterTitle = self.data[@"name"];
        self.candidateTableView.candidates = self.candidates;
        self.candidateTableView.tickets = self.tickets;
        self.candidateTableView.positions = self.positions;
        [self.candidateTableView setup];
        self.memberNumberLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.candidateTableView.matchingCandidates.count];
    }
}

- (IBAction)supportTicketAction:(UIButton *)sender {
    EBNetworkService *service = [[EBNetworkService alloc] init];
    service.userActionDelegate = self;
    [service supportTicketWithTicketId:self.data[@"ticketId"]];
}

- (void)supportTicketFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error {
    if (success) {
        
    } else {
        
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"TicketViewEmbed"]) {
        EBCandidateTableViewController *tvc = (EBCandidateTableViewController *)[segue destinationViewController];
        self.candidateTableView = tvc;
    }
}

@end
